module SRA_32bit_2s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 30; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_2(
			.in0(in[29 - i]),
			.in1(in[31 - i]),
			.s(s),
			.out(out[29 - i])
		);
	end
	endgenerate
	
	generate
	for (i = 0; i < 2; i = i + 1) begin: mux_shift_2
		mux_2_in_1 mux_shift_LOGICHIGH(
			.in0(in[31 - i]),
			.in1(in[31]),
			.s(s),
			.out(out[31 - i])
		);
	end
	endgenerate
	
endmodule
