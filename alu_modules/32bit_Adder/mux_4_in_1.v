module mux_4_in_1(in0, in1, s, out);
	input [3:0] in0, in1;
	input s;
	output [3:0] out;
	
	mux_2_in_1 mux1(
		.in0(in0[0]),
		.in1(in1[0]),
		.s(s),
		.out(out[0])
	);
	
	mux_2_in_1 mux2(
		.in0(in0[1]),
		.in1(in1[1]),
		.s(s),
		.out(out[1])
	);
	
	mux_2_in_1 mux3(
		.in0(in0[2]),
		.in1(in1[2]),
		.s(s),
		.out(out[2])
	);
	
	mux_2_in_1 mux4(
		.in0(in0[3]),
		.in1(in1[3]),
		.s(s),
		.out(out[3])
	);
	
endmodule