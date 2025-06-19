module alu(input [31:0] A, B, input [3:0] ALUcontrol, output [31:0] alu_output);
always @(*) begin
    case (opcode)
    7'd51: begin
    case (funct3)
        3'd0 : begin
            case(funct7)
                7'd0: C = A + B;
                7'd2: C = A - B;
            endcase; end;
        3'd1 : C = A >> 1;
        3'd2 : C = $signed(A) < $signed(B);
        3'd3 : C = A < B;
        3'd4 : C = A ^ B;
        3'd5 : begin
            case(funct7)
                    7'd0: C = A << 1;
                    7'd2: C = A <<< 1;
            endcase;
        end;
        3'd6 : C = A | B;
        3'd7 : C = A & B;
    endcase;
    end
    7'd19: begin
         case (funct3)
        3'd0 : C = A + imm; 
        3'd1 : C = A << imm[4:0];
        3'd2 : C = ($signed(A) < $signed(imm))?1:0;
        3'd3 : C = (A < imm)?1:0;
        3'd4 : C = A ^ imm;
        3'd5 : begin case (imm[11:5])
                    7'd 0: C = A >> imm[4:0];
                    7'd 2: C = A >>> imm[4:0];
        endcase;
        end;
        3'd6 : C = A | imm;
        3'd7 : C = A & imm;

    endcase
    end
    default: C = 32'd0;
    endcase
$display("%b", C);
end
endmodule
