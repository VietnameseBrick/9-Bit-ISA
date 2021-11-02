// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// 


	 
module ALU(InputAccu,DataIn,OP,func,Out,Zero,carryOut);

	input [ 7:0] InputAccu;
	input [7:0] DataIn;
	input OP;
	input [3:0] func;
	output reg [7:0] Out; // logic in SystemVerilog
	output reg [1:0]Zero;
	output reg carryOut;
	
	

	always@* // always_comb in systemverilog
	begin 
		Out = 0;
		carryOut = 0;
		Zero = 0;
		case (OP)
			1'b0: begin
				case(func)
					4'b0000: 
					   {carryOut, Out} = {1'b0,InputAccu}+{1'b0,DataIn};
					
					4'b0001: //mov
						Out = InputAccu;
					
					4'b0010:// halt
						Out = 0;
					
					4'b0011://slt
						Out = DataIn < InputAccu ? 0 : 1;
					
					
					4'b0100://set
						Out = DataIn;
						
					
					4'b0101://sub
						Out = InputAccu - DataIn;
					
					4'b0110://sll
					begin
					   carryOut = DataIn[7];
						Out = (DataIn << 1) | InputAccu;
					end
					
					4'b0111://twosComp
						Out = (DataIn ^ 8'b11111111) + 1;
					
					4'b1000://or
						Out = InputAccu | DataIn;
					
					4'b1001://slr
						Out = DataIn >> 1;
					
					4'b1010://Bezr
						begin
							if(InputAccu ==0)
								
								begin
								if(DataIn[7] == 1)
									begin
										Out = (DataIn ^ 8'b11111111) + 1;
										Zero = 2'b10;
									
									end
								else
								begin
									Out = DataIn;
									Zero = 2'b01;
								end
								
								end
							else
								Zero = 2'b00;
								
							
						end 
							
					
					4'b1011://sw
						Out = DataIn;
					
					4'b1100://lw
						Out = DataIn;
						
					
					//4'b1101:
					
					//4'b1110:
					
					//4'b1111:
					
					default: Out =0;
				endcase
					
					
		
				end
				
			1'b1:begin
				case(func)
					
					2'b00: //seti
						Out = DataIn;
					
					2'b01://sliz
						Out = InputAccu << DataIn;
					
					2'b10: //slti
						Out = DataIn < InputAccu ? 0 : 1;
					
					
					default: Out = 0;
				endcase
		
		
			end
		/*3'b000: Out = InputA + InputB; // ADD
		3'b001: Out = InputA & InputB; // AND
		3'b010: Out = InputA | InputB; // OR
		3'b011: Out = InputA ^ InputB; // XOR
		3'b100: Out = InputA << 1;				// Shift left
		3'b101: Out = {1'b0,InputA[7:1]};   // Shift right*/
		default: Out = 0;
	  endcase
	
	end 

	
	

endmodule