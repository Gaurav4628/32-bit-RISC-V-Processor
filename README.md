🚀 RISC-V RV32I Processor
A 5-Stage Pipelined Verilog Implementation (with Optional Forwarding + Hazard Detection)

This repository contains a clean and modular implementation of a fully functional RISC-V RV32I processor, written in Verilog and verified through simulation.
It includes both single-cycle and 5-stage pipelined architectures, with optional data forwarding and hazard detection logic.

This project is designed for learning, research, and showcasing capability in Digital Design, Computer Architecture, and RTL Development.

✨ Features
✔ Full RV32I ISA Support

Arithmetic & Logical Instructions

Shift Instructions

Immediate Instructions

Branch Instructions

Load/Store (LW, SW)

Jumps (JAL, JALR)

✔ Two CPU Versions Included

Single-Cycle Core – simple and easy to understand

Pipelined Core – classic 5-stage pipeline

IF → ID → EX → MEM → WB

✔ Pipeline Enhancements [UNDER DEVELOPMENT, the current version doesn't include HAZARDS Protection]

Forwarding Unit – resolves ALU hazards

Hazard Detection Unit – insert stalls for load-use hazards

NOP-safe Programs Provided

✔ Fully Modular Design

Each hardware block is implemented as an independent module:

ALU + ALU Control

Register File

Immediate Generator

Control Unit

Instruction Memory & Data Memory

PC Unit with Enable

IF/ID, ID/EX, EX/MEM, MEM/WB Pipeline Registers

✔ Simulation Ready

Includes:

Testbench

Hazard-free programs

program.mem loading

Waveform (Vivado GTKWave) guidelines

🏗️ Architecture Overview
5-Stage Pipeline
IF  →  ID  →  EX  →  MEM  →  WB


Each stage has a dedicated pipeline register:

if_id.v

id_ex.v

ex_mem.v

mem_wb.v

Data hazards are resolved via:

Forwarding paths (EX/MEM → EX, MEM/WB → EX)

Load-use hazard detection (stall & bubble)

📁 Repository Structure
riscv-rv32i-processor/
│
├── src/
│   ├── core/
│   │    ├── riscv_core_single_cycle.v
│   │    ├── riscv_core_pipeline.v
│   │    ├── forwarding_unit.v
│   │    ├── hazard_unit.v
│   │    ├── if_id.v
│   │    ├── id_ex.v
│   │    ├── ex_mem.v
│   │    ├── mem_wb.v
│   │    └── pc_en.v
│   │
│   ├── alu/
│   │    ├── alu.v
│   │    ├── alu_control.v
│   │
│   ├── control/
│   │    ├── control.v
│   │    └── imm_gen.v
│   │
│   ├── memory/
│   │    ├── imem.v
│   │    ├── data_mem.v
│   │
│   ├── register_file/
│   │    └── regfile.v
│   │
│   └── utils/
│        └── muxes.v
│
├── sim/
│   ├── riscv_tb.v
│   ├── program.mem
│   └── test_vectors/
│
├── docs/
│   ├── pipeline-diagram.png
│   ├── block-diagram.png
│   └── architecture-notes.md
│
├── LICENSE
└── README.md

▶️ Running the Simulation
Using Icarus Verilog
cd sim/
iverilog -o cpu.out riscv_tb.v ../src/**/**/*.v
vvp cpu.out

Using Vivado

Create a new simulation project

Add all Verilog files from src/ and sim/

Set riscv_tb.v as the top

Ensure program.mem is in the same directory as imem.v

Run Behavioral Simulation

Add these signals to the waveform:

pc

instr

rd, rs1, rs2

alu_result

RegWrite

write_back_data

Register file values

Pipeline register signals

🧪 Example Program (Hazard-Free)

Included in sim/program.mem is a hazard-safe program that performs:

Arithmetic operations

Summation

Conditional comparisons

Basic math routines

This allows testing the pipeline without forwarding or hazard detection.

📘 Future Improvements

Branch Prediction (Static / 1-bit / 2-bit)

Instruction & Data Cache

Exception and CSR support

RV32IM (Multiply/Divide) extension

Debug Interface (JTAG/UART)

FPGA Deployment on Basys-3 / Nexys-A7

🧑‍💻 Author

Gaurav Kumar Gupta
B.Tech (Electrical Engineering), IIT BHU
Passionate about Digital Design, Embedded Systems, Analog + Mixed Signal, and Computer Architecture.

📄 License

This project is licensed under the MIT License — free to use, modify, and distribute.
