module mem_wb(
    input clk, reset,
    input RegWrite_in, MemtoReg_in,
    input [31:0] alu_result_in, mem_read_data_in,
    input [4:0] rd_in,
    output reg RegWrite, MemtoReg,
    output reg [31:0] alu_result, mem_read_data,
    output reg [4:0] rd
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        RegWrite <= 0; MemtoReg <= 0;
        alu_result <= 0; mem_read_data <= 0;
        rd <= 0;
    end else begin
        RegWrite <= RegWrite_in; MemtoReg <= MemtoReg_in;
        alu_result <= alu_result_in; mem_read_data <= mem_read_data_in;
        rd <= rd_in;
    end
end
endmodule
