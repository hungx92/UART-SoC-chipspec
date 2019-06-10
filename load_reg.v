`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: load_reg.v
// Project: Lab 1
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This is a register with loading capability when load signal is high. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module load_reg(clk, rst, load, D, Q);
	input clk, rst, load; 
	input [7:0] D;
	
	output reg [7:0] Q; 
	
	always @ (posedge clk, posedge rst)
		if (rst)     Q <= 8'b0;
		else begin
			if (load) Q <= D;
			else      Q <= Q; 
		end
endmodule
