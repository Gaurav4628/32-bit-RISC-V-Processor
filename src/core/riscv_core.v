`timescale 1ns / 100ps

module riscv_core(
    input clk, reset
    );
    //fetch wires
    wire [31:0] pc_out, pc_next, instr;
    //Decode wires
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[32:25];
    //control wires
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire[1:0] ALUOp;
    //Imm, ALU,DATA_mem wires
    wire [31:0] imm;
    wire [31:0] reg_rs1, reg_rs2, alu_b, alu_result, mem_read_data, write_back_data;
    wire [3:0] alu_ctrl;
    wire zero;
    pc u_pc(.clk(clk), .reset(reset), .pc_out(pc_out), .pc_next(pc_next));
    imem u_imem(.addr(pc_out), .instr(instr));
    control u_control(.opcode(opcode),
                      .Branch(Branch),
                      .MemRead(MemRead),
                      .MemtoReg(MemtoReg),
                      .ALUOp(ALUOp),
                      .MemWrite(MemWrite),
                      .ALUSrc(ALUSrc),
                      .RegWrite(RegWrite));
    imm_gen u_imm(.instr(instr), .imm(imm));
    regfile u_regfile(.clk(clk), .we(RegWrite), .rs1(rs1), .rs2(rs2), .rd(rd),
                      .wd(write_back_data), .rd1(reg_rs1), .rd2(reg_rs2));
    alu_ctrl u_aluctrl(.ALUOp(ALUOp), .funct7(funct7), .funct3(funct3), .alu_ctrl(alu_ctrl));
    
    assign alu_b = (ALUSrc) ? imm : reg_rs2; //ALU source mux
    
    alu u_alu(.a(reg_rs1), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(zero));   //EX
    data_mem u_dmem(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(alu_result),
                    .write_data(reg_rs2), .read_data(mem_read_data));            // MEM
    //WB
    assign write_back_data = (MemtoReg) ? mem_read_data : alu_result;
    
    //Branching
    wire [31:0] pc_plus = pc_out + 32'd4;
    wire [31:0] pc_branch = pc_out + imm;
    assign pc_next = (Branch & zero) ? pc_branch : pc_plus; 
endmodule

