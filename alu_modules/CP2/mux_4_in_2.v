module mux_4_in_2(
	input in0, in1, in2, in3,
	input [1:0] s,
	output out
	);
	
	wire mux_1_out, mux_2_out;
	
	mux_2_in_1 mux_1(
	 .in0(in0),
	 .in1(in1),
	 .s(s[0]),
	 .out(mux_1_out)
	);
	
	mux_2_in_1 mux_2(
	 .in0(in2),
	 .in1(in3),
	 .s(s[0]),
	 .out(mux_2_out)
	);
	
	mux_2_in_1 mux_3(
	 .in0(mux_1_out),
	 .in1(mux_2_out),
	 .s(s[1]),
	 .out(out)
	);
	
endmodule
