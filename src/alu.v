module alu(input [31:0] A, B, input [3:0] ALUcontrol, output reg [31:0] alu_output, output reg alu_zero);
always @(*) begin
    case (ALUcontrol) 
    4'b0010: alu_output =  A + B;
    4'b0110: begin alu_output =  A - B;
                    alu_zero = (A == B) end
    4'b0011: alu_output =  A ^ B;
    4'b0001: alu_output =  A | B;
    4'b0000: alu_output =  A & B;
    4'b1000: alu_output =  A << B;
    4'b1001: alu_output =  A >> B;
    4'b1010: alu_output =  A >>> B;
    4'b0111: begin alu_output = ($signed(A) < $signed(B)) ? 1 : 0;
                    alu_zero = ($signed(A) < $signed(B)) ? 1 : 0; end
    4'b1011: begin alu_output = (A < B) ? 1 : 0;
                    alu_zero = (A < B) ? 1 : 0; end
    4'b0100: begin alu_output =  (A == B) ? 1: 0;
                    alu_zero = (A == B) ? 1: 0; end
    4'b0101: begin alu_output =  (A != B) ? 1:0;
                    alu_zero = (A != B) ? 1:0; end
    4'b1100: begin alu_output =  ($signed(A) >= $signed(B)) ? 1:0; 
                    alu_zero = ($signed(A) >= $signed(B)) ? 1:0; end
    4'b1101: begin alu_output =  (A >= B) ? 1: 0; 
                    alu_zero =  (A >= B) ? 1: 0; end
    default: begin alu_zero = 0; 
                    alu_output = 0; end
    endcase
end
endmodule
