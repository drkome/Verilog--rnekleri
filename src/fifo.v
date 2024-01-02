module fifo(
        input               clk     ,
        input  [31:0]       data_i  ,
        input               write_en,
        input               read_en ,
        output reg [31:0]   data_o  ,
        output              full    ,
        output              empty         

);

reg [31:0] memory [0:31];
reg [5:0] write_ptr;
reg [5:0] read_ptr;
integer i;

assign full  =((write_ptr[4:0]==read_ptr[4:0]) && (write_ptr[5]!=read_ptr[5]));
assign empty =((write_ptr[4:0]==read_ptr[4:0]) && (write_ptr[5]==read_ptr[5]));

initial begin
    for(i=0;i<32;i=i+1)begin
        memory[i]=32'b0;
    end
    write_ptr=5'b0;
    read_ptr =5'b0;
end

always@(posedge clk)begin
    if(write_en && !full)begin
        memory[write_ptr[4:0]]<=data_i;
        write_ptr=write_ptr+1;
    end
end

always@(posedge clk)begin
    if(read_en && !empty)begin
        data_o<=memory[read_ptr[4:0]];
        read_ptr<=read_ptr;
    end
end

endmodule