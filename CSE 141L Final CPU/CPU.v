// Module Name:    CPU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This is the TopLevel of your project
// Testbench will create an instance of your CPU and test it
// You may add a LUT if needed
// Set Ack to 1 to alert testbench that your CPU finishes doing a program or all 3 programs



	 
module CPU(Reset, Start, Clk,Ack);

	input Reset;		// init/reset, active high
	input Start;		// start next program
	input Clk;			// clock -- posedge used inside design
	output reg Ack;   // done flag from DUT

	
	
	wire [ 10:0] PgmCtr;        // program counter
			     // PCTarg;
	wire [ 8:0] Instruction;   // our 9-bit instruction
	wire [ 7:0] ReadA, ReadAccu;  // reg_file outputs
	wire [ 7:0] InA, InAccu, 	   // ALU operand inputs
					ALU_out;       // ALU result
	wire [ 7:0] RegWriteValue, // data in to reg file
					MemWriteValue, // data in to data_memory
					MemReadValue,  // data out from data_memory
					muxALU;
	wire        MemWriteEn,	   // data_memory write enable
				   RegWrEn,	      // reg_file write enable
					carryOutWriteEn,
					
				  		      // ALU output = 0 flag
					LoadInstr,
					AccuCarryOut,
					InstructionType;
					
	wire [3:0]  ReadFunction,
					carryOutRegAddrCtrl;
	
	wire [5:0] immediate;	
	wire [1:0] Zero, addrFlag;

	reg  [15:0] CycleCt;	      // standalone; NOT PC!

	// Fetch = Program Counter + Instruction ROM
	// Program Counter
  InstFetch IF1 (
	.Reset       (Reset   ) , 
	.Start       (Start   ) ,  
	.Clk         (Clk     ) ,  
	.ALU_flag	 (Zero    ) ,
   .Target      (ALU_out ) ,
	.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);	

	// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction),    // from instr_ROM
	.LoadInstr (LoadInstr),
	.InstructionType (InstructionType),
	.RegwriteEn (RegWrEn),
	.MemWriteEn (MemWriteEn),
	.addrFlag(addrFlag),
	.carryOutRegEn(carryOutWriteEn),
	.carryOutRegAddr(carryOutRegAddrCtrl)
  );
  
  
	// instruction ROM
  InstROM IR1(
	.InstAddress   (PgmCtr), 
	.InstOut       (Instruction)
	);
	
	
	always@*							  
	begin
		Ack = Instruction[8:4] == 5'b00010;  // Update this to the condition you want to set done to true
	end
		
	//Reg file
	// Modify D = *Number of bits you use for each register*
   // Width of register is 8 bits, do not modify
	RegFile #(.W(8),.D(4)) RF1 (
		.Clk    		(Clk)		  ,
		.WriteEn   (RegWrEn)    ,
		.writeEnCarryOut(carryOutWriteEn),
		.addrFlag	(addrFlag),
		.RaddrA    (Instruction[3:0]),
		.RaddrAccum (4'b0000),
		.Waddr     (Instruction[3:0]), // usually we always write to accum except in mov instruction
		.waddrCarryOut(carryOutRegAddrCtrl),
		.DataIn    (RegWriteValue) ,
		.carryOutData(AccuCarryOut),
		.DataOutA  (ReadA        ) , 
		.DataOutAccu  (ReadAccu)
	);
		
	assign InA = ReadA;						                       // connect RF out to ALU in
	assign InAccu = ReadAccu;
	
	assign RegWriteValue = LoadInstr? MemReadValue : ALU_out;  // 2:1 switch into reg_file
	
	assign immediate = Instruction[5:0];
	assign muxALU = InstructionType? immediate : InA;
	assign ReadFunction = InstructionType? Instruction[7:6] : Instruction[7:4];
	//mux2 valueMux(  .d0(Accu), .d1(immediate) , .s(controlLogic), .y(muxALU)  );

	// Arithmetic Logic Unit
	ALU ALU1(
	  .InputAccu(InAccu),      	  
	  .DataIn(muxALU),
	  .OP(Instruction[8]),
	  .func(ReadFunction),
	  .Out(ALU_out),		  			
	  .Zero(Zero),
	  .carryOut(AccuCarryOut)
		 );
	 
	 
	 // Data Memory
	 	DataMem DM1(
		.DataAddress  (ReadA)    , 
		.WriteEn      (MemWriteEn), 
		.DataIn       (ReadAccu), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  	  (Clk)     ,
		.Reset		  (Reset)
	);

	
	
// count number of instructions executed
// Help you with debugging
	always @(posedge Clk)
	  if (Start == 1)	   // if(start)
		 CycleCt <= 0;
	  else if(Ack == 0)   // if(!halt)
		 CycleCt <= CycleCt+16'b1;
	  else if(Ack == 1)
	    $stop;
endmodule