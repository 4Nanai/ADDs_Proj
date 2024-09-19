module SRA_32bit_16s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 16; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_16(
			.in0(in[15 - i]),
			.in1(in[31 - i]),
			.s(s),
			.out(out[15 - i])
		);
	end
	endgenerate
	
	generate
	for (i = 0; i < 16; i = i + 1) begin: mux_shift_16
		mux_2_in_1 mux_shift_LOGICHIGH(
			.in0(in[31 - i]),
			.in1(1'b1),
			.s(s),
			.out(out[31 - i])
		);
	end
	endgenerate
	
endmodule
