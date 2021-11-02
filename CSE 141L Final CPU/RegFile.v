// Module Name:    RegFile 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is your register file.
// If you have more or less bits for your registers, update the value of D.
// Ex. If you only supports 8 registers. Set D = 3

/* parameters are compile time directives 
       this can be an any-size reg_file: just override the params!
*/
module RegFile (Clk,WriteEn,writeEnCarryOut,addrFlag,RaddrA,RaddrAccum,Waddr,waddrCarryOut,DataIn,carryOutData,DataOutA,DataOutAccu);
	parameter W=8, D=4;  // W = data path width (Do not change); D = pointer width (You may change)
	input                Clk,
								WriteEn,
								writeEnCarryOut;
	input [1:0]				addrFlag;
	input        [D-1:0] RaddrA,
								RaddrAccum,// address pointers
								Waddr,
								waddrCarryOut;
							
	input        [W-1:0] DataIn;
	input carryOutData;
	output reg   [W-1:0] DataOutA;			  
	output reg   [W-1:0] DataOutAccu;	//DataOutB is the accum
   

// W bits wide [W-1:0] and 2**4 registers deep 	 
reg [W-1:0] Registers[(2**D)-1:0];	  // or just registers[16-1:0] if we know D=4 always



// NOTE:
// READ is combinational
// WRITE is sequential

always@*
begin
 DataOutA = Registers[RaddrA];	  
 DataOutAccu = Registers[RaddrAccum];
end

// sequential (clocked) writes 
always @ (posedge Clk)
  if (WriteEn)  // works just like data_memory writes
     begin
	  if(addrFlag == 2'b01 && writeEnCarryOut) //sll
	    begin	
       Registers[Waddr] <= DataIn;
	    Registers[waddrCarryOut] <= carryOutData;
	    end
	  else if(addrFlag == 2'b10 && writeEnCarryOut) //add
	    begin
	    Registers[0] <= DataIn;
	    Registers[waddrCarryOut] <= carryOutData;
	    end
	  else if(addrFlag == 2'b11 && !(writeEnCarryOut)) //mov
		 Registers[Waddr] <= DataIn;
	
	  else  //anything else
	  begin
		 Registers[0] <= DataIn;
	  end
	
	  end
   
endmodule