module control(
                input [6:0]opcode,
                output reg Branch, MemRead, MemtoReg,
                output reg[1:0] ALUOp,
                output reg RegWrite, ALUSrc, MemWrite);
             
         always@(*)
         begin
            case(opcode)
                7'b0110011: begin // R-type
                RegWrite=1; ALUSrc=0; MemtoReg=0;
                MemRead=0; MemWrite=0; Branch=0; ALUOp=2'b10;
            end
               7'b0010011: begin // I-type ALU 
               RegWrite=1; ALUSrc=1; MemtoReg=0;
               MemRead=0; MemWrite=0; Branch=0;ALUOp=2'b00;
            end
                7'b0000011: begin // LW
                RegWrite=1; ALUSrc=1; MemtoReg=1;
                MemRead=1; MemWrite=0; Branch=0; ALUOp=2'b00;
            end
                7'b0100011: begin // SW
                RegWrite=0; ALUSrc=1; MemtoReg=0;
                MemRead=0; MemWrite=1; Branch=0; ALUOp=2'b00;
            end
                7'b1100011: begin // BEQ
                RegWrite=0; ALUSrc=0; MemtoReg=0;
                MemRead=0; MemWrite=0; Branch=1; ALUOp=2'b01;
            end
                default: begin
                RegWrite=0; ALUSrc=0; MemtoReg=0;
                MemRead=0; MemWrite=0; Branch=0; ALUOp=2'b00;
            end
            endcase
         end

endmodule
