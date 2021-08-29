/********************************************************
Auther      :-  velidi pradeep kumar 
date        :-  28/8/2021 
orgnisation :-  IIITDM KANCHIPURAM
description :- this is a binary to bcd convertor rtl design 
**********************************************************/
 
module BIN_BCD(output wire [15:0] OUT,
                input wire [12:0] IN,
			    input clk,tr);
					 
				wire count,shift,add1,add2,add3,add4,reset,load_data;
				wire [15:0] bcd;
			    wire [3:0] cont;
				
				reg [15:0] BCD ;
				
				controller C (count,shift,add1,add2,add3,add4,reset,load_data,clk,bcd,cont);
				datapath   D (count,shift,add1,add2,add3,add4,reset,load_data,clk,tr,IN,bcd,cont);
								 
				assign OUT = BCD;
				
				always@(posedge clk) 
				begin
				if(load_data) BCD <= bcd;
				else BCD <= BCD;
				end
endmodule 
			


// control unit  

module controller(output reg count,shift,add1,add2,add3,add4,reset,load_data,
                  input clk, 
				  input wire [15:0] BCD,
				  input wire [3:0] counter);
						
			reg [1:0] pres_state,next_state;
                
			always@(posedge clk)pres_state <= next_state;
			
			
	/// combinational output logic 		
			always@(*)
			begin
			load_data = 1'b0;
			count = 1'b0; reset = 1'b0;
			add1 = 1'b0; add2 = 1'b0; add3 = 1'b0;  add4 = 1'b0; 
			shift = 1'b0;
			//RR = 1'b0;
			case(pres_state)
			
		   2'b00   :   begin                                   // load 
			            load_data = 1'b1;
						reset = 1'b1;
						next_state = 2'b01;
					   end
		   2'b01   :   begin  
		                   if(counter == 4'b1101) begin next_state = 2'b00;end
		                   else   begin
		                    next_state = 2'b11;
			                if(BCD[3:0]   >= 4'b0101) add1 = 1'b1;
							  else  add1  = 1'b0;
							if(BCD[7:4]   >= 4'b0101) add2 = 1'b1;
							  else  add2  = 1'b0;
							if(BCD[11:8]  >= 4'b0101) add3 = 1'b1;
							  else  add3  = 1'b0;
							if(BCD[15:12] >= 4'b0101) add4 = 1'b1;
							  else  add4  = 1'b0;
							end
							end
         2'b11   :   begin                                // shift  
                     //load_data = 1'b0;
                     shift <= 1'b1;
                     count <= 1'b1;
                     next_state = 2'b01;
					 end	
		 default :   next_state = 2'b00; 
			endcase
			end
			
endmodule


 //  DATA UNIT 
			
module datapath(input  wire count,shift,add1,add2,add3,add4,reset,load_data,clk,tr,
                input  wire [12:0] IN ,
			    output wire [15:0] OUT,
			    output wire [3:0] cont );
					 
					 
					 reg [3:0]  counter;
					 reg [15:0] BCD;
					 reg [12:0] BIN;
					 wire[3:0] ADD1,ADD2,ADD3,ADD4;
					 
					 ADD A[3:0] ({ADD4,ADD3,ADD2,ADD1},BCD,16'b0011_0011_0011_0011,4'b0000);
					 
			assign cont = counter;
			assign OUT = BCD;

			/// counter logic 
			always@(posedge clk)
			begin
			case({count,reset})
			2'b00     :       counter <= counter;
			2'b01     :       counter <= 4'b0000;
			2'b10     :       counter <= counter + 1'b1;
			2'b11     :       counter <= 4'b0000;
			endcase
			end
/////////////////////////////////////////////////////////////////////////////
			always@(posedge clk)
			begin
			/// data regesters logic 
			if(load_data|tr) 
			      begin 
					BIN <= IN;
					BCD <= 16'b0000_0000_0000_0000;
				  end
			else if(shift)begin {BCD,BIN} <= {BCD,BIN} << 1; end
			else if(add1||add2||add3||add4)
		        begin 
			                BIN <= BIN;
				  if(add1)  BCD[3:0]   <= ADD1          ;
				  else      BCD[3:0]   <= BCD[3:0]      ;
			      if(add2)  BCD[7:4]   <= ADD2          ;
				  else      BCD[7:4]   <= BCD[7:4]      ;
				  if(add3)  BCD[11:8]  <= ADD3          ;
				  else      BCD[11:8]  <= BCD[11:8]     ;
				  if(add4)  BCD[15:12] <= ADD4          ;
				  else      BCD[15:12] <= BCD[15:12]    ;
				  end
			 else 
				  begin 
					BIN <= BIN;
					BCD <= BCD;
					end
			end
endmodule 
			
							
			