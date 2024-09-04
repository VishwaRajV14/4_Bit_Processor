# 4-Bit Processor Project

## Overview

This project implements a simple 4-bit processor designed for educational purposes. It includes a Verilog implementation of the processor, a SystemVerilog testbench for verification, and an assembler written in both Python and C to convert assembly code into machine code for the processor.

## Components

1. **Processor Design** (`simple_4bit_processor.v`)
   - 4-bit architecture
   - 3 basic operations: LOAD, ADD, SUB
   - 4 general-purpose registers
   - 32 instruction memory slots

2. **Testbench** (`testbench.sv`)
   - SystemVerilog testbench for processor verification
   - Simulates multiple sets of operations

3. **Assembler**
   - Python version (`assembler.py`)
   - C version (`assembler.c`)
   - Converts assembly code to machine code for the processor

## Instruction Set Architecture (ISA)

The processor supports three instructions:

1. `LOAD Rx,imm` - Load immediate 4-bit value into register Rx
2. `ADD Rx,Ry,Rz` - Add contents of registers Ry and Rz, store result in Rx
3. `SUB Rx,Ry,Rz` - Subtract contents of register Rz from Ry, store result in Rx

Instruction Format:
- LOAD: `[00][2-bit dest reg][4-bit immediate]`
- ADD:  `[01][2-bit dest reg][2-bit source reg 1][2-bit source reg 2]`
- SUB:  `[10][2-bit dest reg][2-bit source reg 1][2-bit source reg 2]`

## Setup and Usage

### Processor Simulation

1. Ensure you have a Verilog simulator installed (e.g., Icarus Verilog).
2. Compile the processor and testbench: