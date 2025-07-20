module pipe_reg#(parameter REG_SIZE)(input clk, reset, input [REG_SIZE-1:0] input1, output reg [REG_SIZE-1:0]output1);
always @(posedge clk) begin 
    if(reset) begin
        output1 <= 0;
     end
     else begin 
        output1 <= input1;
     end
end

endmodule