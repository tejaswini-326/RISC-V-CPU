Pipelined CPU (Verilog Implementation)

This project implements a 5-stage pipelined CPU in Verilog, designed based on the principles described in Patterson and Hennessy’s Computer Organization and Design. The processor follows a classic RISC-style pipeline architecture and executes instructions loaded from a hexadecimal program memory file.

Architecture Overview

The CPU is structured into the standard five pipeline stages:

Instruction Fetch (IF): Fetches instructions from instruction memory using the program counter.
Instruction Decode (ID): Decodes instructions, reads from the register file, and generates control signals.
Execute (EX): Performs arithmetic and logical operations using the ALU and computes branch targets.
Memory Access (MEM): Handles data memory read and write operations.
Write Back (WB): Writes results back to the register file.

Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) are used to separate each stage and maintain instruction flow through the pipeline.

Key Features
5-stage pipelined processor design
Hazard detection unit to manage data hazards and introduce stalls when required
Forwarding unit to reduce performance penalties due to data dependencies
ALU supporting arithmetic, logical, and branch-related operations
Separate control unit and ALU control unit for modular design
Branch handling with PC update logic
Instruction memory initialized using a .hex file for program execution
Modular design using reusable components such as multiplexers, registers, and pipeline registers
Design Reference

The architecture is based on the pipeline CPU design methodology presented in Patterson and Hennessy’s Computer Organization and Design. The implementation follows a modular and hierarchical hardware design approach.

Input Program Format

The processor executes instructions loaded from a .hex file, which initializes the instruction memory. This allows simulation of program execution without modifying the hardware description.

Current Status

The design is functionally complete at the simulation level. However, it has not yet undergone formal compliance testing or exhaustive verification across all edge cases. Advanced validation and hardware deployment are planned for future development.

Future Improvements
Formal verification and compliance testing against a defined ISA specification
Enhanced hazard handling and pipeline optimization
Support for additional instructions and extended ISA features
Integration of cache memory hierarchy
FPGA implementation and hardware validation
