module mux_32_in_1(
	input [31:0] in0, in1,
	input s,
	output [31:0] out
);

	mux_16_in_1 mux1(
		.in0(in0[15:0]),
		.in1(in1[15:0]),
		.s(s),
		.out(out[15:0])
	);
	
	mux_16_in_1 mux2(
		.in0(in0[31:16]),
		.in1(in1[31:16]),
		.s(s),
		.out(out[31:16])
	);
endmodule
