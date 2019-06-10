`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: Project3_top.v
// Project: 3
// Created by <Hung Le> on <April 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This top module instantiates the TramelBlaze and the UART, along with 
// two 3-8 decoders and AISO. Loadable register controls the output to the LED. 
//	When TramelBlaze outputs to addres 0002, then it is data for LEDs. The two 
// decoders generate 8-bit read and write signals to the UART. TramelBlaze 
// receives data from UART and tranmits data to the UART. Interrupt will be sent 
// to the processor whenever UART is ready to transmit or receive. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module Project3_top(clk, rst, led, sw, Tx, Rx);
	input clk, rst, Rx; 
	input [7:0] sw;
	
	output reg [15:0] led;
	output Tx;
	
	wire r_sync, interrupt, int_ack, write_strobe, read_strobe; 
	wire [7:0] read, write;
	wire [15:0] to_tb, from_tb, port_id;
	
	/*****************************************************************/
	//LED output
	/*****************************************************************/
	always @ (posedge clk, posedge rst)
		if(rst)
			led <= 16'b0;
		else 
			if(write[2])
				led <= from_tb;
			else
				led <= led;	
	
	/*****************************************************************/
	//Generate synchronous reset
	/*****************************************************************/
	AISO rsync0 (.clk(clk), 
				    .reset(rst), 
					 .reset_sync(r_sync)) ;
	
	
	wire [15:0] tb_in, ram_out;
	assign tb_in = (port_id[15] & read_strobe)? ram_out : to_tb; 
	/*****************************************************************/
	//TramelBlaze processor
	/*****************************************************************/
	tramelblaze_top blaze_0(.CLK(clk), 
						         .RESET(r_sync), 
									.IN_PORT(tb_in), 
									.INTERRUPT(interrupt), 
                           .OUT_PORT(from_tb), 
									.PORT_ID(port_id), 
									.READ_STROBE(read_strobe), 
									.WRITE_STROBE(write_strobe), 
									.INTERRUPT_ACK(int_ack));
									
	/*****************************************************************/
	//3-8 decoders to generate read and write sigals
	/*****************************************************************/
	read_dec read0(.r_strobe(read_strobe), 
				      .EN(port_id[15]), 
						.S(port_id[2:0]), 
						.read(read));
	
	write_dec write0(.wr_strobe(write_strobe), 
					     .EN(port_id[15]), 
						  .S(port_id[2:0]), 
						  .write(write));
	
	/*****************************************************************/
	//	UART
	// input: clk, rst, int_ack, read, write, sw, rx, out_port
	//	output: interrupt, in_port, tx		
	/*****************************************************************/
	UART_top UART0(.clk(clk), 
						.rst(r_sync), 
						.int_ack(int_ack), 
						.write(write), 
						.out_port(from_tb), 
						.read(read), 
						.rx(Rx), 
						.sw(sw), 
						.interrupt(interrupt), 
						.tx(Tx), 
						.in_port(to_tb));
						
	/*****************************************************************/
	//32768 x 16 RAM 
	/*****************************************************************/
	RAM SRAM0 (.addra(port_id[14:0]),
				  .dina(from_tb),
				  .wea(port_id[15]),
				  .clka(clk),
				  .douta(ram_out));
	
	
endmodule
