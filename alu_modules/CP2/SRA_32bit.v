module SRA_32bit(in, s, out);
	input [31:0] in;
	input [4:0] s;
	output [31:0] out;
	
	wire [31:0] Shift_1, Shift_2, Shift_4, Shift_8;
	
	SRA_32bit_1s s_1(
		.in(in),
		.s(s[0]),
		.out(Shift_1)
	);
	
	SRA_32bit_2s s_2(
		.in(Shift_1),
		.s(s[1]),
		.out(Shift_2)
	);
	
	SRA_32bit_4s s_4(
		.in(Shift_2),
		.s(s[2]),
		.out(Shift_4)
	);
	
	SRA_32bit_8s s_8(
		.in(Shift_4),
		.s(s[3]),
		.out(Shift_8)
	);
	
	SRA_32bit_16s s_16(
		.in(Shift_8),
		.s(s[4]),
		.out(out)
	);
endmodule
