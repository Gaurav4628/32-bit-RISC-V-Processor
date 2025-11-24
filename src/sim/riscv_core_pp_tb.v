`timescale 1ns / 1ps

module riscv_core_pp_tb;
    reg clk = 0, reset = 1;
        riscv_core_pipelined uut(clk,reset);
        always #5 clk = ~clk;
          initial
            begin
            $dumpfile("riscv_pp.vcd");
            $dumpvars(0, riscv_core_pp_tb);
               #3 reset = 0;
               #550;

               $display("\n---- Register values at end ----\n");
               $display("x1 = %d", uut.u_regfile.regs[1]);
               $display("x2 = %d", uut.u_regfile.regs[2]);
               $display("x3 = %d", uut.u_regfile.regs[3]);
               $display("x4 = %d", uut.u_regfile.regs[4]);
               $display("x5 = %d", uut.u_regfile.regs[5]);
               $display("x6 = %d", uut.u_regfile.regs[6]);               
               
               $display("Simulation finished");
               $finish;
            end
endmodule

