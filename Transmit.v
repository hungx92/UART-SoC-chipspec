`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This document contains information prorietary to the CSULB student that created
// the file -  any reuse without adequate approval and documentation is prohibited
//
// File Name: Transmit.v
// Project: 2
// Created by <Hung Le> on <Feb 7, 2019>
// Copright @ 2019 <Hung Le>. All rights reserved
//
// Purpose: The transmit engine takes input of 8-bits and output it one bit at 
// at a time. The output speed can be controlled by baud_val input. When the 
//	the engine is ready to transmit data, the TXRDY signal will go low for one 
//	clock. The engine allows for parity of the input data with the ability to 
//	choose between 8-bit or 7-bit input, odd or even parity.  
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. 
// 
// In submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
//////////////////////////////////////////////////////////////////////////////////
module Transmit(clk, rst, write, eight, pen, ohel, TXRDY, TX, out_port, k);
	input clk, rst, write;
	input eight, pen, ohel;
	input [7:0] out_port;
	
	input [18:0] k;
	
	output reg TXRDY;
	output wire TX;
	
	wire BTU;
	wire [7:0]LOAD_DATA;
	
	wire DONE; 
	reg DONE_D1;
	reg D_10, D_9;
	reg write_D1;
	reg [18:0] D1, Q1;
	reg [3:0]  D2, Q2;
	
	rs_flop do_flop	(.clk(clk),
							 .rst(rst),
							 .r(DONE),
							 .s(write),
							 .Q(DoIT));
	
	load_reg ld_data(.clk(clk), 
						  .rst(rst), 
						  .load(write), 
						  .D(out_port), 
						  .Q(LOAD_DATA));
						  

	/////////////////////////////////////////////////
	//Txrdy r-s flop
	//reset will set txrdy to 1
	/////////////////////////////////////////////////	
	always @ (posedge clk, posedge rst)
		if(rst)
			TXRDY <= 1'b1;
		else
			case({DONE_D1,write})
				2'b00: TXRDY <= TXRDY;
				2'b10: TXRDY <= 1'b1;
				2'b01: TXRDY <= 1'b0;
				
				default: TXRDY <= 1'b0;
			endcase
	
	/////////////////////////////////////////////////
	//Bit-time counter 
	/////////////////////////////////////////////////	
	assign BTU = (Q1 == k);
	always @(*) 
		case ({DoIT, BTU}) 
			2'b00: D1 = 19'b0;
			2'b01: D1 = 19'b0;
			2'b10: D1 = Q1 + 19'b1;
			2'b11: D1 = 19'b0;
			default: D1 = 19'b0;
		endcase
		
	always @ (posedge clk, posedge rst)
		if(rst)
			Q1 <= 19'b0;
		else 
			Q1 <= D1;
	/////////////////////////////////////////////////
	//Bit counter
	/////////////////////////////////////////////////
	assign DONE = (Q2 == 4'd11);
	always @ (*)
		case({DoIT, BTU})
			2'b00: D2 = 4'b0;
			2'b01: D2 = 4'b0;
			2'b10: D2 = Q2;
			2'b11: D2 = Q2 + 4'b1;
			
			default D2 = 4'b0;
		endcase
		
	always @(posedge clk, posedge rst)
		if(rst)begin
			Q2 <= 4'b0;
		end
		else begin
			Q2 <= D2;

		end	
	/////////////////////////////////////////////////
	//DoneD1 reg
	/////////////////////////////////////////////////		
	always @ (posedge clk, posedge rst)
		if(rst)
			DONE_D1 <= 1'b0;
		else 
			DONE_D1 <= DONE;
	/////////////////////////////////////////////////
	//Write reg sig
	/////////////////////////////////////////////////	
	assign EP = (eight)?(^LOAD_DATA) : (^LOAD_DATA[6:0]);	//even# of 1's
																			//8 or 7 bits
	assign OP = (eight)?~(^LOAD_DATA): ~(^LOAD_DATA[6:0]);//odd# of 1's	
	
	///////////////////////////////////////////////
	//Parody decoder
	//  eight -- 8-bits
	//  pen   -- parody enable
	//  ohel  -- odd high even low
	///////////////////////////////////////////////
	always @(*)begin
		case({eight, pen, ohel})
			3'b000: {D_10, D_9} = 2'b11;
			3'b001: {D_10, D_9} = 2'b11;
			3'b010: {D_10, D_9} = {1'b1,EP};
			3'b011: {D_10, D_9} = {1'b1,OP};
			
			3'b100: {D_10, D_9} = {1'b1,LOAD_DATA[7]};
			3'b101: {D_10, D_9} = {1'b1,LOAD_DATA[7]};
			3'b110: {D_10, D_9} = {EP  ,LOAD_DATA[7]};
			3'b111: {D_10, D_9} = {OP  ,LOAD_DATA[7]};
			
			default:{D_10, D_9} = 2'b11; 
		endcase
	end

	
	///////////////////////////////////////////////
	//shift reg 
	// 11 - bit input 
	//	(D_10, D_9, LOAD_DATA[6:0], 0, 1)
	///////////////////////////////////////////////
	always @(posedge clk, posedge rst)
		if(rst)
			write_D1 <= 1'b0;
		else 
			write_D1 <= write;
			
	shift_reg sr0(.rst(rst), 
					  .clk(clk),
					  .load(write_D1), 
					  .SH(BTU), 
					  .SDI(1'b1), 
					  .data({D_10,D_9,LOAD_DATA[6:0],1'b0,1'b1}), 
					  .SDO(TX));
	
endmodule
