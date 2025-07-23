/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module takes input addresses and reads or writes data in those addresses.
*/
module register(input regwrite, clk, input [4:0] read_addr1, read_addr2, write_addr,output [31:0] read_data1, read_data2, input [31:0] write_data);

reg [31:0] register_file[31:0];

// Asynchronous read ports (continuous assignment)
assign read_data1 = (read_addr1 == 5'd0) ? 32'd0 : register_file[read_addr1];
assign read_data2 = (read_addr2 == 5'd0) ? 32'd0 : register_file[read_addr2];

always @(posedge clk) begin
    if (regwrite && (write_addr != 0)) begin 
        register_file[write_addr] <= write_data;
    end
end

endmodule

//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
//|\\
