# RISC-V Pipelined CPU

A 5-stage pipelined RISC-V (RV32I subset) CPU implemented in Verilog, featuring full data forwarding, hazard detection, and branch handling.

## Architecture

The CPU implements the classic 5-stage pipeline:

| Stage | Description |
|-------|-------------|
| IF | Fetches instructions from memory using the program counter |
| ID | Decodes instructions, reads register file, generates control signals |
| EX | Executes ALU operations, computes branch targets, applies forwarding |
| MEM | Performs data memory reads and writes |
| WB | Writes results back to the register file |

Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) separate each stage and carry control/data signals forward.

## Key Features

- **Full data forwarding** — EX/MEM and MEM/WB forwarding paths eliminate data hazard stalls for back-to-back dependent instructions
- **Hazard detection** — Load-use hazards detected and resolved via pipeline stalling
- **Branch handling** — Branch outcomes resolved in EX stage with 1-cycle flush penalty on taken branches; supports `beq` and `bne`
- **Modular design** — Each component (ALU, control unit, forwarding unit, hazard detector, pipeline registers, MUX) independently implemented and reusable
- **Hex-file program loading** — Instruction memory initialized via `.hex` file, allowing programs to be swapped without modifying hardware

## Supported Instructions

| Type | Instructions |
|------|-------------|
| Arithmetic | `add`, `sub`, `addi` |
| Logical | `and`, `or`, `xor`, `andi`, `ori`, `xori` |
| Shift | `sll`, `srl`, `sra` |
| Compare | `slt`, `sltu`, `slti`, `sltiu` |
| Memory | `lw`, `sw` |
| Branch | `beq`, `bne` |

## Performance

Benchmarked on two programs to characterize pipeline efficiency:

| Benchmark | Total Cycles | Instructions Retired | CPI |
|-----------|-------------|---------------------|-----|
| Fibonacci(8) | 61 | 35 | 1.74 |
| Array Element-Sum | 87 | 54 | 1.61 |

CPI overhead is attributable to:
- **Branch penalties** — 1 wasted cycle per taken branch (flush of wrong-path instruction)
- **Load-use stalls** — 1 stall cycle when a load result is consumed by the immediately following instruction

Data hazards between non-load instructions contribute **0 stall cycles** due to full forwarding.

## Design Reference

Architecture based on the pipelined CPU design from:
> Patterson & Hennessy — *Computer Organization and Design: RISC-V Edition*



## Future Work

- Expand branch support (`blt`, `bge`, `bltu`, `bgeu`)
- Add `jal`/`jalr` for full RV32I compliance
- Store-to-load forwarding to eliminate memory hazard stalls
- Formal verification against RISC-V ISA compliance tests
- FPGA synthesis and hardware validation
- Cache integration
