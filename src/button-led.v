module buttonled(

		input clk,rst,
		input button,
		output reg led   

    );
    
always @(posedge clk)begin
	if(!rst) begin
        led<=1'b0;
    end
    else if(button==1'b1)begin
        led<=1'b1;
    end else begin
        led<=1'b0;
    end
end

endmodule
