module booth(
	
	   input                clk        ,
	   input  signed [31:0] X          , 
	   input  signed [31:0] Y          ,
	   output signed [31:0] Z1         ,
	   input         [4:0]  ALU_Select ,
	   input        		sign       ,
	   input 				start      ,
	   output reg 			busy
);
      
 reg    signed [63:0] Z;	 	 
 reg [1:0] temp;		
 integer i;
 reg E1;	  
 reg [31:0] Y1; 
 localparam IDLE  =2'b00 ;
 localparam MUL   =2'b01 ;
 localparam NEXT  =2'b10 ;
 localparam DONE  =2'b11 ;
 reg        [7:0]   counter;
 reg 		[1:0]   state=IDLE;
 reg        x_isaret;
 reg        y_isaret;

assign Z1=(ALU_Select==5'b10001)? Z[31:0]:Z[63:32];
		 
always @ (negedge clk) begin
	case(state)
		IDLE:begin
			busy=0;
			 Z = 64'd0;
			 E1 = 1'd0;
			 counter=8'b0;
			 x_isaret=X[31];
			 y_isaret=Y[31];
			 if(start==1)begin
				state=MUL;
				busy=1;
			 end
		end
		MUL:begin
			temp = {X[counter], E1};
			Y1 = - Y;
			case (temp)
				 2'd2 : Z [63 : 32] = Z [63 :32] + Y1;
				 2'd1 : Z [63 : 32] = Z [63 : 32] + Y;
				 default : begin end
			endcase
			Z = Z >>> 1;	
			E1 = X[counter];
			if(counter==8'd31)begin
				state=DONE;
				counter=0;
			end
			counter=counter+1;
		end
		DONE:begin
			if (Y == 32'h8000_0000 ||((ALU_Select==5'b11111 || ALU_Select==5'b10111)&&(x_isaret^y_isaret)&&sign))begin
				Z = - Z;
			end
			state=IDLE;
			busy=0;
		end
	endcase
end
endmodule