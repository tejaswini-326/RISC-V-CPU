/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module is a simple 2 to 1 multiplexer
*/
module mux #(
    parameter int num_inputs = 2,
    parameter int input_width = 32
)(
    input [input_width*num_inputs-1:0] allin,
    input [$clog2(num_inputs)-1:0] select, //ceiling log base 2 value for number of select
    output reg [input_width-1:0] mux_output
);

always@(*) begin
    mux_output = allin[select * input_width +: input_width];
end

endmodule
