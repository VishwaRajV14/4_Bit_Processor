`timescale 1ns / 1ps

module simple_4bit_processor(
    input wire clk,
    input wire reset,
    output wire [3:0] result0,
    output wire [3:0] result1,
    output wire [3:0] result2,
    output wire [3:0] result3,
    output wire [3:0] pc_out
);

    // Registers
    reg [3:0] registers [0:3];
    reg [3:0] pc;
    reg [7:0] instruction;

    // Instruction memory
    reg [7:0] instr_mem [0:31];  // 32 instructions

    // Instruction fields
    wire [1:0] opcode = instruction[7:6];
    wire [1:0] rd = instruction[5:4];
    wire [1:0] rs1 = instruction[3:2];
    wire [1:0] rs2 = instruction[1:0];

    // Processor logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            registers[3] <= 0;
        end else begin
            // Fetch
            instruction <= instr_mem[pc];
            
            // Decode and Execute
            case (opcode)
                2'b00: begin  // LOAD
                    registers[rd] <= instruction[3:0];
                end
                2'b01: begin  // ADD
                    registers[rd] <= registers[rs1] + registers[rs2];
                end
                2'b10: begin  // SUB
                    registers[rd] <= registers[rs1] - registers[rs2];
                end
                2'b11: begin  // NOP
                    // Do nothing
                end
            endcase

            // Increment PC
            pc <= pc + 1;
        end
    end

    // Output register values
    assign result0 = registers[0];
    assign result1 = registers[1];
    assign result2 = registers[2];
    assign result3 = registers[3];
    assign pc_out = pc;

endmodule