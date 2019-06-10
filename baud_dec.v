`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: baud_dec.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: This module generates a count value base on the 4-bit baud_val input.
//	Each count value is associated with a baud_rate with the 100MHz clock.   
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module baud_dec(baud_val, k);
	input [3:0] baud_val;
	
	output reg [18:0] k;

	always @ (*)begin						 //Nexys 4
		case(baud_val)						 //Baud rate 
			4'b0000: k = 19'd333_333;   //    300
			4'b0001: k = 19'd83_333;	 //  1_200
			4'b0010: k = 19'd41_667;	 //  2_400
			4'b0011: k = 19'd20_833;    //  4_800
			4'b0100: k = 19'd10_417;	 //  9_600
			4'b0101: k = 19'd5_208;	    // 19_200
			4'b0110: k = 19'd2_604;     // 38_400
			4'b0111: k = 19'd1_736;	    // 57_600
			4'b1000: k = 19'd868;		 //115_200
			4'b1001: k = 19'd434;		 //230_400
			4'b1010: k = 19'd217;		 //460_800
			4'b1011: k = 19'd109;		 //921_600
			
			default: k = 19'd333_333;
		endcase
	end

endmodule
