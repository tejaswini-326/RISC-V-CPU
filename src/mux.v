/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module is a simple 2 to 1 multiplexer
*/
module mux(input [31:0]input0, input1, input select, output  reg [31:0] mux_output);
always@(*) begin
    if(select) mux_output = input1;
    else mux_output = input0;
end
endmodule