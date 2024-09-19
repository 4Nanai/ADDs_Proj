module mux_2_in_1(in0, in1, s, out);
	input in0, in1, s;
	output out;
	wire not_s;
	wire and1, and2;
	
	not n1(not_s, s);
	and a1(and1, not_s, in0);
	and a2(and2, s, in1);
	or o1(out, and1, and2);
endmodule