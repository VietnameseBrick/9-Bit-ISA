// Module Name:    Ctrl 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is the control decoder (combinational, not clocked)
// Out of all the files, you'll probably write the most lines of code here
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
// There may be more outputs going to other modules

module Ctrl (Instruction,LoadInstr,InstructionType,RegwriteEn,MemWriteEn,addrFlag,carryOutRegEn,carryOutRegAddr);


  input[ 8:0] Instruction;	   // machine code
  output reg
              //BranchEn;
			    LoadInstr,
				 InstructionType,
				 RegwriteEn,
				 MemWriteEn;
  output reg [1:0] addrFlag;
  output reg		carryOutRegEn;
  output reg [3:0] carryOutRegAddr;

	// jump on right shift that generates a zero
	always@*
	begin
			LoadInstr = 0;
			InstructionType = 0;
			RegwriteEn = 0;
			MemWriteEn = 0;
			addrFlag = 0;
			carryOutRegEn = 0;
			carryOutRegAddr = 0;
			if(Instruction[8] == 1'b0 && Instruction[7:4] == 4'b1100)
				LoadInstr = 1;
			else 
				LoadInstr = 0;
			
			if(Instruction[8] == 1'b1) 
				InstructionType = 1;
			else 
				InstructionType = 0;
				
			if((Instruction[8] == 1'b0 && Instruction[7:4] == 4'b1011) || (Instruction[8] == 1'b0 && Instruction[7:4] == 4'b1010) 
					|| (Instruction[8] == 1'b0 && Instruction[7:4] == 4'b0010))
				RegwriteEn = 0;
			else
				RegwriteEn = 1;
			
			if(Instruction[8] == 1'b0 && Instruction[7:4] == 4'b1011)
				MemWriteEn = 1;
			else 
				MemWriteEn = 0;
			
			if(Instruction[8] == 1'b0 && Instruction[7:4] == 4'b0000)
			begin
				carryOutRegAddr = 4'b0100;
				carryOutRegEn = 1;
				addrFlag = 2'b10;
				
			end
			else if (Instruction[8] == 1'b0 && Instruction[7:4] == 4'b0110)
			begin
				carryOutRegAddr = 4'b0000;
				carryOutRegEn = 1;
				addrFlag = 2'b01;
			end
	
			else if (Instruction[8] == 1'b0 && Instruction[7:4] == 4'b0001)
				addrFlag = 2'b11;
			else
			begin
				addrFlag = 2'b00;
				carryOutRegAddr = 4'b0000;
				carryOutRegEn = 0;
			end
				
		 
	  //if(Instruction[2:0] ==  3'b110 /*AND some other conditions are true*/) // assuming 110 is your branch instruction
	  /*BranchEn = 1;
	  else
		 BranchEn = 0;*/
		 
		 
	end


endmodule

