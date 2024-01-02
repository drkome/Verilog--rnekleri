`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.12.2023 23:52:29
// Design Name: 
// Module Name: mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul(
            input         clk,rst,
            input  [31:0] in1,in2,
            output reg    busy,
            input         start,
            output [31:0] out

    );

localparam BOSTA   =2'b00 ;
localparam HESAPLA =2'b01 ;
localparam BITTI   =2'b10 ;
reg [6:0] counter;
reg [1:0] durum;
reg [64:0] butun_sayi;
reg [31:0] A,M,Q;
reg        C;

always @(posedge clk)begin
    
  if(!rst)begin
    durum=BOSTA;
              durum=BOSTA;
          M    =32'b0;
          Q    =32'b0;
          C    =32'b0;
          busy =0;
          butun_sayi=65'b0;
          counter=7'b0;
          A=32'b0;
  end else begin
    case(durum)
      BOSTA:begin
        if(start)begin
          durum=HESAPLA;
          M    =in1;
          Q    =in2;
          C    =32'b0;
          busy =1;
          A=32'b0;
          butun_sayi={C,A,in2};
          counter=7'b0;
        end else begin
          durum=BOSTA;
          M    =32'b0;
          Q    =32'b0;
          C    =32'b0;
          A=32'b0;
          busy =0;
          counter=7'b0;
          butun_sayi=65'b0;
        end
      end
      HESAPLA:begin
          if(counter==32)begin
            durum=BITTI;
          end 
          else begin
          if(butun_sayi[0]==1)begin
               butun_sayi[64:32]=butun_sayi[63:32]+M;
          end
          butun_sayi=butun_sayi>>>1;
          counter=counter+1;
          end
       end
      BITTI  :begin 
          durum=BOSTA;
          counter=7'b0;
          end
    endcase
  end

end

endmodule
