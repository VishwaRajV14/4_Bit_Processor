#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_INSTRUCTIONS 32
#define MAX_LINE_LENGTH 50

// Function to convert register number to binary string
void reg_to_binary(int reg, char *binary) {
    sprintf(binary, "%02d", reg);
    for (int i = 0; i < 2; i++) {
        binary[i] = (binary[i] == '1') ? '1' : '0';
    }
}

// Function to convert immediate value to binary string
void imm_to_binary(int imm, char *binary) {
    sprintf(binary, "%04d", imm);
    for (int i = 0; i < 4; i++) {
        binary[i] = (binary[i] == '1') ? '1' : '0';
    }
}

// Function to assemble a single instruction
void assemble_instruction(char *line, char *machine_code) {
    char opcode[5], operands[3][5];
    int num_operands = sscanf(line, "%s %[^,],%[^,],%s", opcode, operands[0], operands[1], operands[2]);

    for (int i = 0; opcode[i]; i++) opcode[i] = toupper(opcode[i]);

    if (strcmp(opcode, "LOAD") == 0) {
        strcpy(machine_code, "00");
        char rd_bin[3], imm_bin[5];
        reg_to_binary(atoi(operands[0] + 1), rd_bin);
        imm_to_binary(atoi(operands[1]), imm_bin);
        strcat(machine_code, rd_bin);
        strcat(machine_code, imm_bin);
    } else if (strcmp(opcode, "ADD") == 0 || strcmp(opcode, "SUB") == 0) {
        strcpy(machine_code, (strcmp(opcode, "ADD") == 0) ? "01" : "10");
        char rd_bin[3], rs1_bin[3], rs2_bin[3];
        reg_to_binary(atoi(operands[0] + 1), rd_bin);
        reg_to_binary(atoi(operands[1] + 1), rs1_bin);
        reg_to_binary(atoi(operands[2] + 1), rs2_bin);
        strcat(machine_code, rd_bin);
        strcat(machine_code, rs1_bin);
        strcat(machine_code, rs2_bin);
    } else {
        printf("Unknown opcode: %s\n", opcode);
        exit(1);
    }
}

int main() {
    char assembly_code[MAX_INSTRUCTIONS][MAX_LINE_LENGTH];
    char machine_code[MAX_INSTRUCTIONS][9];  // 8 bits + null terminator
    int instruction_count = 0;

    printf("4-bit Processor Assembler\n");
    printf("Supported instructions: LOAD, ADD, SUB\n");
    printf("Enter your assembly code (empty line to finish):\n");

    while (1) {
        if (fgets(assembly_code[instruction_count], MAX_LINE_LENGTH, stdin) == NULL) {
            break;
        }
        assembly_code[instruction_count][strcspn(assembly_code[instruction_count], "\n")] = 0;  // Remove newline
        if (strlen(assembly_code[instruction_count]) == 0) {
            break;
        }
        instruction_count++;
        if (instruction_count >= MAX_INSTRUCTIONS) {
            printf("Maximum number of instructions reached.\n");
            break;
        }
    }

    printf("\nGenerated Machine Code:\n");
    for (int i = 0; i < instruction_count; i++) {
        assemble_instruction(assembly_code[i], machine_code[i]);
        printf("instr_mem[%d] = 8'b%s;\n", i, machine_code[i]);
    }

    return 0;
}