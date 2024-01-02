module JK_FlipFlop(
        input      clk_i,
        input      J,K,
        output reg Q
    );
    
    always @(posedge clk_i)begin
         case ({J,K})
         2'b00: Q<=Q;
         2'b00: Q<=0;
         2'b00: Q<=1;
         2'b00: Q<=~Q;
         endcase
    end

endmodule