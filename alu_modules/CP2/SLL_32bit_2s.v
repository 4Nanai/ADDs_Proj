module SLL_32bit_2s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 30; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_1(
			.in0(in[i + 2]),
			.in1(in[i]),
			.s(s),
			.out(out[i + 2])
		);
	end
	endgenerate
	
	generate
	for (i = 0; i < 2; i = i + 1) begin: mux_shift_2
		mux_2_in_1 mux_shift_0(
			.in0(in[i]),
			.in1(1'b0),
			.s(s),
			.out(out[i])
		);
	end
	endgenerate
endmodule
