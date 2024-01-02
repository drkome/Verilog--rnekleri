module pwm(

        input         clk_i,
        input         reset_i,
        input  [31:0] threshold,
        input  [31:0] step,
        input  [31:0] period_counter,
        output reg pwm_o

);

 reg [31:0] counter;



always@(posedge clk_i)begin
    if(reset_i)begin
        counter<=0;
        pwm_o  <=0;
    end else begin
    if(counter<threshold)begin
        counter=counter+step;
        pwm_o=1;
    end else if(counter>=threshold && counter<period_counter)begin
            pwm_o<=0;
            counter<=counter+step;
    end else begin
            counter<=0;
    end

    end

end




endmodule