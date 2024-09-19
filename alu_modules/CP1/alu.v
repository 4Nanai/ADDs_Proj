module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	wire mux_cin;
	wire [31:0] not_data_operandB, mux_data_operandB;
   // YOUR CODE HERE //

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
	.sum(data_result),  
	.OF(overflow)
	);
	
endmodule
