module mux(input [31:0]input0, input1, input select, output  reg [31:0] mux_output);
always@(*) begin
    if(select) mux_output = input1;
    else mux_output = input0;
end
endmodule