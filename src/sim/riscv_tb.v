`timescale 1ns / 1ns

module riscv_tb;
        reg clk = 0, reset = 1;
        riscv_core uut(clk,reset);
        always #5 clk = ~clk;
          initial
            begin
            $dumpfile("riscv.vcd");
            $dumpvars(0, riscv_tb);
               #3 reset = 0;
               #95;

               $display("\n---- Register values at end ----\n");
               $display("x1 = %d", uut.u_regfile.regs[1]);
               $display("x2 = %d", uut.u_regfile.regs[2]);
               $display("x3 = %d", uut.u_regfile.regs[3]);
               $display("x4 = %d", uut.u_regfile.regs[4]);
               $display("x5 = %d", uut.u_regfile.regs[5]);
               $display("Simulation finished");
               $finish;
            end
endmodule

