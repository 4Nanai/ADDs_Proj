module mux_16_in_1(in0, in1, s, out);
	input [15:0] in0, in1;
	input s;
	output [15:0] out;
	
	mux_8_in_1 mux1(
		.in0(in0[7:0]),
		.in1(in1[7:0]),
		.s(s),
		.out(out[7:0])
	);
	
	mux_8_in_1 mux2(
		.in0(in0[15:8]),
		.in1(in1[15:8]),
		.s(s),
		.out(out[15:8])
	);
	
endmodule