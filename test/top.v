/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module integrates all components of the CPU. I.e this is a single cycle cpu i made initially. should have githubbed before. tch.
*/
module top(input clk, reset_pc);
wire [31:0] curr_pc, next_pc, instruction, imm;
wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire [31:0] reg_read1, reg_read2, reg_write;
    wire [31:0] alu_r2, alu_output, data_read_data;
    wire MemRead, MemWrite, MemtoReg, ALUsrc, Branch, RegWrite;
    wire [1:0] ALUop;
    wire [3:0] ALUcontrol;
    wire [31:0] pc_add;
    wire [31:0] imm_sll;
    wire [31:0] b_adder;
    wire alu_zero;


alu pc_adder(
    .A(curr_pc),
    .B(32'd4),
    .ALUcontrol(4'b0010),
    .alu_output(pc_add)
);

alu branch_sll(
    .A(imm),
    .B(32'd1),
    .ALUcontrol(4'b1000),
    .alu_output(imm_sll)

);

alu branch_adder(
    .A(curr_pc),
    .B(imm_sll),
    .ALUcontrol(4'b0010),
    .alu_output(b_adder)
);

mux pc_mux(
    .input0(pc_add),
    .input1(b_adder),
    .select((alu_zero & Branch)),
    .mux_output(next_pc)
);

pc program_counter(
    .clk(clk),
    .reset(reset_pc),
    .next_pc(next_pc),
    .curr_pc(curr_pc)
);
instruction_memory instruction_memory(
    .addr(curr_pc),
    .instruction(instruction)
);

instruction_extractor instruction_extractor(
    .instruction(instruction),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode)
);

control_unit CU(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUsrc(ALUsrc),
    .Branch(Branch),
    .RegWrite(RegWrite),
    .ALUop(ALUop)
); 

register register(
    .clk(clk),
    .regwrite(RegWrite),
    .read_addr1(rs1),
    .read_addr2(rs2),
    .write_addr(rd),
    .read_data1(reg_read1),
    .read_data2(reg_read2),
    .write_data(reg_write)//////////need to get from data memory
);

alu_control alu_control(
    .funct3(funct3),
    .funct7(funct7),
    .imm(imm),
    .ALUop(ALUop),
    .ALUcontrol(ALUcontrol)
);
mux alu_mux(
    .input0(reg_read2),
    .input1(imm),
    .select(ALUsrc),
    .mux_output(alu_r2)
);

alu alu(
    .A(reg_read1),
    .B(alu_r2),
    .ALUcontrol(ALUcontrol),
    .alu_output(alu_output),
    .alu_zero(alu_zero)
);

datamemory data_memory(
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .addr(alu_output),
    .writedata(reg_read2),
    .readdata(data_read_data)
);
mux data_mux(
    .input0(alu_output),
    .input1(data_read_data),
    .select(MemtoReg),
    .mux_output(reg_write)
);

endmodule