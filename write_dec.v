`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: write_dec.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module is a 3-8 decoder with 2 enable signals. EN is low active.
// wr_strobe is high active. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module write_dec(wr_strobe, EN, S, write);
	input wr_strobe, EN;		//EN low-active
	input [2:0] S;				//3-bit from outport[2:0]
	
	output reg [7:0] write; 
	
	always @ (*)
		casex({EN, wr_strobe, S})
			5'b1_?_???: write = 8'b0;
			5'b1_0_???: write  = 8'b0;
			5'b0_1_000: write  = 8'b0000_0001;
			5'b0_1_001: write  = 8'b0000_0010;
			5'b0_1_010: write  = 8'b0000_0100;
			5'b0_1_011: write  = 8'b0000_1000;
			5'b0_1_100: write  = 8'b0001_0000;
			5'b0_1_101: write  = 8'b0010_0000;
			5'b0_1_110: write  = 8'b0100_0000;
			5'b0_1_111: write  = 8'b1000_0000;
			default write  = 8'b0;
		endcase

endmodule
