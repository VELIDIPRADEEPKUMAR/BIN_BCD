
 `timescale 1 ns / 1 ns 
 
  module BIN_BCD_TESTBENCH();
  
  
  wire [15:0] OUT;
  reg  [12:0] IN;
  reg clk = 1'b0,tr = 1'b1;
  
//  reg count,shift,add1,add2,add3,add4,reset,load_data, clk;
//  reg [12:0] IN ;
//  wire [15:0] OUT;
//  wire [3:0] cont;	
//  wire [12:0] bin;
  
  BIN_BCD B1(OUT,IN,clk,tr);
  //datapath D(count,shift,add1,add2,add3,add4,reset,load_data,clk,IN ,OUT,cont);
  
  
  
  initial 
  begin 
//  count=0;shift=0;add1=0;add2=0;add3=0;add4=0;reset=1;load_data = 0; clk = 0;IN = 0;
//  #1 count = 1'b1;IN = 13'b0_1111_0000_0001;
//  #2 load_data = 1;reset = 0;
//  #4 shift = 1;
//  #20 shift = 0;
IN = 13'b0_0000_0001_0001;clk = 0;tr = 1'b1;
#5 tr = 1'b0;
#66 IN = 13'b0_0000_1111_1111;
  
  end
  
  always#1 clk = ~clk;
  
endmodule
