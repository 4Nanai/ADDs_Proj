module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	wire mux_cin;
	wire [31:0] not_data_operandB, mux_data_operandB;
	wire [31:0] alu_SLL_out, //
					alu_SRA_out, //
					add_sub_out, //
					alu_and_out, //
					alu_or_out;  //
					
   // YOUR CODE HERE //
	
	/* Select data_result */
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: alu_mux_gen
			mux_8_in_3 alu_mux(
				.in0(add_sub_out[i]),
				.in1(add_sub_out[i]),
				.in2(alu_and_out[i]),
				.in3(alu_or_out[i]),
				.in4(alu_SLL_out[i]),
				.in5(alu_SRA_out[i]),
				.in6(1'b0),
				.in7(1'b0),
				.s(ctrl_ALUopcode[2:0]),
				.out(data_result[i])
			);
		end
	endgenerate
	
	
	/* Bit wise add */
	
	and_32bit alu_and(
		.in0(data_operandA),
		.in1(data_operandB),
		.out(alu_and_out)
	);
	
	/* Bit wise or */
	
	or_32bit alu_or(
		.in0(data_operandA),
		.in1(data_operandB),
		.out(alu_or_out)
	);
	
	/* Shift Left Logical */
	
	SLL_32bit alu_SLL(
		.in(data_operandA), 
		.s(ctrl_shiftamt), 
		.out(alu_SLL_out)
		);
		
	/* Shift Right Arithmetic */
	
	SRA_32bit alu_SRA(
		.in(data_operandA), 
		.s(ctrl_shiftamt), 
		.out(alu_SRA_out)
		);

	/* Adder and Suber */
	mux_2_in_1 opMux_Cin(
	.in0(1'b0), 
	.in1(1'b1), 
	.s(ctrl_ALUopcode[0]), 
	.out(mux_cin)
	);
	
	not_32bit dataB_not(
	.in(data_operandB), 
	.out(not_data_operandB)
	);
	
	mux_32_in_1 dataB_Mux_1(
	.in0(data_operandB), 
	.in1(not_data_operandB), 
	.s(ctrl_ALUopcode[0]), 
	.out(mux_data_operandB)
	);
	
	adder_32bit add_sub(
	.a(data_operandA), 
	.b(mux_data_operandB), 
	.c_in(mux_cin), 
	.sum(add_sub_out),  
	.OF(overflow)
	);
	
endmodule
