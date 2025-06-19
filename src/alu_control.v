module alu_control(input  [6:0] funct7, input  [2:0] funct3, input [11:0] imm, input  [1:0] ALUop, output reg [3:0] ALUcontrol);
always @(*) begin
    case(ALUop)
    2'b00: begin  //r type
        case (funct3)
        3'd0 : begin
            case(funct7)
                7'd0: ALUcontrol = 4'b0010; //add
                7'd2: ALUcontrol = 4'b0110; //sub
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd1 : ALUcontrol = 4'b1000; //sll
        3'd2 : ALUcontrol = 4'b0111; //slt
        3'd3 : ALUcontrol = 4'b1011; //sltu
        3'd4 : ALUcontrol = 4'b0011; //xor
        3'd5 : begin
            case(funct7)
                7'd0: ALUcontrol = 4'b1001; //srl
                7'd2: ALUcontrol = 4'b1010; //sra
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd6 : ALUcontrol = 4'b0001; //or
        3'd7 : ALUcontrol = 4'b0000; //and
        default: ALUcontrol = 4'b1111;
        endcase
    end

    2'b11: begin  //I type
        case (funct3)
        3'd0 : ALUcontrol = 4'b0010; //addi
        3'd1 : ALUcontrol = 4'b1000; //slli
        3'd2 : ALUcontrol = 4'b0111; //slti
        3'd3 : ALUcontrol = 4'b1011; //sltiu
        3'd4 : ALUcontrol = 4'b0011; //xori
        3'd5 : begin
            case(imm[11:5])
                7'd0: ALUcontrol = 4'b1001; //srli
                7'd2: ALUcontrol = 4'b1010; //srai
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd6 : ALUcontrol = 4'b0001; //ori
        3'd7 : ALUcontrol = 4'b0000; //andi
        default: ALUcontrol = 4'b1111;
        endcase
    end

    default: ALUcontrol = 4'b1111; //nvalid ALUop
    endcase
end
endmodule
