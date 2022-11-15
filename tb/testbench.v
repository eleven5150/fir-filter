module tb;
    reg tb_clk = 0;
    reg [7:0] data;
    reg valid;

    localparam TB_NUM_OF_TAPS = 3;
    localparam TB_INPUT_WIDTH = 8;
    localparam TB_COEF_WIDTH = 8;

    initial
        forever #5 tb_clk=~tb_clk;

    initial 
    begin
        valid = 0;
        data = 0;
        #5
        valid = 1;
        data = 17;
        #10
        valid = 0;
        #90
        valid = 1;
        data = 18;
        #10
        valid = 0;
    end

    initial
    begin
        $dumpfile("fir_filter.vcd");
        $dumpvars(0, tb);
    end

    fir_filter #(
            .NUM_OF_TAPS(TB_NUM_OF_TAPS),
            .INPUT_WIDTH(TB_INPUT_WIDTH),
            .COEF_WIDTH(TB_COEF_WIDTH)
          ) filter_instance(
        .clk(tb_clk),
        .input_data(data),
        .input_data_flag(valid)
    );

endmodule