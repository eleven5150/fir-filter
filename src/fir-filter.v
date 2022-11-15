module fir_filter(
    input signed[7:0]input_data,
    input clk,
    input input_data_flag,

    output reg done_flag = 1,
    output reg signed [31:0]result = 0
);

reg signed [31:0]sum_internal = 0;

reg signed [7:0] data[2:0];

integer i;
initial begin
    for (i = 0; i < 3; i = i + 1)
        begin
            data[i] = 0;
        end
end


reg idx = 0;
always @(posedge clk)
begin
    if (input_data_flag == 1'b1)
        begin
            done_flag <= 0;
            for (idx = 2; idx >= 0; idx--)
                if(idx != 0)
                    data[idx - 1] = data[idx];
                else
                    data[idx] = input_data;
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

        buff <= d1 ? data[0] :
                d2 ? data[1] : 
                d3 ? data[2] : buff;
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
            sum_internal <= 0;
        else if (!done_flag && !d5)
            sum_internal <= sum_internal + mult;
    end

always @(posedge clk)
begin
    if (done_flag)
    begin
        sum_internal <= 0;
    end
    if(sum_internal != 0)
        result <= sum_internal;
end

endmodule