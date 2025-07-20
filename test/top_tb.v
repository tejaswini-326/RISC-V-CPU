`timescale 1ns/1ps

module tb_top();

    reg clk;
    reg reset_pc;

    top DUT(
        .clk(clk),
        .reset_pc(reset_pc)
    );

    always #5 clk = ~clk;
    integer cycle = 0;


    initial begin 
        $dumpfile("top.vcd");
        $dumpvars(0, tb_top);


        clk = 0;
        reset_pc = 1;


        #20;

        reset_pc = 0;

        #200;

        $finish;
    end

    always @(posedge clk) begin
    if (reset_pc == 0) begin
        cycle = cycle + 1;

        $display("==== Cycle %0d ====", cycle);
        $display("PC: %d | Instr: %h", DUT.curr_pc, DUT.instruction);
        $display("rs1: x%0d = %d | rs2: x%0d = %d", DUT.rs1, DUT.reg_read1, DUT.rs2, DUT.reg_read2);
        $display("rd: x%0d | Write Data: %d", DUT.rd, DUT.reg_write);
        $display("ALU op: %b | ALU ctl: %b | ALU out: %d | Zero: %b", DUT.ALUop, DUT.ALUcontrol, DUT.alu_output, DUT.alu_zero);
        $display("Branch: %b | MemRead: %b | MemWrite: %b | RegWrite: %b", DUT.Branch, DUT.MemRead, DUT.MemWrite, DUT.RegWrite);
        $display("-----------------------------");

        if (DUT.instruction == 32'hFFFFFFFF) begin
            $display("HALT instruction (0xFFFFFFFF) detected.");
            $finish;
        end
    end
end

    

endmodule
