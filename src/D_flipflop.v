module D_flipflop(
        
        input      clk_i,
        input      D,
        output reg Q
    );
    
    always @(posedge clk_i)begin
        Q<=D;
    end
endmodule