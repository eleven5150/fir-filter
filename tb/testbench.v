module tb;
    reg clk = 0;
    reg [7:0] data;
    reg valid;

    initial
        forever #5 clk=~clk;

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

    filter filter0(
        .clk(clk),
        .data(data),
        .input_data_flag(valid)
    );

endmodule