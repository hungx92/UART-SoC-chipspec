`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: AISO.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module extends the reset signal to account for			  
// metastability when the reset is released, so all modules can  
// receive the reset signal at the same time. It performs this   
// by implementing 2 dlops, tying the input of the first flop    
// to 1 and inverting the output of the second flop. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module AISO ( clk , reset , reset_sync ) ;
	// Input and Output declarations
	input      clk       , reset;
	output   wire  reset_sync;
	
	// Wire declarations to interconnect
	reg Q1 , Q2 ;
	
	always @ (posedge clk, posedge reset)
		if (reset)
			{Q1, Q2} <= 2'b0;
		else
			{Q1, Q2} <= {1'b1, Q1};
		  
	assign reset_sync = ~Q2;

endmodule
