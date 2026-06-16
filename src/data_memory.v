/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module is a 32bit register which is used to load and store data
*/
module datamemory(input wire clk, MemRead, MemWrite, input reg [31:0] addr, writedata, output reg [31:0] readdata);

reg [31:0] memory [0:527];

always@(posedge clk) begin 
    if(MemWrite) begin 
        memory[addr[9:2]] <= writedata;
    end
end

always @(*) begin 
    if(MemRead) begin 
        readdata = memory[addr[9:2]];
    end
    else begin 
        readdata = 32'b0;
    end
end

endmodule