`timescale 1ns / 100ps


module riscv_core_pipelined(
    input clk, reset
    );
    //IF wires
    wire [31:0] pc_out_if, pc_next_if, instr_if;
    wire [31:0] pc_plus_4_if;
    
    //IF_ID
    wire [31:0] pc_id, instr_id;
    
    //ID wires
    wire [6:0] opcode_id;
    wire [4:0] rs1_id, rs2_id, rd_id;
    wire [2:0] funct3_id;
    wire [6:0] funct7_id;

    wire RegWrite_id, MemtoReg_id, MemRead_id, MemWrite_id, ALUSrc_id;
    wire [1:0] ALUOp_id;

    wire [31:0] imm_id;
    wire [31:0] reg_rs1_id, reg_rs2_id;
    
    //ID_EX
    wire RegWrite_ex, MemtoReg_ex, MemRead_ex, MemWrite_ex, ALUSrc_ex;
    wire [1:0] ALUOp_ex;
    wire [31:0] pc_ex, imm_ex, rs1_data_ex, rs2_data_ex;
    wire [4:0] rs1_ex, rs2_ex, rd_ex;
    wire [2:0] funct3_ex;
    wire [6:0] funct7_ex;
    
    //EX wires
    wire [3:0] alu_ctrl_ex;
    wire [31:0] alu_b_ex, alu_result_ex;
    wire zero_ex;
    wire [31:0] pc_branch_ex;
    
    //EX_MEM
    wire RegWrite_mem, MemtoReg_mem, MemRead_mem, MemWrite_mem;
    wire [31:0] alu_result_mem, rs2_data_mem;
    wire [4:0] rd_mem;
    
    //MEM wires
    wire [31:0] mem_read_data_mem;
     
     //MEM_WB
    wire RegWrite_wb, MemtoReg_wb;
    wire [31:0] alu_result_wb, mem_read_data_wb;
    wire [4:0] rd_wb;
    
    //WB wires
    wire [31:0] wb_data;
    
    //INSTANTIATIONS
    
    //IF: PC & IMEM
    pc u_pc(.clk(clk), .reset(reset), .pc_next(pc_next_if), .pc_out(pc_out_if));
    imem u_imem(.addr(pc_out_if), .instr(instr_if));
    
    //IF_ID
    if_id u_if_id(
        .clk(clk), .reset(reset),
        .pc_in(pc_out_if), .instr_in(instr_if),
        .pc_out(pc_id), .instr_out(instr_id)
    );
    
    //ID: DECODE, CONTROL, IMM_GEN & REGFILE
    //DECODE
    assign opcode_id = instr_id[6:0];
    assign rs1_id = instr_id[19:15];
    assign rs2_id = instr_id[24:20];
    assign rd_id  = instr_id[11:7];
    assign funct3_id = instr_id[14:12];
    assign funct7_id = instr_id[31:25];
    
    //IMM_GEN
    imm_gen u_imm_id(.instr(instr_id), .imm(imm_id));
    
    //CONTROL_SIGNAL
    control u_control_id(
        .opcode(opcode_id),
        .Branch(), // branching will happen after EXECUTION stage
        .MemRead(MemRead_id),
        .MemtoReg(MemtoReg_id),
        .ALUOp(ALUOp_id),
        .MemWrite(MemWrite_id),
        .ALUSrc(ALUSrc_id),
        .RegWrite(RegWrite_id)
    );
    
    //REGFILE
    regfile u_regfile(
        .clk(clk),
        .we(RegWrite_wb),    // WriteBack stage will tell when write enable active
        .rs1(rs1_id),
        .rs2(rs2_id),
        .rd(rd_wb),          // Writeback stage will tell the destination register
        .wd(wb_data),        // WriteBack stage will tell what data to write
        .rd1(reg_rs1_id),
        .rd2(reg_rs2_id)
    );
    
    //ID_EX
    id_ex u_id_ex(
        .clk(clk), .reset(reset),
        
        .RegWrite_in(RegWrite_id),
        .MemtoReg_in(MemtoReg_id),
        .MemRead_in(MemRead_id),
        .MemWrite_in(MemWrite_id),
        .ALUSrc_in(ALUSrc_id),
        .ALUOp_in(ALUOp_id),
        
        .pc_in(pc_id),
        .imm_in(imm_id),
        .rs1_data_in(reg_rs1_id),
        .rs2_data_in(reg_rs2_id),
        .rs1_in(rs1_id),
        .rs2_in(rs2_id),
        .rd_in(rd_id),
        .funct3_in(funct3_id),
        .funct7_in(funct7_id),
        
        .RegWrite(RegWrite_ex),
        .MemtoReg(MemtoReg_ex),
        .MemRead(MemRead_ex),
        .MemWrite(MemWrite_ex),
        .ALUSrc(ALUSrc_ex),
        .ALUOp(ALUOp_ex),
        .pc(pc_ex),
        .imm(imm_ex),
        .rs1_data(rs1_data_ex),
        .rs2_data(rs2_data_ex),
        .rs1(rs1_ex),
        .rs2(rs2_ex),
        .rd(rd_ex),
        .funct3(funct3_ex),
        .funct7(funct7_ex)
    );
    
    //EX: ALU_CTRL & ALU
    //ALU_CTRL
    alu_ctrl u_aluctrl_ex(
        .ALUOp(ALUOp_ex),
        .funct7(funct7_ex),
        .funct3(funct3_ex),
        .alu_ctrl(alu_ctrl_ex)
    );
    
    //mux for input b (i.e., REGISTER @ or IMMIDIATE)
    assign alu_b_ex = (ALUSrc_ex)? imm_ex : rs2_data_ex;
    
    //ALU
    alu u_alu_ex(
        .a(rs1_data_ex),
        .b(alu_b_ex),
        .alu_ctrl(alu_ctrl_ex),
        .result(alu_result_ex),
        .zero(zero_ex)
    );
    
    //Branch Calculation
    assign pc_branch_ex = pc_ex + imm_ex;
    
    //EX_MEM
    ex_mem u_ex_mem(
        .clk(clk), .reset(reset),
        
        .RegWrite_in(RegWrite_ex),
        .MemtoReg_in(MemtoReg_ex),
        .MemRead_in(MemRead_ex),
        .MemWrite_in(MemWrite_ex),
        
        .alu_result_in(alu_result_ex),
        .rs2_data_in(rs2_data_ex),
        .rd_in(rd_ex),
        
        .RegWrite(RegWrite_mem),
        .MemtoReg(MemtoReg_mem),
        .MemRead(MemRead_mem),
        .MemWrite(MemWrite_mem),
        .alu_result(alu_result_mem),
        .rs2_data(rs2_data_mem),
        .rd(rd_mem)
    );
    
    //MEM: DATA_MEM
    data_mem u_data_mem(
        .clk(clk),
        .MemRead(MemRead_mem),
        .MemWrite(MemWrite_mem),
        .addr(alu_result_mem),
        .write_data(rs2_data_mem),
        .read_data(mem_read_data_mem)
    );
    
    //MEM_WB
    mem_wb u_mem_wb(
        .clk(clk), .reset(reset),
        
        .RegWrite_in(RegWrite_mem),
        .MemtoReg_in(MemtoReg_mem),
        .alu_result_in(alu_result_mem),
        .rd_in(rd_mem),
        
        .mem_read_data_in(mem_read_data_mem),
        
        .RegWrite(RegWrite_wb),
        .MemtoReg(MemtoReg_wb),
        .alu_result(alu_result_wb),
        .rd(rd_wb),
        .mem_read_data(mem_read_data_wb)
    );
    
    //WB: MUX for choosing WRITE DATA (i.e., mem_read_data or alu_result)
    assign wb_data = (MemtoReg_wb)? mem_read_data_wb : alu_result_wb;
    
    // function of program counter (go ahead or braching)
    assign pc_plus_4_if = pc_out_if + 32'd4;
    reg branch_ff;
    reg [31:0] branch_pc;
    
    always@(*) begin
        if((ALUOp_ex == 2'b01)& zero_ex) begin
            branch_ff = 1;
            branch_pc = pc_out_if + imm_ex;
        end else begin
            branch_ff = 0;
            branch_pc = pc_plus_4_if; //just for safe side
        end
    end
    
    assign pc_next_if = (branch_ff)? branch_pc : pc_plus_4_if;
   
endmodule
