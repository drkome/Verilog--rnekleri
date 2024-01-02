module debounce(
        input  clk,
        input  button,
        output led


);

wire divided_clk_o;
wire Q1_o,Q2_o;

    clock_divider divider(
        .clk_i(clk),
        .clk_o(divided_clk_o)
    );

    DFlipFlop flop1(.clk(clk),.D(button),.Q(Q1_o));
    DFlipFlop flop2(.clk(clk),.D(Q1_o  ),.Q(Q2_o));
    assign led= Q1_o & ~Q2_o;

endmodule


//----------------------------------------------------------------------------
module clock_divider(
    input  clk_i,
    output clk_o
);


reg [10:0] counter;
reg  clk;


assign clk_o=clk;
initial begin
    clk=0;
end
always @(posedge clk)begin
    if(counter[6]==1)begin
        counter=11'b0;
        clk=~clk;
    end 
    else begin
        counter=counter+1;
    end
end
endmodule

//--------------------------------------------------------------------------------
module DFlipFlop(input  clk,input  D,output reg Q);

always@(posedge clk)begin
    Q<=D;   
end

endmodule

