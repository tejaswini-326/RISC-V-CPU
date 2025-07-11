/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module reads instructions from a file contraining instructions and stores it in a 32bit register
*/
module instruction_memory (
    input [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] memory [0:255]; // 1KB instruction memory

    assign instruction = memory[addr[9:2]]; // word-aligned access

    initial begin
        $readmemh("program.hex", memory); // loads hex file into memory
    end

endmodule
