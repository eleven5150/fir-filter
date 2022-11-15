module filter(
    input signed[7:0]data,
    input clk,
    input input_data_flag,

    output reg done_flag = 1,
    output reg signed [31:0]sum = 0
);

reg signed [31:0]sum_tmp = 0;

reg signed [7:0] buff1 = 1;
reg signed [7:0] buff2 = 2;
reg signed [7:0] buff3 = 3;

always @(posedge clk)
begin
    if (input_data_flag == 1'b1)
        begin
            done_flag <= 0;
            buff3 <= buff2;
            buff2 <= buff1;
            buff1 <= data;
        end
end

reg signed [7:0] coef = 0;
reg signed [7:0] buff = 0;
wire signed [15:0] mult = buff * coef;


reg d1 = 0, d2 = 0, d3 = 0, d4 = 0, d5 = 0;

always@(posedge clk)
	begin
		d1 <= input_data_flag;
		d2 <= d1;
		d3 <= d2;
        d4 <= d3;
        d5 <= d4;

        buff <= d1 ? buff1 :
                d2 ? buff2 : 
                d3 ? buff3 : buff;
        coef <= d1 ? 2 :
                d2 ? 4 : 
                d3 ? 8 : coef;
        if(d5)        
			done_flag <= 1;

        if(input_data_flag == 1'b1)
            begin
                buff <= 0;
                coef <= 0;
            end

	end

always@(posedge clk)
    begin
        if(input_data_flag == 1'b1)
            sum_tmp <= 0;
        else if (!done_flag && !d5)
            sum_tmp <= sum_tmp + mult;
    end

always @(posedge clk)
begin
    if (done_flag)
    begin
        sum_tmp <= 0;
    end
    if(sum_tmp != 0)
        sum <= sum_tmp;
end

endmodule