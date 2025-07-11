`timescale 1ns/1ps

module tb_top();

    reg clk;
    reg reset_pc;
    reg readwrite_register;

    top DUT(
        .clk(clk),
        .reset_pc(reset_pc),
        .readwrite_register(readwrite_register)
    );

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("top.vcd");
        $dumpvars(0, tb_top);

        clk = 0;
        reset_pc = 1;
        readwrite_register = 0;

        #20;

        reset_pc = 0;
        readwrite_register = 1;

        #200;

        $finish;
    end

endmodule
