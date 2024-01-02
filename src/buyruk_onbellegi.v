module buyruk_onbellegi(

        input               clk,
        input               rst,
        input        [31:0] addr_i, //
        input        [31:0] data_i, //bellek denetleyici
        output       [31:0] data_o,
        output              buyruk_yollandi_o,
        input               buyruk_memory_ready,
        output reg   [31:0] buyruk_memory_addr,
        output reg          buyruk_memory_valid,
        output reg   [3:0]  wstrb              ,
        output reg          fetch_durdur       ,
        output reg          buyruk_durum_o

);


reg [21:0]  etiket   [0:255];
reg         onay     [0:255];
reg         read;
reg         write;
reg [7:0]   adress;
reg         write_en;
reg         read_en;
reg         hit;
reg         buyruk_yollandi;
reg         kilitle;
reg   [31:0]      data;
integer i;

localparam CACHE_OKU    =3'b000;
localparam MEMORY_CEK   =3'b001;
localparam MEMORY_KAYIT =3'b011;


reg [2:0] durum=CACHE_OKU;



initial begin
    fetch_durdur=0;
    hit=1'b0;
    read=1'b0;
    kilitle<=0;
    buyruk_durum_o<=0;
    for(i=0;i<256;i=i+1)begin
        onay[i]=0;
        etiket[i]=24'b0;
    end
end


assign buyruk_yollandi_o=buyruk_yollandi & hit;

always @(*)
    begin
        //Okuma yapÄ±ldÄ±gÄ±nda
        if(read_en==1)begin
            if(addr_i[31:10]==etiket[addr_i[9:2]] && onay[addr_i[9:2]]==1)
                begin
                    hit =1;
                    read=1;
                    adress=addr_i[9:2];
                end 
            else 
                begin
                    hit =0;
                    read=0;
                end 
        end
        if(write_en==1 && kilitle==1)begin
            write=1;
            etiket[buyruk_memory_addr[9:2]]=buyruk_memory_addr[31:10];
            adress=buyruk_memory_addr[9:2];
            onay[buyruk_memory_addr[9:2]]=1;
            data=data_i;
        end else begin
            write=0;
        end
    end


always @(posedge clk)begin
    if(!rst)begin
        durum<=CACHE_OKU;
        read_en<=0;
        write_en<=0;
        buyruk_memory_valid<=0;
        fetch_durdur<=0;
  /*      for(i=0;i<256;i=i+1)
            begin
                onay[i]=0;
                etiket[i]=24'b0;
            end*/
    end 
    else begin
        case(durum)

            CACHE_OKU:begin
                read_en<=1;
                buyruk_yollandi<=0;
                if(!hit)begin
                    read_en<=0;
                    fetch_durdur<=1;
                    kilitle     <=1;
                    buyruk_durum_o<=1;
                    buyruk_memory_addr <=addr_i;
                    durum       <=MEMORY_CEK; 
                end else if(fetch_durdur==0) begin
                    buyruk_yollandi<=1;
                end
            end

            MEMORY_CEK:begin
                buyruk_memory_valid<=1;
                wstrb              <=4'b0;
                write_en<=1;
                if(buyruk_memory_ready)begin
                    write_en<=0;    
                    durum       <=MEMORY_KAYIT;  
                    buyruk_memory_valid<=0;

                end
            end

            MEMORY_KAYIT:begin 
                write_en    <=0;
                read_en     <=1;
                durum       <=CACHE_OKU;
                fetch_durdur<=0;
                buyruk_durum_o<=0;
            end

        endcase
    end
end


onbellek onbellek_hafizasi(
                .clk              (clk   ),
                .w_en             (write ),
                .r_en             (read  ),
                .addr             (adress),
                .data_in          (data),
                .data_o           (data_o)     

);




endmodule