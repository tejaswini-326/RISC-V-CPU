`timescale 1ns/1ps

module pipeline_tb;
    reg clk = 0;
    reg reset = 1;
    reg reset_pc = 1;

    pipeline DUT (
        .clk(clk),
        .reset(reset),
        .reset_pc(reset_pc)
    );

    always #5 clk = ~clk;

    integer cycle = 0;

    initial begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0, pipeline_tb.DUT);

        // Apply resets
        #12 reset = 0;
        reset_pc = 0;

        // Timeout if HALT not detected
        #200;
        $display("Timed out without HALT instruction.");
        $finish;
    end

    always @(posedge clk) begin
        cycle = cycle + 1;

        $display("\n========== Cycle %0d ==========", cycle);
        $display("PC        : 0x%08h", DUT.curr_pc);
        $display("Instr     : 0x%08h", DUT.instruction);

        $display("Decoded   : opcode = 0x%02h | rd = x%0d | rs1 = x%0d | rs2 = x%0d",
                 DUT.opcode, DUT.rd, DUT.rs1, DUT.rs2);

        $display("Immediate : 0x%08h", DUT.imm);

        $display("ALU Out   : 0x%08h", DUT.alu_out);
        $display("WB stage  : rd = x%0d | data = 0x%08h",
                 DUT.memwb_rd, DUT.reg_write);

        // Optional: check if ALU zero is being used
        $display("ALU Zero  : %b", DUT.alu_zero);
        $display("Cycle %0d | PC: %h | next_pc: %h | pcwrite: %b", 
          cycle, DUT.curr_pc, DUT.next_pc, DUT.pcwrite);
        $display("curr_pc = %h | pc_add = %h | next_pc = %h", DUT.curr_pc, DUT.pc_add, DUT.next_pc);
        $display("Cycle %0d | ifid_regwrite = %b", cycle, DUT.ifid_regwrite);



        // Detect HALT instruction (0xFFFFFFFF)
        if (DUT.ifid_instruction === 32'hFFFFFFFF) begin
            $display("HALT instruction detected at cycle %0d", cycle);
            $finish;
        end
    end
endmodule
