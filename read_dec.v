`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: read_dec.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module is a 3-8 decoder with 2 enable signals. EN is low active.
// r_strobe is high active. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module read_dec(r_strobe, EN, S, read);
	input r_strobe, EN;
	input [2:0] S;
	
	output reg [7:0]read; 
	
	always @ (*)
		casex({EN, r_strobe, S})
			5'b1_?_???: read = 8'b0;
			5'b1_0_???: read = 8'b0;
			5'b0_1_000: read = 8'b0000_0001;
			5'b0_1_001: read = 8'b0000_0010;
			5'b0_1_010: read = 8'b0000_0100;
			5'b0_1_011: read = 8'b0000_1000;
			5'b0_1_100: read = 8'b0001_0000;
			5'b0_1_101: read = 8'b0010_0000;
			5'b0_1_110: read = 8'b0100_0000;
			5'b0_1_111: read = 8'b1000_0000;
			default read = 8'b0;
		endcase 
endmodule
