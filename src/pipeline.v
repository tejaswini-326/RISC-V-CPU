module pipeline(input clk, reset_pc, reset);
wire [31:0] curr_pc, next_pc, pc_add, b_adder;
wire [31:0] instruction;
wire [31:0] reg_write, reg_read1, reg_read2;
wire [31:0] imm, imm_sll;
wire [31:0] A, B;
wire [31:0] alu_output, alu_out, alu_out2, B_in, B_out;
wire [31:0] data_read_data;
wire [31:0] b_eq;
wire alu_zero, branch_alu_zero;
wire [3:0] ALUcontrol;
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0]rs1, rs2, rd;
wire MemRead, MemWrite, MemtoReg, ALUsrc, Branch, RegWrite;
wire [1:0] ALUop;
// IF/ID
wire [31:0] ifid_pc, ifid_instruction, ifid_dummy;

// ID/EX
wire [7:0] idex_out_control;
wire [4:0] idex_out_rs1, idex_out_rs2, idex_out_rd;
wire [31:0] reg_out_read1, reg_out_read2, imm_out;
wire [136:0] idex_dummy;

// EX/MEM
wire [7:0] exmem_out_control;
wire [4:0] exmem_out_rd;
wire [115:0] exmem_dummy;

// MEM/WB
wire [7:0] memwb_control;
wire [31:0] memwb_data_read_data, memwb_alu_out, mux_B;
wire [4:0] memwb_rd;
wire [50:0] memwb_dummy;

wire ifid_regwrite, pcwrite;
wire [1:0]stall;
wire [1:0] fwA, fwB;

wire[7:0] control_mux_wire;
wire idex_enable, exmem_enable, memwb_enable;
assign idex_enable = 1'b1;
assign exmem_enable = 1'b1;
assign memwb_enable = 1'b1;

alu pc_adder(
    .A(curr_pc),
    .B(32'd4),
    .ALUcontrol(4'b0010),
    .alu_output(pc_add)
);

mux #(
    .num_inputs(2),
    .input_width(32)
)pc_mux(
    .allin({b_adder, pc_add}),
    .select({exmem_out_control[3]&branch_alu_zero}),  //
    .mux_output(next_pc)
);

pc program_counter(
    .clk(clk),
    .reset(reset_pc),
    .pcwrite(pcwrite),
    .next_pc(next_pc),
    .curr_pc(curr_pc)

);
instruction_memory im(
    .addr(curr_pc),
    .instruction(instruction)
);

pipeline_reg #(96)ifid(
    .clk(clk),
    .reset(reset),
    .regwrite(ifid_regwrite),
    .input1({curr_pc, instruction, 32'b0}),
    .output1({ifid_pc, ifid_instruction, ifid_dummy})
);

instruction_extractor instr_extr(
    .instruction(ifid_instruction),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode)
);

hazard_detector hazard(
    .rs1(rs1),
    .rs2(rs2),
    .idex({idex_out_control, idex_out_rs1, idex_out_rs2, imm_out, idex_out_rd, reg_out_read1, reg_out_read2, idex_dummy}),   
    .ifid_regwrite(ifid_regwrite), 
    .pcwrite(pcwrite),
    .stall(stall)
);

alu_control alu_control(
    .funct3(funct3),
    .funct7(funct7),
    .imm(imm),
    .ALUop(idex_out_control [1:0]),
    .ALUcontrol(ALUcontrol)
);

control_unit control(
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
    .regwrite(memwb_control[2]),
    .read_addr1(rs1),
    .read_addr2(rs2),
    .write_addr(memwb_rd),
    .read_data1(reg_read1),
    .read_data2(reg_read2),
    .write_data(reg_write)
);

alu reg_compare(
    .A(reg_read1),
    .B(reg_read2),
    .ALUcontrol(4'b0100),
    .alu_output(b_eq),
    .alu_zero(branch_alu_zero)
);

alu branch_sll(
    .A(imm),
    .B(32'd1),
    .ALUcontrol(4'b1000),
    .alu_output(imm_sll)
);

alu branch_adder(
    .A(ifid_pc),
    .B(imm_sll),
    .ALUcontrol(4'b0010),
    .alu_output(b_adder)
);

mux #(   
    .num_inputs(2),
    .input_width(8)
)control_mux(
    .allin({{8'b0}, {MemRead, MemWrite, MemtoReg, ALUsrc, Branch, RegWrite, ALUop}}),
    .select(stall[0]),
    .mux_output(control_mux_wire)
);

pipeline_reg #(256)idex(
    .clk(clk),
    .reset(reset),
    .regwrite(idex_enable),
    .input1({control_mux_wire, rs1, rs2,  imm, rd, reg_read1, reg_read2, 137'b0}),
    .output1({idex_out_control, idex_out_rs1, idex_out_rs2, imm_out, idex_out_rd, reg_out_read1, reg_out_read2, idex_dummy})
);
mux #(
    .num_inputs(3),
    .input_width(32)
)mux_a(
    .allin({alu_out2, reg_write, reg_out_read1}),
    .select(fwA), 
    .mux_output(A)
);
mux #(
    .num_inputs(3),
    .input_width(32)
)mux_b(
    .allin({alu_out2, reg_write, reg_out_read2}),
    .select(fwB), 
    .mux_output(mux_B)

);

mux #(
    .num_inputs(2),
    .input_width(32)
)alu_mux(
    .allin({imm_out, mux_B}),
    .select(idex_out_control[4]),
    .mux_output(B)
);
alu alu(
    .A(A),
    .B(B),
    .ALUcontrol(ALUcontrol),
    .alu_output(alu_out),
    .alu_zero(alu_zero)
);

forward forward(
.idex({idex_out_control, idex_out_rs1, idex_out_rs2, imm_out, idex_out_rd, reg_out_read1, reg_out_read2, idex_dummy}),
.exmem({exmem_out_control, exmem_out_rd, alu_out2, B_out, exmem_dummy}),
.memwb({memwb_control, memwb_data_read_data, memwb_alu_out, memwb_rd, memwb_dummy}),
.fwA(fwA),
.fwB(fwB)
);

pipeline_reg #(193)exmem(
    .clk(clk),
    .reset(reset),
    .regwrite(exmem_enable),
    .input1({idex_out_control, idex_out_rd, alu_out, B, 116'b0}),
    .output1({exmem_out_control, exmem_out_rd, alu_out2, B_out, exmem_dummy})
);

datamemory data(
    .clk(clk),
    .MemRead(exmem_out_control[7]),
    .MemWrite(exmem_out_control[6]),
    .addr(alu_out2),
    .writedata(B_out),
    .readdata(data_read_data)
);

pipeline_reg #(128)memwb(
    .clk(clk),
    .reset(reset),
    .regwrite(memwb_enable),
    .input1({exmem_out_control, data_read_data, alu_out2, exmem_out_rd, 51'b0}),
    .output1({memwb_control, memwb_data_read_data, memwb_alu_out, memwb_rd, memwb_dummy})
);

mux #(
    .num_inputs(2),
    .input_width(32)
)last_mux(
    .allin({memwb_data_read_data, memwb_alu_out}),
    .select(memwb_control[5]), 
    .mux_output(reg_write)
);



endmodule