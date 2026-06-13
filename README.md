# **Pipelined CPU (Verilog Implementation)**

This project implements a **5-stage pipelined CPU in Verilog**, designed based on the principles described in *Patterson and Hennessy: Computer Organization and Design*. The processor follows a classic RISC-style pipeline architecture and executes instructions loaded from a **.hex program memory file**.

---

## **Architecture Overview**

The CPU is structured into the standard 5 pipeline stages:

### **Instruction Fetch (IF)**
- Fetches instructions from instruction memory using the program counter.

### **Instruction Decode (ID)**
- Decodes instructions.
- Reads operands from the register file.
- Generates control signals.

### **Execute (EX)**
- Performs arithmetic and logical operations using the ALU.
- Computes branch target addresses.
- Handles forwarding logic inputs.

### **Memory Access (MEM)**
- Performs data memory read and write operations.

### **Write Back (WB)**
- Writes computed results back into the register file.

Pipeline registers are used between all stages:
- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

---

## **Key Features**

- 5-stage pipelined CPU design
- Hazard detection unit for managing data dependencies and inserting stalls
- Forwarding unit to reduce pipeline stalls
- ALU supporting arithmetic, logical, and branch operations
- Separate control unit and ALU control unit for modular design
- Branch handling with program counter update logic
- Instruction memory initialized using a `.hex` file
- Modular implementation using reusable components (MUX, registers, pipeline registers, ALU, memory)

---

## **Design Reference**

The architecture is based on the pipeline CPU design methodology from:

- *Patterson and Hennessy – Computer Organization and Design*

The design follows a modular hardware construction approach where each stage is independently implemented and connected via pipeline registers.

---

## **Input Program Format**

- The CPU executes instructions loaded from a `.hex` file.
- This file initializes the instruction memory.
- Allows simulation of program execution without modifying the hardware design.

---

## **Current Status**

- Functional simulation-level implementation completed.
- Pipeline datapath, hazard detection, and forwarding logic are implemented.
- Formal verification and compliance testing have not yet been performed.

---

## **Future Improvements**

- Formal verification against ISA specification
- Expanded instruction set support
- Improved hazard handling and reduced stall cycles
- Cache memory integration
- FPGA synthesis and hardware validation
