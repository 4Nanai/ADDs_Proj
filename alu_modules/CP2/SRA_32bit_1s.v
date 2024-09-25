module SRA_32bit_1s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 31; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_1(
			.in0(in[30 - i]),
			.in1(in[31 - i]),
			.s(s),
			.out(out[30 - i])
		);
	end
	endgenerate
	
	mux_2_in_1 mux_shift_0(
		.in0(in[31]),
		.in1(in[31]),
		.s(s),
		.out(out[31])
	);
endmodule
