`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: rs_flop.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module outputs 1 when r = 0 & s = 1. Stay the same when r = 0 &
// s = 0. Output 0 otherwise. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module rs_flop(clk,rst,r,s,Q);
	input clk, rst, r, s;
	output reg Q;
	
	always @ (posedge clk, posedge rst)
		if(rst) Q <= 1'b0;
		else 
			case ({s,r})
				2'b00:	Q <= Q;
				2'b10: 	Q <= 1'b1;
				2'b01: 	Q <= 1'b0;
				default: Q <= 1'b0;
			endcase 



endmodule
