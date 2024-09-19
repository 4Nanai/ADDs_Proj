module full_adder(a, b, carry_in, sum, carry_out);
	input a, b, carry_in;
	output carry_out, sum;
	
	/* for sum bit */
	wire xor_ab;
	xor (xor_ab, a, b);
	xor (sum, carry_in, xor_ab);
	
	
	/* for carry out bit */
	wire and3, and4, and5, or1;
	and (and3, carry_in, b);
	and (and4, carry_in, a);
	and (and5, a, b);
	or (carry_out, and3, and4, and5);
endmodule