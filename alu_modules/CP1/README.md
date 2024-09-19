# ECE550D Simple ALU CheckPoint 1
**Student Name:** Toshiko Li
**NetID:** jl1355

## Structure Hierarchy

**My hierarchical structure tree:**

- alu  (top entity)
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