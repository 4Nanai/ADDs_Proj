module mux_8_in_3(
	input in0, in1, in2, in3, in4, in5, in6, in7,
	input [2:0] s,
	output out
	);
	
	wire mux_1_out, mux_2_out;
	
	mux_4_in_2 mux_1(
	 .in0(in0),
	 .in1(in1),
	 .in2(in2),
	 .in3(in3),
	 .s(s[1:0]),
	 .out(mux_1_out)
	);
	
	mux_4_in_2 mux_2(
	 .in0(in4),
	 .in1(in5),
	 .in2(in6),
	 .in3(in7),
	 .s(s[1:0]),
	 .out(mux_2_out)
	);
	
	mux_2_in_1 mux_3(
	 .in0(mux_1_out),
	 .in1(mux_2_out),
	 .s(s[2]),
	 .out(out)
	);
	
endmodule
