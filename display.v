

module display(output reg [7:0] dig,
               output wire [3:0] sel,
               input clk  );
					
					wire clk1,clk2;
					wire locked;
					wire [15:0] BCD;
					wire [27:0] SSD;
					reg  [19:0] counter;
					
					supply0 areset;
					supply0 tr;
					
					
			PLL P(areset,clk,clk1,clk2,locked);
			BIN_BCD D(BCD,{1'B0,counter[19:8]},clk2,tr);
			decoder d(sel,counter[4:3]);
			BCD_SSD ssd[3:0](SSD,BCD);
			
			
			always@(posedge clk1) counter <= counter + 1'b1;
			
			always@(*) 
			begin
			
			case(counter[4:3])
			
			   2'b00    :  dig[7:0] = {1'b1,SSD[6:0]};
			   2'b01    :  dig[7:0] = {1'b1,SSD[13:7]};
				2'b10    :  dig[7:0] = {1'b1,SSD[20:14]};
				2'b11    :  dig[7:0] = {1'b1,SSD[27:21]};
				
		   endcase 
				
				end	
endmodule


/// decoder 
module decoder(output reg [3:0] out,
               input [1:0] in    );
				
			always@(*) 
	         begin
			  
			   case(in)
			
		      2'b00    :  out = 4'b1110;
			   2'b01    :  out = 4'b1101;
				2'b10    :  out = 4'b1011;
				2'b11    :  out = 4'b0111;
		      endcase 
				end
endmodule 
			

/// BCD TO SEVEN SEGMENT DISPLAY 
			
module BCD_SSD(output [6:0] out,
               input  [3:0] in   );
					
					wire A,B,C,D;
					reg a,b,c,d,e,f,g;
					
					assign {A,B,C,D} = in;
					assign out = {!g,!f,!e,!d,!c,!b,!a};


always @(*)
begin
 a <= ((~B & ~D ) | A | C | (B&D));
 b <= ( ~B | (~C & ~D ) | (C&D));
 c <= ( B | (~C) | D );
 d <= ((~B & ~D ) | A | (C & ~D) | (~A & ~B & C ) | (B & ~C  & D));
 e <= ((~B & ~D) | (C & ~D));
 f <= ((~C & ~D) | A | (B & ~C) | (B & ~D));
 g <= ( A | (~A & ~B & C) | (B & ~C) | (B & ~D));
end
    
endmodule
			
			      