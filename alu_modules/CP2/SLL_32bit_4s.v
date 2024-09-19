module SLL_32bit_4s(in, s, out);
	input [31:0] in;
	input s;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 28; i = i + 1) begin: mux_stack
		mux_2_in_1 mux_shift_1(
			.in0(in[i + 4]),
			.in1(in[i]),
			.s(s),
			.out(out[i + 4])
		);
	end
	endgenerate
	
	generate
	for (i = 0; i < 4; i = i + 1) begin: mux_shift_4
		mux_2_in_1 mux_shift_0(
			.in0(in[i]),
			.in1(1'b0),
			.s(s),
			.out(out[i])
		);
	end
	endgenerate
endmodule
