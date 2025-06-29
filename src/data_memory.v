module datamemory(input wire clk, MemRead, MemWrite, input reg [31:0] addr, writedata, output reg [31:0] readdata);

reg [31:0] memory [0:255];

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