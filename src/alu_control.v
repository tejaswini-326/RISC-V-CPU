/*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module receives instructions and sends operation signals to ALU
*/
module alu_control(input  [6:0] funct7,input  [2:0] funct3,input [31:0] imm, input  [1:0] ALUop,output reg [3:0] ALUcontrol);
always @(*) begin
    case(ALUop)
    2'b10: begin  // R-type
        case (funct3)
        3'd0 : begin
            case(funct7)
                7'd0: ALUcontrol = 4'b0010; // C = A + B
                7'd32: ALUcontrol = 4'b0110; // C = A - B
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd1 : ALUcontrol = 4'b1000; // C = A << B
        3'd2 : ALUcontrol = 4'b0111; // C = ($signed(A) < $signed(B)) ? 1 : 0
        3'd3 : ALUcontrol = 4'b1011; // C = (A < B) ? 1 : 0
        3'd4 : ALUcontrol = 4'b0011; // C = A ^ B
        3'd5 : begin
            case(funct7)
                7'd0: ALUcontrol = 4'b1001; // C = A >> B
                7'd32: ALUcontrol = 4'b1010; // C = A >>> B
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd6 : ALUcontrol = 4'b0001; // C = A | B
        3'd7 : ALUcontrol = 4'b0000; // C = A & B
        default: ALUcontrol = 4'b1111;
        endcase
    end

    2'b11: begin  // I-type
        case (funct3)
        3'd0 : ALUcontrol = 4'b0010; // C = A + imm
        3'd1 : ALUcontrol = 4'b1000; // C = A << imm[4:0]
        3'd2 : ALUcontrol = 4'b0111; // C = ($signed(A) < $signed(imm)) ? 1 : 0
        3'd3 : ALUcontrol = 4'b1011; // C = (A < imm) ? 1 : 0
        3'd4 : ALUcontrol = 4'b0011; // C = A ^ imm
        3'd5 : begin
            case(imm[11:5])
                7'd0: ALUcontrol = 4'b1001; // C = A >> imm[4:0]
                7'd32: ALUcontrol = 4'b1010; // C = A >>> imm[4:0]
                default: ALUcontrol = 4'b1111;
            endcase
        end
        3'd6 : ALUcontrol = 4'b0001; // C = A | imm
        3'd7 : ALUcontrol = 4'b0000; // C = A & imm
        default: ALUcontrol = 4'b1111;
        endcase
    end

    2'b01: begin  // B-type
        case (funct3)
        3'd0 : ALUcontrol = 4'b0100; // a==b
        3'd1 : ALUcontrol = 4'b0101; // a!=b
        3'd4 : ALUcontrol = 4'b0111; // signed a<b
        3'd5 :ALUcontrol = 4'b1100; //signed a> b
        3'd6 : ALUcontrol = 4'b1011; // a < b
        3'd7 : ALUcontrol = 4'b1101; // a >=b
        default: ALUcontrol = 4'b1111;
        endcase
    end

    2'b00: begin 
        ALUcontrol = 4'b0010;

    end

    default: ALUcontrol = 4'b1111; // C = invalid
    endcase
end
endmodule
