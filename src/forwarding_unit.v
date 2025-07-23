module forward(
    input [255:0] idex,
    input [192:0] exmem,
    input [127:0] memwb,
    output reg [1:0] fwA,
    output reg [1:0] fwB
);

    reg exmem_regwrite, memwb_regwrite;
    reg [4:0] idex_rs1, idex_rs2, exmem_rd, memwb_rd;

    always @(*) begin
        idex_rs1 = idex[247:243];
        idex_rs2 = idex[242:238];
        exmem_rd = exmem[184:180];
        memwb_rd = memwb[55:51];

        exmem_regwrite = exmem[187];
        memwb_regwrite = memwb[122];

        fwA = 2'b00;
        fwB = 2'b00;
        if (exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs1))
            fwA = 2'b10;
        if (exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs2))
            fwB = 2'b10;

        if (memwb_regwrite && (memwb_rd != 0) &&
            !(exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs1)) &&
            (memwb_rd == idex_rs1))
            fwA = 2'b01;

        if (memwb_regwrite && (memwb_rd != 0) &&
            !(exmem_regwrite && (exmem_rd != 0) && (exmem_rd == idex_rs2)) &&
            (memwb_rd == idex_rs2))
            fwB = 2'b01;
    end

endmodule
