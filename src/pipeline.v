module pipeline(input clk, reset);
mux #(
    .num_inputs(2),
    .input_width(32)
)pc_mux(
    .allin({next_pc, b_adder}),
    .select(Branch&alu_zero), 
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

pipeline_reg (#96)ifid(
    .clk(clk),
    .reset(reset),
    .input1({curr_pc, instruction, 32'b0}),
    .output1({ifid_pc, ifid_instruction, 32'b0})
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
    .idex({control_mux, rs1, rs2, imm,
    rd,
    reg_read1,
    reg_read2, 138'b0
    }),   
    .ifid_regwrite(ifid_regwrite), 
    .pcwrite(pcwrite),
    .stall(stall)
);

alu_control alu_control(
    .funct3(funct3),
    .funct7(funct7),
    .imm(imm),
    .ALUop(ALUop),
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
    .regwrite(RegWrite),
    .read_addr1(rs1),
    .read_addr2(rs2),
    .write_addr(rd),
    .read_data1(reg_read1),
    .read_data2(reg_read2),
    .write_data(reg_write)
);

alu reg_compare(
    .A(reg_read1),
    .B(reg_read2),
    .ALUcontrol(4'b0100),
    .alu_output(b_eq)
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

mux #(   
    .num_inputs(2),
    .input_width(8),
)control_mux(
    .allin({{MemRead, MemWrite, MemtoReg, ALUsrc, Branch, RegWrite, ALUop}, {8'b0}}),
    .select(stall), 
    .mux_output(control_mux)
);

pipeline_reg (#256)idex(
    .clk(clk),
    .reset(reset),
    .regwrite(ifid_regwrite),
    .input1({control_mux, rs1,rs2, imm, rd, reg_read1, reg_read2, 138'b0}),
    .output1({idex_out_control, idex_out_rs1, idex_out_rs2, imm, idex_out_rd, reg_out_read1, reg_out_read2, 138'b0})
);
mux #(
    .num_inputs(3),
    .input_width(32)
)mux_a(
    .allin({reg_read1, reg_write, alu_out}),
    .select(fwA), 
    .mux_output(A)
);
mux #(
    .num_inputs(3),
    .input_width(32)
)mux_b(
    .allin({reg_read2, reg_write, alu_out}),
    .select(fwB), 
    .mux_output(B)
);
alu alu(
    .A(A),
    .B(B),
    .ALUcontrol(ALUcontrol),
    .alu_output(alu_output),
    .alu_zero(alu_zero)
);

forward forward(
.idex({control_mux, rs1,rs2, imm, rd, reg_read1, reg_read2, 138'b0}),
.exmem({idex_out_control,
    idex_out_rd,
    alu_out,
    B_in,
    117'b0
    }),
.memwb({exmem_out_control,
    data_read_data,
    alu_out2,
    exmem_out_rd}),
.fwA(fwA),
.fwB(fwB)

);

pipeline_reg (#193)exmem(
    .input1({idex_out_control,
    idex_out_rd,
    alu_out,
    B_in,
    117'b0
    }),
    .output1({exmem_out_control,
    exmem_out_rd,
    alu_out2,
    B_out,
    117'b0
    })
);

data_memory data(
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .addr(alu_out),
    .writedata(B),
    .readdata(data_read_data)
);
pipeline_reg (#128)memwb(
    .input1({exmem_out_control,
    data_read_data,
    alu_out2,
    exmem_out_rd}),
    .output1({memwb_control,
    data_read_data,
    alu_out,
    rd, 57'b0})
);
mux #(
    .num_inputs(2),
    .input_width(32)
)last_mux(
    .allin({data_read_data, alu_out}),
    .select(MemtoReg), 
    .mux_output(reg_write)
);



endmodule