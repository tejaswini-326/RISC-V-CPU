module pipeline(input clk, reset);
mux #(
    .num_inputs(2),
    .input_width(32)
)pc_mux(
    .allin({next_pc, b_adder}),
    .select(), //ceiling log base 2 value for number of select
    .mux_output(next_pc)
);

pc program_counter(
    .clk(clk),
    .reset(reset_pc),
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
    .input1({curr_pc, instruction, 
    MemRead, MemWrite, 
    MemtoReg, ALUsrc, Branch, 
    RegWrite, ALUop}),
    .output1({curr_pc, instruction, 
    MemRead, MemWrite, 
    MemtoReg, ALUsrc, Branch, 
    RegWrite, ALUop})
);

instruction_extractor instr_extr(
    .instruction(instruction),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode)
);

hazard_detector hazard();

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
    .input_width(7)
)control_mux(
    .allin({{MemRead, MemWrite, 
    MemtoReg, ALUsrc, Branch, 
    RegWrite, ALUop}, {7'b0}}),
    .select(hazard_out), //ceiling log base 2 value for number of select
    .mux_output(control_mux)
);

pipeline_reg (#256)idex(
    .input1({MemRead, MemWrite, 
    MemtoReg, ALUsrc, Branch, 
    RegWrite, ALUop,
    rs1,
    rs2,
    imm,
    rd,
    reg_read1,
    reg_read2
    }),
    .output1({MemRead, MemWrite, 
    MemtoReg, ALUsrc, Branch, 
    RegWrite, ALUop,
    rs1,
    rs2,
    imm,
    rd,
    reg_read1,
    reg_read2
    })
);
mux mux_a(
    .num_inputs(3);
    .input_width(32);
)(
    .allin({reg_read1, rd, alu_out}),
    .select(fwA), //ceiling log base 2 value for number of select
    .mux_output(A)
);
mux mux_b(
    .num_inputs(3),
    .input_width(32)
)(
    .allin({reg_read2, rd, alu_out}),
    .select(fwB), //ceiling log base 2 value for number of select
    .mux_output(B)
);
alu alu(
    .A(A),
    .B(B),
    .ALUcontrol(ALUcontrol),
    .alu_output(alu_out)
);

forward forward();

pipeline_reg (#193)exmem(
    .input1({MemRead, MemWrite, Branch,
    MemtoReg,
    RegWrite,
    rd,
    alu_out,
    B
    }),
    .output1({MemRead, MemWrite, Branch,
    MemtoReg,
    RegWrite,
    rd,
    alu_out,
    B
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
    .input1({MemtoReg,
    RegWrite,
    data_read_data,
    alu_out,
    rd}),
    .output1({MemtoReg,
    RegWrite,
    data_read_data,
    alu_out,
    rd})
);
mux #(
    .num_inputs(2),
    .input_width(32)
)last_mux(
    .allin({data_read_data, alu_out}),
    .select(), //ceiling log base 2 value for number of select
    .mux_output(reg_write)
);



endmodule