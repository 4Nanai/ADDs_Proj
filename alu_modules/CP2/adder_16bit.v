module adder_16bit(a, b, c_in, sum, c_out, OF);
	input [15:0] a, b;
	input c_in;
	output [15:0] sum;
	output c_out, OF;
	
	wire carry, c_0, c_1, OF_0, OF_1;
	wire [7:0] sum_c0, sum_c1;
	
	adder_8bit adder8_1(
		.a(a[7:0]),
		.b(b[7:0]),
		.c_in(c_in),
		.c_out(carry),
		.sum(sum[7:0])
	);
	
	adder_8bit adder8_2(
		.a(a[15:8]),
		.b(b[15:8]),
		.c_in(1'b0),
		.c_out(c_0),
		.sum(sum_c0[7:0]),
		.OF(OF_0)
	);
	
	adder_8bit adder8_3(
		.a(a[15:8]),
		.b(b[15:8]),
		.c_in(1'b1),
		.c_out(c_1),
		.sum(sum_c1[7:0]),
		.OF(OF_1)
	);
	
	mux_8_in_1 mux_for_data(
		.in0(sum_c0),
		.in1(sum_c1),
		.s(carry),
		.out(sum[15:8])
	);
	
	mux_2_in_1 mux_for_carry_out(
		.in0(c_0),
		.in1(c_1),
		.s(carry),
		.out(c_out)
	);
	mux_2_in_1 mux_for_OF(
		.in0(OF_0),
		.in1(OF_1),
		.s(carry),
		.out(OF)
	);
	
endmodule