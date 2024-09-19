module adder_8bit(a, b, c_in, sum, c_out, OF);
	input [7:0] a, b;
	input c_in;
	output [7:0] sum;
	output c_out, OF;
	
	wire carry;
	
	adder_4bit adder4_1(
		.a(a[3:0]),
		.b(b[3:0]),
		.carry_in(c_in),
		.carry_out(carry),
		.sum(sum[3:0])
	);
	
	adder_4bit adder4_2(
		.a(a[7:4]),
		.b(b[7:4]),
		.carry_in(carry),
		.carry_out(c_out),
		.sum(sum[7:4]),
		.OF(OF)
	);
endmodule