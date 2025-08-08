/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module keeps track of the current instruction being executed and loadsnthe next instruction
*/
module pc(input clk, reset, pcwrite,input [31:0]next_pc,  output reg [31:0] curr_pc );
always@(posedge clk) begin 
    if(reset) curr_pc <=  32'b0;
    else if(pcwrite)
    curr_pc <= next_pc;
    end
endmodule
