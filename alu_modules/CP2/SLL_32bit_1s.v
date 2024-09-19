module SLL_32bit_1s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 31; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_1(
			.in0(in[i + 1]),
			.in1(in[i]),
			.s(s),
			.out(out[i + 1])
		);
	end
	endgenerate
	
	mux_2_in_1 mux_shift_0(
		.in0(in[0]),
		.in1(1'b0),
		.s(s),
		.out(out[0])
	);
endmodule
