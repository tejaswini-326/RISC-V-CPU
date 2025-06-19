module pc(input clk, reset, input [31:0]next_pc,  output [31:0] curr_pc );
always@(posedge clk) begin 
    if(reset) curr_pc <=  32'b0; 
    else curr_pc <= next_pc;
end

endmodule
