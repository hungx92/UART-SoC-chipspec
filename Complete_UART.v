`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: Complete_UART.v
// Project: 3
// Created by <Hung Le> on <April 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This top module instantiates the Project3 Top level along with TSI.
//	All I/O from Proj3 top will go through TSI and transmitted externally. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module Complete_UART(clk, rst, sw, led, TX, RX);
	input clk, rst, RX; 
	input [7:0] sw;
	
	output TX;
	output [15:0] led;
	
	wire clk_buf, rst_buf, RX_buf, TX_buf;
	wire [7:0] sw_buf;
	wire [15:0] led_buf;
	Project3_top proj3(.clk(clk_buf), 
							 .rst(rst_buf), 
							 .led(led_buf), 
							 .sw(sw_buf), 
							 .Tx(TX_buf), 
							 .Rx(RX_buf));
	
	
	TSI TSI0 (.clk_in(clk), 
				 .rst_in(rst), 
				 .sw_in(sw), 
				 .RX_in(RX), 
				 .TX_in(TX_buf), 
				 .led_in(led_buf), 
				 .clk_out(clk_buf), 
				 .rst_out(rst_buf), 
				 .RX_out(RX_buf), 
				 .TX_out(TX), 
				 .sw_out(sw_buf), 
				 .led_out(led));
endmodule
