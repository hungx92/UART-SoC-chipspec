`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: posedge_detect.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module will detect a change from 0 to 1 of the IN input  
// and create a one clock wide pulse.  
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////
module posedge_detect(clk, reset, IN, ped);
	input  wire clk , reset ;
	input	 wire IN  ;
	output wire ped ;
	
	reg Q1, Q2 ;
	
	always @ (posedge clk, posedge reset)
		if (reset)
			{Q1,Q2} <= 2'b0;
		else
			{Q1,Q2} <= {IN,Q1};
	
	assign ped = Q1 & ~Q2; 
	

endmodule
