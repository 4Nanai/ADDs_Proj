module sub_32bit(a, b, c_in, sub, c_out, OF);
	input [31:0] a, b;
	input c_in;
	output [31:0] sub;
	output c_out, OF;
	wire [31:0] not_b, neg_b;
	
	not_32bit not_module(
		.in(b),
		.out(not_b)
	);
	
	adder_32bit adder_1(
		.a(not_b),
		.b(32'b1),
		.sum(neg_b)
	);
	
	adder_32bit adder_2(
		.a(a), 
		.b(neg_b), 
		.c_in(c_in), 
		.sum(sub), 
		.c_out(c_out), 
		.OF(OF)
	);
	
endmodule