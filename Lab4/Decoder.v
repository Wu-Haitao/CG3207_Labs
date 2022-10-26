`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

module Decoder(
    input [3:0] Rd,
    input [1:0] Op,
    input [5:0] Funct,
    output PCS,
    output RegW,
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
    output reg [3:0] ALUControl,
    output reg [1:0] FlagW,
    //For MUL and DIV
    input [3:0] MBits,
    output Start,
	output reg [1:0] MCycleOp
    );
    
    wire [1:0] ALUOp ;
    wire Branch;
    reg [10:0] controls ;
    //<extra signals, if any>
    
    
    //PC Logic
    assign PCS = ((Rd == 15) & RegW) | Branch;
    
    assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc[1:0], RegW, RegSrc[1:0], ALUOp[1:0]} = controls;
    assign NoWrite = (Op==2'b00) & (Funct[4:2] == 3'b101) & Funct[0];  

	// Assign start = 1 when doing MUL and DIV, else start = 0
	// start = isDP & (instr[25:21] == 0000X) & (MBits == 1001)
	assign Start = (Op == 2'b00) & (Funct[5:2] == 4'b0000) & (MBits == 4'b1001);
	
    
    always @(*)
    begin
    	if (~Start) //Original
    	begin
	        //Controls
	        case (Op)
	            2'b00: controls = (Funct[5])? 11'b0001001X001 : 11'b0000XX10001; //DP
	            2'b01: controls = (Funct[0])? 11'b0101011X010 : 11'b0X110101010; //Mem
	            2'b10: controls = 11'b1001100X100; //B
	        endcase;
	    
	        //ALU Decoder
	    	if (ALUOp == 2'b01) //DP
	    	begin
	    		case (Funct[4:1])
	    			4'b0100: //ADD
	    			begin
	    				ALUControl = 4'b0000;
	    				FlagW = (Funct[0])? 2'b11:2'b00;
	    			end
	    			4'b0010: //SUB
	    			begin
	    				ALUControl = 4'b0001;
	    				FlagW = (Funct[0])? 2'b11:2'b00;
	    			end
	    			4'b0000: //AND
	    			begin
	    				ALUControl = 4'b0010;
	    				FlagW = (Funct[0])? 2'b10:2'b00;
	    			end
	    			4'b1100: //ORR
	    			begin
	    				ALUControl = 4'b0011;
	    				FlagW = (Funct[0])? 2'b10:2'b00;
	    			end
	    			4'b1010: //CMP
	    			begin
	    			    ALUControl = 4'b0001;
	    			    FlagW = 2'b11;
	    			end
	    			4'b1011: //CMN
	    			begin
	    			    ALUControl = 4'b0000;
	    			    FlagW = 2'b11;
	    			end
	    			//Lab 4
	    			4'b0001: //EOR
	    			begin
	    				ALUControl = 4'b0100;
	    				FlagW = (Funct[0])? 2'b10:2'b00;
	    			end
	    			4'b1001: //TEQ
	    			begin
	    				ALUControl = 4'b0100;
	    				FlagW = 2'b10;
	    			end
	    			4'b1000: //TST
	    			begin
	    				ALUControl = 4'b0010;
	    				FlagW = 2'b10;
	    			end
	    			4'b1101: //MOV
	    			begin
	    				ALUControl = 4'b1001;
	    				FlagW = (Funct[0])? 2'b10:2'b00;
	    			end
	    			4'b1111: //MVN
	    			begin
	    				ALUControl = 4'b1010;
	    				FlagW = (Funct[0])? 2'b10:2'b00;
	    			end
					4'b0101: //ADC
					begin
						ALUControl = 4'b0110;
						FlagW = (Funct[0])? 2'b11:2'b00;
					end
					4'b0110: //SBC
					begin
						ALUControl = 4'b0111;
						FlagW = (Funct[0])? 2'b11:2'b00;
					end
					4'b0111: //RSC
					begin
						ALUControl = 4'b1000;
						FlagW = (Funct[0])? 2'b11:2'b00;
					end
					4'b1110: //BIC
					begin
						ALUControl = 4'b1011;
						FlagW = 2'b00
	    		endcase
	    	end
	    	else if (ALUOp == 2'b10) //Mem
	    	begin
	    		ALUControl = (Funct[3])? 2'b00:2'b01;
	    		FlagW = 2'b00;
	    	end
	    	else if (ALUOp == 2'b00) //B
	    	begin
	    		ALUControl = 2'b00;
	    		FlagW = 2'b00;
	    	end
	    end
	    else //MUL and DIV
	    begin
	    	controls = 11'b0000XX100XX; //ALUOp doesn't matter here
	    	ALUControl = 4'bXXXX; //Don't care
	    	FlagW = (Funct[0])? 2'b10:2'b00; //Can set Z and N but not required
	    	//Interpret MLA as DIV
	    	MCycleOp = (Funct[1])? 2'b11:2'b01; //Unsigned
	    end
    end
endmodule