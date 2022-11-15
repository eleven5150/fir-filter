module fir_filter(
    input signed[7:0]input_data,
    input clk,
    input input_data_flag,

    output reg done_flag = 1,
    output reg signed [31:0]result = 0
);


reg signed [7:0] data[2:0];
reg signed [7:0] coefs[2:0];
reg signed [7:0] curr_coef = 0;
reg signed [7:0] curr_data = 0;
wire signed [15:0] mult = curr_data * curr_coef;
reg [2:0] cnt = 0;


integer i;
initial begin
    for (i = 0; i < 3; i = i + 1)
        begin
            data[i] = i + 1;
            coefs[i] = (i + 1) * 2;
        end
end


always @(posedge clk)
begin
    if (input_data_flag == 1)
        begin
            done_flag <= 0;
            for (i = 2; i >= 0; i = i - 1)
            begin
                if(i != 0)
                    data[i] <= data[i - 1];
                else
                begin
                    data[i] <= input_data;
                end
            end
        end
end


always@(posedge clk)
	begin
        if(cnt != 0)
            cnt <= cnt + 1;
        else
		    cnt <= input_data_flag;
        
        curr_data <= cnt > 0 && cnt < 4 ? data[cnt - 1] : curr_data;
        curr_coef <= cnt > 0 && cnt < 4 ? coefs[cnt - 1] : curr_coef;

        if(cnt == 4)
        begin
            cnt <= 0;        
			done_flag <= 1;
        end

        if(input_data_flag == 1)
            begin
                curr_data <= 0;
                curr_coef <= 0;
            end

	end

always@(posedge clk)
    begin
        if(input_data_flag == 1)
            result <= 0;
        else if (!done_flag)
            result <= result + mult;
    end

endmodule