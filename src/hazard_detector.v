/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module implements pipeline flushing and stalling
*/
module hazard_detector(input [4:0]rs1, rs2, input[255:0]idex, output reg ifid_regwrite, pcwrite, output reg [1:0]stall);
reg[4:0] idex_rd;
reg idex_memread;
always@(*) begin 
    stall = 2'b00;
    idex_rd = idex[205:201];
    idex_memread = idex[255];
    if((idex_memread) && (idex_rd!=0) && ((idex_rd == rs1)||(idex_rd == rs2))) begin 
        ifid_regwrite= 1'b0;
        pcwrite = 1'b0;
        stall = 2'b01;
    end else begin 
        ifid_regwrite = 1'b1;
        pcwrite = 1'b1;
        stall = 2'b00;
    end
end
endmodule