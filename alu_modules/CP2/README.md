# ECE550D Full ALU CheckPoint 2

**Student Name:** Toshiko Li

**NetID:** jl1355



## CP2 Structure Hierarchy

The **alu** module is composed of several submodules that work together to execute a range of arithmetic and logical operations. Based on the input **ctrl_ALUopcode[2:0]**, the **dataResultSelect** module is responsible for choosing the appropriate operation result for output.

#### 1. dataResultSelect (Main Operation Selector)

- This module is responsible for selecting the final result from multiple submodules performing different operations.

- It contains **32 instances of mux_8_in_3**, one for each bit of the 32-bit result.

- Each **mux_8_in_3** selects one bit of the final result based on the control signal **ctrl_ALUopcode[2:0]**.

| Operation              | Opcode[2:0] | Function                       |
| ---------------------- | ----------- | ------------------------------ |
| ADD                    | 000         | data_operandA + data_operandB  |
| SUB                    | 001         | data_operandA - data_operandB  |
| AND (bitwise)          | 010         | data_operandA & data_operandB  |
| OR (bitwise)           | 011         | data_operandA \| data_operandB |
| Shift Left Logical      | 100         | data_operandA << ctrl_shiftamt |
| Shift Right Arithmetic  | 101         | data_operandA >>> ctrl_shiftamt |

#### 2. SLL_32bit (Shift Left Logical)

- This module performs a 32-bit logical left shift operation.
- It is constructed using a **cascade of mux_2_in_1** instances, which allow for flexible shifting based on the **ctrl_shiftamt** value.
- The shifting logic shifts bits to the left, filling the rightmost bits with zero.



#### 3. SRA_32bit (Shift Right Arithmetic)

- This module performs a 32-bit arithmetic right shift operation.
- It is built using multiple **mux_2_in_1** instances to shift bits right by the number of positions indicated by **ctrl_shiftamt**.
- The **arithmetic** nature of the shift is preserved by filling the leftmost bits with the value of the most significant bit (MSB), which maintains the sign of the original value (i.e., sign extension).
- The extension logic checks the MSB of **data_operandA** and fills the shifted positions accordingly to maintain the correct sign in the output.



#### 4. or_32bit (Bitwise OR)

- Implements the bitwise OR operation across two 32-bit operands.
- Contains **32 OR gates**, where each gate computes the OR operation on corresponding bits from **data_operandA** and **data_operandB**.



#### 5. and_32bit (Bitwise AND)

- Implements the bitwise AND operation across two 32-bit operands.
- Contains **32 AND gates**, each computing the AND of corresponding bits from **data_operandA** and **data_operandB**.



#### 6. isLessThan_i (Comparison: Less Than)

- This module compares **data_operandA** and **data_operandB** to determine if **A < B**.
- The comparison is carried out by performing a subtraction and examining the result:
- If the most significant bit (MSB) of the result is ‘1’ and no overflow occurs, **A** is less than **B**.
- Uses an **XOR gate** to analyze the sign bit, considering overflow to avoid incorrect results.



#### 7. isNotEqual_i (Comparison: Not Equal)

- This module determines if **data_operandA** is not equal to **data_operandB** by subtracting one from the other.
- A **cascade of OR gates** checks whether any bit in the subtraction result is non-zero. If any bit is ‘1’, the numbers are not equal.