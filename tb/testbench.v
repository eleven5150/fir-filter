module tb;
    reg tb_clk = 0;
    reg [7:0] data;
    reg valid;

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
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

    fir_filter filter_instance(
        .clk(tb_clk),
        .input_data(data),
        .input_data_flag(valid)
    );

endmodule