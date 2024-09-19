module mux_8_in_1(in0, in1, s, out);
	input [7:0] in0, in1;
	input s;
	output [7:0] out;
	
	mux_4_in_1 mux1(
		.in0(in0[3:0]),
		.in1(in1[3:0]),
		.s(s),
		.out(out[3:0])
	);
	
	mux_4_in_1 mux2(
		.in0(in0[7:4]),
		.in1(in1[7:4]),
		.s(s),
		.out(out[7:4])
	);
	
endmodule