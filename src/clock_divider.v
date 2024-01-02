module clock_divider(

                input      clk_i,
                input      rst_i,
                output reg clk_o

);

reg [4:0] counter;

always @(posedge clk_i)begin

    if(!rst_i)begin
        divider<=0;
        clk_o<=0;
    end
    else begin
        if(counter[4]==1'b1)begin
            clk_o<=~clk_o;
        end
    end
end

endmodule