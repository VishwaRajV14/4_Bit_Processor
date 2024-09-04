`timescale 1ns / 1ps

module testbench;
    logic clk;
    logic reset;
    logic [3:0] result0, result1, result2, result3;
    logic [3:0] pc_out;

    // Instantiate the processor
    simple_4bit_processor dut (
        .clk(clk),
        .reset(reset),
        .result0(result0),
        .result1(result1),
        .result2(result2),
        .result3(result3),
        .pc_out(pc_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize
        clk = 0;
        reset = 1;

        // Initialize all memory locations
        for (int i = 0; i < 32; i++) begin
            dut.instr_mem[i] = 8'b11_00_0000;  // NOP instruction
        end

        // Load instructions (simulating machine code from assembler)
        // First set of operations
        dut.instr_mem[0] = 8'b00_00_0101; // LOAD R0,5
        dut.instr_mem[1] = 8'b00_01_0011; // LOAD R1,3
        dut.instr_mem[2] = 8'b01_10_0001; // ADD R2,R0,R1
        dut.instr_mem[3] = 8'b10_11_1001; // SUB R3,R2,R1

        // Second set of operations
        dut.instr_mem[4] = 8'b00_00_0110; // LOAD R0,6
        dut.instr_mem[5] = 8'b00_01_0010; // LOAD R1,2
        dut.instr_mem[6] = 8'b01_10_0001; // ADD R2,R0,R1
        dut.instr_mem[7] = 8'b10_11_1001; // SUB R3,R2,R1

        // Third set of operations
        dut.instr_mem[8] = 8'b00_00_0100; // LOAD R0,4
        dut.instr_mem[9] = 8'b00_01_0001; // LOAD R1,1
        dut.instr_mem[10] = 8'b01_10_0001; // ADD R2,R0,R1
        dut.instr_mem[11] = 8'b10_11_1001; // SUB R3,R2,R1

        // Release reset
        #10 reset = 0;

        // Wait for first set of operations to complete
        repeat(6) @(posedge clk);
        $display("After first set of operations:");
        $display("R0: %d, R1: %d, R2: %d, R3: %d", result0, result1, result2, result3);

        // Wait for second set of operations to complete
        repeat(4) @(posedge clk);
        $display("After second set of operations:");
        $display("R0: %d, R1: %d, R2: %d, R3: %d", result0, result1, result2, result3);

        // Wait for third set of operations to complete
        repeat(4) @(posedge clk);
        $display("After third set of operations:");
        $display("R0: %d, R1: %d, R2: %d, R3: %d", result0, result1, result2, result3);

        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("Time=%0t, PC=%d, Instruction=%b, R0=%d, R1=%d, R2=%d, R3=%d", 
                 $time, pc_out, dut.instruction, 
                 dut.registers[0], dut.registers[1], dut.registers[2], dut.registers[3]);
    end

endmodule