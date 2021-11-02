module programOne_tb();

  reg      		 clk   = 1'b0   ;      // advances simulation step-by-step
  reg           init  = 1'b1   ;      // init (reset) command to DUT
  reg           start = 1'b0   ;      // req (start program) command to DUT
  wire       done           ;      // done flag returned by DUT



// ***** instantiate your top level design here *****
  CPU dut(
    .Clk     (clk  ),   // input: use your own port names, if different
    .Reset    (init),   // input: some prefer to call this ".reset"
    .Start     (start),   // input: launch program
    .Ack     (done )    // output: "program run complete"
  );
 
// program 1 variables
reg[63:0] dividend;      // fixed for pgm 1 at 64'h8000_0000_0000_0000;
reg[15:0] divisor1;	   // divisor 1 (sole operand for 1/x) to DUT
reg[63:0] quotient1;	   // internal wide-precision result
reg[15:0] result1,	   // desired final result, rounded to 16 bits
            result1_DUT;   // actual result from DUT
real quotientR;			   // quotient in $real format 
always
	#5 clk = !clk;

initial begin
// launch program 1
  #13;
  init = 0;
  
  $display("PC 0, %b", dut.IR1.inst_rom[0]);
  $display("PC 1, %b", dut.IR1.inst_rom[1]);
  start = 1;
  divisor1 = 36;
  dividend = 64'h8000_0000_0000_0000;
  dut.DM1.Core[8] = divisor1[15:8];
  dut.DM1.Core[9] = divisor1[ 7:0];
  if(divisor1) div1;										// regal value of nonzero vector = 1; 
  else result1 = 16'b1111111111111111;
  #10;
  start = 0;
  wait(done);
    
  result1_DUT[15:8] = dut.DM1.Core[10];
  result1_DUT[ 7:0] = dut.DM1.Core[11];
  $display ("divisor = %h , quotient = %h , result1 = %h, equiv to %10.5f", 
    divisor1, quotient1, result1, quotientR); 
  if(result1==result1_DUT) $display("success -- match1");
  else $display("OOPS1! expected %b, got %b",result1,result1_DUT);
  $display("data mem 10 is: , %b", dut.DM1.Core[10]);
  $display("data mem 11 is: , %b", dut.DM1.Core[11]);
  $display("value of R8, %b",dut.RF1.Registers[8]);
  $display("value of R9, %b",dut.RF1.Registers[9]);
  $display("value of R10, %b",dut.RF1.Registers[10]);
  $display("value of R11, %b",dut.RF1.Registers[11]);

  #10;
  $stop;
end
  
  
task automatic div1;
begin
  quotient1 = dividend/divisor1;			// Actually doing 1/ divisor to get a result to compare with your processor's division
  //result1 = quotient1[63:48]+quotient1[47]; // half-LSB upward rounding
  result1 = quotient1[63:48]; // no rounding
  quotientR = 1.00000/$itor(divisor1);
end
endtask 
endmodule