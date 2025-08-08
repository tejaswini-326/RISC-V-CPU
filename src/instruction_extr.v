 /*
Dev: Tejaswini Anbazhagan
Date: 11/7/2025
Description: this module receives a 32 bit instruction and splits it into sub parts depending on instruction type
*/
 module instruction_extractor(input [31:0] instruction, output reg [4:0] rs1, rs2, rd, output reg [6:0] funct7, output reg [2:0]funct3, output reg [31:0] imm, output wire [6:0]opcode);
 assign opcode = instruction[6:0];
 always @(*) begin 
 case(instruction[6:0]) 
    7'd 51: begin //r-type
        imm = 32'b0;
        rd = instruction[11:7];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct7 = instruction[31:25];
     end 
     7'd19: begin //i-type
        imm = {{20{instruction[31]}}, instruction[31:20]};
        rs1 = instruction[19:15];
        rs2 = 5'b0;
        funct3 =instruction[14:12];
        rd = instruction[11:7];
        funct7 = 7'b0;
     end
     7'd3: begin //i-type
        imm = {{20{instruction[31]}}, instruction[31:20]};
        rs1 = instruction[19:15];
        rs2 = 5'b0;
        funct3 =instruction[14:12];
        rd = instruction[11:7];
        funct7 = 7'b0;
     end
     7'd115: begin //i-type
        imm = {{20{instruction[31]}}, instruction[31:20]};
        rs1 = instruction[19:15];
        rs2 = 5'b0;
        funct3 =instruction[14:12];
        rd = instruction[11:7];
        funct7 = 7'b0;
     end
     7'd103: begin //i-type
        imm = {{20{instruction[31]}}, instruction[31:20]};
        rs1 = instruction[19:15];
        rs2 = 5'b0;
        funct3 =instruction[14:12];
        rd = instruction[11:7];
        funct7 = 7'b0;
     end

     7'd 35: begin //s-type
        imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        rs2 = instruction[24:20];
        rs1 = instruction[19:15];
        funct3 = instruction[14:12];
        rd = instruction[11:7];
        funct7 = 7'b0;
                
      end
      7'd 99: begin //b-type
        imm = {{19{instruction[31]}},instruction[31], instruction[7], instruction[30:25], instruction[11:6], 1'd0}; //last bit of b type is always 0 cause branches are word aligned
        rs2 = instruction[24:20];
        rs1 = instruction[19:15];
        rd = instruction[11:7];
        funct3 = instruction[14:12];
        funct7 = 7'b0;
      end
      7'd23: begin //u-type
        imm = {instruction[31:12], 12'b0};
        rd = instruction[11:7];
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
      end
      7'd55: begin //u-type
        imm = {instruction[31:12], 12'b0};
        rd = instruction[11:7];
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
      end
      7'd111: begin //j-type 
        imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; //again implicit 0 at im[0]
        rd = instruction[11:7];
        rs1 = 5'b0;
        rs2 = 5'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
      end
      default: begin
        imm = 32'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        rd  = 5'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
      end

  endcase
 end
 endmodule

