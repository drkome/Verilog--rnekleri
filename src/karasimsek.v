module karasimsek(

    input            clk_i,
    output reg [3:0] led

);

reg [31:0] delay;
reg        delay_ok,sol_aktif,sag_aktif;

initial begin
    delay=1'b0000;
    delay_ok=0;
    led=4'b0001;
    sol_aktif=1;
    sag_aktif=0;
end

always @(posedge delay_ok)begin
    if(sol_aktif)begin
        led=led<<1;
        if(led==4'b1000)begin
            sol_aktif=0;
            sag_aktif=1;
        end
    end else if (sag_aktif)begin
        led=led>>1;
        if(led==4'b0001)begin
            sol_aktif=1;
            sag_aktif=0;
        end
    end
end
//125 MHZDE 1SN İÇİN 7735940
always@(posedge clk_i)begin
    if(delay<32'h7735940)begin
        delay<=delay+1;
        delay_ok<=0;
    end else begin
        delay<=0;
        delay_ok<=1;
    end
end


endmodule