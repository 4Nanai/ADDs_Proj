# ECE550D Full ALU CheckPoint 2
**Student Name:** Toshiko Li
**NetID:** jl1355

## Structure Hierarchy

**My hierarchical structure tree:**

- alu  (top entity)
  
  - **dataResultSelect:** 32 instantiated **mux_8_in_3**, according to opcode to select output, each mux select 1 bit of result
  
    | Operation              | Opcode[2:0] | Function                       |
    | ---------------------- | ----------- | ------------------------------ |
    | ADD                    | 000         | data_operandA + data_operandB  |
    | SUB                    | 001         | data_operandA - data_operandB  |
    | AND(bitwise)           | 010         | data_operandA & data_operandB  |
    | OR(bitwise)            | 011         | data_operandA \| data_operandB |
    | Shift Left Logical     | 100         | data_operandA << ctrl_shiftamt |
    | Shift Right Arithmetic | 101         | Data_oprandA >>> ctrl_shiftamt |
  
  - **SLL_32bit**: Implement of logical left shift
  
    - Cascade **mux_2_in_1**
  
  - **SRA_32bit**: Implement of arithmetic right shift
  
    - Cascade **mux_2_in_1**
  
  - **or_32bit**: Implement of bitwise OR
  
    - 32 "**OR** gate" instances connecting each bit of A and B
  
  - **and_32bit**: Implement  of bitwise AND
  
    - 32 "**AND** gate" instances connecting each bit of A and B
  
  - **isLessThan_i**: Return boolean value *True* if A is less than B when doing subtraction 
  
    - "**XOR** gate" connecting Most Significant Bit and overflow.
  
  - **isNotEqual_i**: Return boolean value *True* if A is equal to B when doing subtraction
  
    - Cascade "**OR** gate" checking whether the 32-bit result contains '1' or not
  
  ***
  
  Structures below are for CheckPoint 1
  
  - adder_32bit (use for add and sub)
    - adder_16bit (3 16-bit adders for acceleration)
      - adder_8_bit (3 8-bit adders for acceleration)
        - adder_4_bit (2 4-bit adder)
          - full_adder (4 full adders)
      - mux_8_in_1 (use to transmit carry out)
    - mux_16_in_1 (use to transmit carry out)
  - not_32bit (use to calculate complement)
  - mux_32_in_1 (use to choose dataB or not_dataB)
    - mux_16_in_1 (2 16-bit inputs to 1 16-bit output) *2
      - mux_8_in_1 *2
        - mux_4_in_1 *2
          - mux_2_in_1 *4
  - mux_2_in_1 (use to choose carry in as 1'b0 or 1'b1)