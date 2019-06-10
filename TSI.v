`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: TSI.v
// Project: 3
// Created by <Hung Le> on <April 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module instantiates buffers to transfer external data into the 
// the design. Once data has been compiled, the output will once again go through
//	the TSI to be exported to the device.  
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module TSI(clk_in, rst_in, sw_in, RX_in, TX_in, led_in, clk_out, rst_out, RX_out, 
			  TX_out, sw_out, led_out);
			  
	input clk_in, rst_in, RX_in, TX_in;
	input [7:0] sw_in;
	input [15:0] led_in; 
	
	output clk_out, rst_out, TX_out, RX_out;
	output [7:0] sw_out; 
	output [15:0] led_out;
		
	BUFG CLK_BUFG (.O(clk_out), .I(clk_in));

	IBUF# (.IOSTANDARD("DEFAULT"), .IBUF_LOW_PWR("TRUE"))
			RST_BUF(.O(rst_out), .I(rst_in));
			
	IBUF# (.IOSTANDARD("DEFAULT"), .IBUF_LOW_PWR("TRUE"))
			RX_BUF(.O(RX_out), .I(RX_in));
			
	IBUF# (.IOSTANDARD("DEFAULT"), .IBUF_LOW_PWR("TRUE"))
			SW_BUF[7:0](.O(sw_out[7:0]), .I(sw_in[7:0]));
			
	OBUF# (.IOSTANDARD("DEFAULT"), .SLEW("TRUE"), .DRIVE(12))
			LED[15:0](.O(led_out[15:0]), .I(led_in[15:0]));
			
	OBUF# (.IOSTANDARD("DEFAULT"), .SLEW("TRUE"), .DRIVE(12))
			TX_BUF(.O(TX_out), .I(TX_in));
endmodule
