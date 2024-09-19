module adder_4bit(a, b, carry_in, sum, carry_out, OF);
	input [3:0] a, b;
	input carry_in;
	output [3:0] sum;
	output carry_out, OF;
	
	wire c_1, c_2, c_3;
	/* instantiation 4 full adders */
	full_adder full_adder_1(
		.a(a[0]),
		.b(b[0]),
		.carry_in(carry_in),
		.carry_out(c_1),
		.sum(sum[0])
	);
	
	full_adder full_adder_2(
		.a(a[1]),
		.b(b[1]),
		.carry_in(c_1),
		.carry_out(c_2),
		.sum(sum[1])
	);
	
	full_adder full_adder_3(
		.a(a[2]),
		.b(b[2]),
		.carry_in(c_2),
		.carry_out(c_3),
		.sum(sum[2])
	);
	
	full_adder full_adder_4(
		.a(a[3]),
		.b(b[3]),
		.carry_in(c_3),
		.carry_out(carry_out),
		.sum(sum[3])
	);
	/* check overflow */
	xor (OF, c_3, carry_out);
	
endmodule
