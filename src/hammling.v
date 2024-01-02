 module hamming(

    input clk,rst,start,
    input [31:0] in1,in2,
    output reg [6:0] hammling_o

 );
 
 reg [6:0] deger=0;
 reg [4:0] counter=0;
 reg       bitti=1;
 always @(posedge clk) begin
    if(start && bitti)begin
        if (in1[counter] != in2[counter]) begin
            deger = deger + 1;
        end
    counter=counter+1;
    if(counter==32 && start==1)begin
        bitti=0;
        counter<=0;
    end else begin
        bitti=1;
    end
    end               
        hammling_o<=deger;
                   
 end

endmodule