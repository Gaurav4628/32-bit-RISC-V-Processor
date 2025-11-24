module id_ex(
    input clk, reset,
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in, ALUSrc_in,
    input [1:0] ALUOp_in,
    input [31:0] pc_in, imm_in, rs1_data_in, rs2_data_in,
    input [4:0] rs1_in, rs2_in, rd_in,
    input [2:0] funct3_in,
    input [6:0] funct7_in,

    output reg RegWrite, MemtoReg, MemRead, MemWrite, ALUSrc,
    output reg [1:0] ALUOp,
    output reg [31:0] pc, imm, rs1_data, rs2_data,
    output reg [4:0] rs1, rs2, rd,
    output reg [2:0] funct3,
    output reg [6:0] funct7
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        RegWrite <= 0;
        MemtoReg <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        ALUSrc <= 0;
        ALUOp <= 0;
        pc <= 0;
        imm <= 0;
        rs1_data <= 0;
        rs2_data <= 0;
        rs1 <= 0; rs2 <= 0; rd <= 0;
        funct3 <= 0; funct7 <= 0;
    end else begin
        RegWrite <= RegWrite_in;
        MemtoReg <= MemtoReg_in;
        MemRead <= MemRead_in;
        MemWrite <= MemWrite_in;
        ALUSrc <= ALUSrc_in;
        ALUOp <= ALUOp_in;
        pc <= pc_in;
        imm <= imm_in;
        rs1_data <= rs1_data_in;
        rs2_data <= rs2_data_in;
        rs1 <= rs1_in; rs2 <= rs2_in; rd <= rd_in;
        funct3 <= funct3_in; funct7 <= funct7_in;
    end
end
endmodule
