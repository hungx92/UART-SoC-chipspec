`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: UART_top.v
// Project: 3
// Created by <Hung Le> on <April 16, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module instantiates transmit and receive engine along with combo 
//	blocks to generate control signals. Read[2:0] determines the output of the UART.
//	Read[0] outputs rx_data, read[1] outputs status of UART, read[2] outputs switch
// config. Interrupt will be generated when there is a txrdy signal or rxrdy signal.
// LED controls is outputted to address 0002. TX outputs to address 0000. RX receives 
//	from address 0000. Configuration comes address 0006. baud val = outport[7:4].
//	eight pen ohel = outport[3:1] respectively.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module UART_top(clk, rst, int_ack, write, out_port, read, rx, sw, interrupt, tx, 
					 in_port);
	input clk, rst, int_ack, rx; 
	input [7:0] read, write, sw;
	input [15:0] out_port; 
	
	output interrupt, tx; 
	output reg [15:0] in_port; 
	
	/*****************************************************************/
	//Baud
	/*****************************************************************/
	reg [7:0] uart_config;
	wire [18:0] k, k_half;
	always @ (posedge clk, posedge rst) 
		if (rst)
			uart_config <= 8'b0;
		else 
			if (write[6])
				uart_config <= out_port[7:0]; 
			else 
				uart_config <= uart_config;
	
	
	baud_dec baud0(.baud_val(uart_config[7:4]), 
						.k(k));
	assign k_half = k >> 1;
	/*****************************************************************/
	//Transmit
	/*****************************************************************/
	wire txrdy; 
	Transmit tx0(.clk(clk), 
					 .rst(rst), 
					 .write(write[0]), 
					 .eight(uart_config[3]), 
					 .pen(uart_config[2]), 
					 .ohel(uart_config[1]), 
					 .TXRDY(txrdy), 
					 .TX(tx), 
					 .out_port(out_port[7:0]), 
					 .k(k));
					 
	/*****************************************************************/
	//Receive
	/*****************************************************************/
	wire rxrdy, ovf, ferr, perr;
	wire [7:0] rx_data;
	Receive rx0(.clk(clk), 
				   .rst(rst), 
					.k(k), 
					.k_half(k_half), 
					.eight(uart_config[3]), 
					.pen(uart_config[2]), 
					.ohel(uart_config[1]), 
					.read(read), 
					.RX(rx), 
					.rxrdy(rxrdy),
					.OVF(ovf), 
					.FERR(ferr), 
					.PERR(perr), 
					.rx_data(rx_data));
	/*****************************************************************/
	//Inport combo
	/*****************************************************************/
	wire [7:0] status;
	assign status = {3'b0,ovf,ferr,perr,txrdy,rxrdy};
	
	always @ (*)
		case(read[2:0])
			3'b001: in_port = {8'b0,rx_data};
			3'b010: in_port = {8'b0,status};
			3'b100: in_port = {8'b0,sw}; 
			default: in_port = 16'b0; 
		endcase
	
	/*****************************************************************/
	//Interrupt generate
	/*****************************************************************/
	wire int_set, rx_ped, tx_ped; 
	assign int_set = rx_ped | tx_ped;
	posedge_detect tx_ped0(.clk(clk), 
							     .reset(rst), 
							     .IN(txrdy), 
							     .ped(tx_ped));
								  
	posedge_detect rx_ped0(.clk(clk), 
							     .reset(rst), 
							     .IN(rxrdy), 
							     .ped(rx_ped));
	
	rs_flop int0(.clk(clk),
					 .rst(rst),
					 .r(int_ack),
					 .s(int_set),
					 .Q(interrupt));
endmodule

