module uart_deneme(

    input clk,rst,button,
    output tx_o
);

reg start=0;
wire tx_done;

uart_tx tx(

    .clk(clk),
    .rst(rst),
    .data_in(8'h4E),
    .baud_div(16'h43D),
    .tx_start(start),
    .tx_done(tx_done),
    .tx_o(tx_o)       

);


always@(posedge clk)begin

if(button==1)begin
start=1;
end else begin
start=0;
end

end


endmodule





module uart_tx(

    input         clk,
    input         rst,
    input [7:0]   data_in,
    input [15:0]  baud_div,
    input         tx_start,
    output  reg   tx_done,
    output  reg   tx_o       

);



localparam IDLE       =4'b0001;
localparam BASLA      =4'b0010;
localparam VERI_YOLLA =4'b0100;
localparam BITTI      =4'b1000;
localparam TEMIZLE    =4'b1001;

reg [3:0] state;
integer bitcounter;
reg [2:0] bit_index;
reg [7:0] shift_register;


always@(posedge clk)begin
    if(!rst)begin
        tx_o   <=1;
        tx_done<=0;
        bit_index<=0;
        bitcounter<=0;
        state<=IDLE;
    end else begin
        case(state) 
            IDLE:begin
                tx_o   <=1;
                tx_done<=0;
                bitcounter<=0;
                bit_index<=0;
                if(tx_start)begin
                    state<=BASLA;
                    shift_register<=data_in;
                end else begin
                     state<=IDLE;
                end
            end

            BASLA:begin
                tx_o<=0;
                if(bitcounter<baud_div-1)begin
                    bitcounter=bitcounter+1;
                    state<=BASLA;
                end
                else begin
                    bitcounter<=0;
                    state<=VERI_YOLLA;
                end
            end

            VERI_YOLLA:begin
                tx_o<=shift_register[bit_index];
                if(bitcounter<baud_div-1)begin
                    bitcounter<=bitcounter+1;
                    state     <=VERI_YOLLA;
                end
                else begin
                    bitcounter<=0;
                    if(bit_index<7)begin
                        bit_index=bit_index+1;
                    end else begin
                        bitcounter<=0;
                        bit_index<=0;
                        state    <=BITTI;
                    end 
                end
            end

            BITTI:begin 
                tx_o<=1;
                if(bitcounter<baud_div-1)begin
                    bitcounter=bitcounter+1;
                end else begin
                    bitcounter<=0;
                    tx_done<=1;
                    state<=TEMIZLE;
                end
            end

            TEMIZLE:begin
                tx_done<=1;
                state<=IDLE;
            end
        endcase
    end
end

endmodule







