module veri_onbellegi(

                input                clk            ,
                input                rst            ,
                input                read_en        ,
                input  [31:0]        read_adress    ,
                input  [31:0]        write_adress   ,
                input                write_en       ,
                output [31:0]        data_o         ,
                input  [31:0]        data_i         ,
                input                veriyolu_aktif ,
                output               sistem_durdur_o,


                output reg           iomem_valid     ,
                input                iomem_ready     ,
                output reg   [31:0]  iomem_addr      ,
                input        [31:0]  iomem_read_data , 
                output reg   [3:0]   iomem_wstrb     , 
                output reg   [31:0]  iomem_write_data,
                output reg           veri_durum_o      
                 
);




localparam IDLE            =4'b0000 ;
localparam MEM_VERI_CEK    =4'b0001 ;
localparam MEM_VERI_KAYDET =4'b0011 ;
localparam SON             =4'b0111 ;

reg         write;
reg         read;
reg         onay         [0:255];
reg [21:0]  etiket       [0:255];
reg [7:0]   adress;
reg [3:0]   durum =IDLE;
reg         hit   ;
integer     i;
reg           sistem_durdur;
reg write_mem_en;
wire cache_yaz;
reg  veri_kaydet;
reg [31:0] data;
assign cache_yaz=write_mem_en || write_en;

assign sistem_durdur_o=(!veriyolu_aktif)? (write_en && !sistem_durdur) || (!hit && read_en &&!sistem_durdur):0;

initial begin
    read<=0;
    write<=0;
    sistem_durdur<=0;
    iomem_valid<=0;
    hit=1'b0;
    veri_kaydet<=0;
    veri_durum_o<=0;
    for(i=0;i<256;i=i+1)begin
        onay[i]=0;
        etiket[i]=24'b0; 
    end
end

always @(*)
begin
        if(!rst)begin
            for(i=0;i<256;i=i+1)
            begin
                onay[i]=0;
                etiket[i]=24'b0;
            end
        end
        //Okuma yapÄ±ldÄ±gÄ±nda
        if(read_en==1 && write_en==0)begin
            
            if(read_adress[31:10]==etiket[read_adress[9:2]] && onay[read_adress[9:2]]==1)
                begin
                    hit =1;
                    read=1;
                    adress=read_adress[9:2];
                end 
            else 
                begin
                    hit =0;
                    read=0; 
                end 
        end else 
                begin
                    hit =0;
                    read=0;
                end 

        if(cache_yaz==1 )begin
            etiket[write_adress[9:2]]=write_adress[31:10];
            adress=write_adress[9:2];
            onay[write_adress[9:2]]=1;
            write=1;
        end else if(veri_kaydet==1) begin
            etiket[read_adress[9:2]]=read_adress[31:10];
            adress=read_adress[9:2];
            onay[read_adress[9:2]]=1;
            write=1;
        end
        else begin
            write=0;
        end
end




always @(posedge clk)begin
    if(!rst)begin
        durum<=IDLE;
        sistem_durdur<=0;
        iomem_valid<=0;
        veri_kaydet<=0;
        veri_durum_o<=0;
        /*for(i=0;i<256;i=i+1)begin
            onay[i]=0;
            etiket[i]=24'b0; 
    end*/
    end else begin
    case(durum)
        IDLE:begin
            write_mem_en<=0;
            if(write_en && !veriyolu_aktif)begin
                    veri_durum_o<=1;
                    sistem_durdur<=0;
                    durum=MEM_VERI_KAYDET;
            end
            else if(!hit)begin
                if(read_en & !veriyolu_aktif)begin
                    sistem_durdur<=0;
                    durum=MEM_VERI_CEK;
                end
                else begin
                    sistem_durdur<=0;
                end
            end else begin
                sistem_durdur<=0;
            end
        end

        MEM_VERI_CEK:begin
            iomem_valid<=1;
            iomem_addr <=read_adress;
            iomem_wstrb<=4'b0000;
            veri_kaydet<=1;
            data  =iomem_read_data;
            if(iomem_ready)begin
                veri_kaydet<=0;
                iomem_valid<=0;
                durum=SON;
                sistem_durdur<=1;
            end
        end

        MEM_VERI_KAYDET:begin
            iomem_valid<=1;
            iomem_addr <=write_adress;
            iomem_wstrb<=4'b1111;
            iomem_write_data<=data_i;
            data  =data_i;
            if(iomem_ready)begin
                write_mem_en <=1;
                iomem_valid  <=0;
                sistem_durdur <=1;
                durum        <=SON;
            end
        end

        SON:begin
                iomem_wstrb<=4'b0000;
                write_mem_en  <=1'b0;
                durum         <=IDLE;
                veri_durum_o  <=0;
        end
    endcase
    end
end



onbellek onbellek_hafizasi(
                .clk              (clk),
                .w_en             (write),
                .r_en             (read),
                .addr             (adress),
                .data_in          (data),
                .data_o           (data_o)     

);





endmodule