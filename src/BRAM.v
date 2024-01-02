module BRAM_deneme (
    input              clk,
    input              write_en_i,
    input              read_en_i,
    input       [8:0]  write_adress_i,
    input       [8:0]  read_adress_i,
    input       [31:0] data_in,
    output reg  [31:0] data_o              
);
    
(*ram_style="block"*)

reg [31:0] ram [0:500];

always@(negedge clk)begin
    if(write_en_i)begin
        ram[w_adress_i]<=data_in;
    end
end

always@(negedge clk)begin
    if(read_en_i)begin
        data_o<=ram[r_adress_i];
    end
end



endmodule