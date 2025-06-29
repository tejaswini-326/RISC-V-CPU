module control_unit(input [6:0]funct7, opcode, input [2:0] funct3, output reg MemRead, MemWrite, MemtoReg, ALUsrc, Branch, RegWrite, ALUop);
always@(*)begin
    case(opcode)
    7'd51 : begin //r type 
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        Branch = 1'b0;
        RegWrite = 1'b1;
        ALUop = 2'b00;
    end
    7'd19 : begin  //i type
        MemRead = 1'b0;
        MemtoReg =1'b0 ;
        MemWrite = 1'b0;
        ALUsrc =1'b1;
        Branch = 1'b0;
        RegWrite = 1'b1;
        ALUop = 2'b11;
    end
    7'd3 : begin  //load type
        MemRead = 1'b1;
        MemtoReg = 1'b1;
        MemWrite = 1'b0;
        ALUsrc =1'b1 ;
        Branch = 1'b0;
        RegWrite = 1'b1;
        ALUop = 2'b01;
    end
    7'd35 : begin //store type
        MemRead = 1'b0;
        MemtoReg = 1'bx;
        MemWrite = 1'b1;
        ALUsrc = 1'b1;
        Branch = 1'b0;
        RegWrite = 1'b0;
        ALUop = 2'b01;
    end
    7'd99 : begin //branch
        MemRead = 1'b0;
        MemtoReg = 1'bx;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        Branch = 1'b1;
        RegWrite = 1'b0;
        ALUop = 2'b10;
    end
    7'd111 : begin //jal
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUsrc = 1'bx;
        Branch = 1'b0;
        RegWrite = 1'b1;
    end
    7'd103 : begin //jalr
        MemRead = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUsrc = 1'b1;
        Branch = 1'b0;
        RegWrite = 1'b1;
    end
    7'd55 : begin //lui
        MemRead = 1'b0;
        MemtoReg = 1'bx;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        Branch = 1'b1;
        RegWrite = 1'b0;
    end
    7'd23 : begin //aiupc
        MemRead = 1'b0;
        MemtoReg = 1'bx;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        Branch = 1'b1;
        RegWrite = 1'b0;
    end
    7'd115 : begin //ecall, ebreak
        MemRead = 1'b0;
        MemtoReg = 1'bx;
        MemWrite = 1'b0;
        ALUsrc = 1'b0;
        Branch = 1'b1;
        RegWrite = 1'b0;
    end

     endcase
 end

endmodule
