module SLL_32bit_16s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 16; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_1(
			.in0(in[i + 16]),
			.in1(in[i]),
			.s(s),
			.out(out[i + 16])
		);
	end
	endgenerate
	
	generate
	for (i = 0; i < 16; i = i + 1) begin: mux_shift_16
		mux_2_in_1 mux_shift_0(
			.in0(in[i]),
			.in1(1'b0),
			.s(s),
			.out(out[i])
		);
	end
	endgenerate
endmodule
