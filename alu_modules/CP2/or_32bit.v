module or_32bit(
	input [31:0] in0, in1,
	output [31:0] out
);

	genvar i;
	generate
	for (i = 0; i < 32; i = i + 1) begin: for_32
		or (out[i], in0[i], in1[i]);
	end
	endgenerate 
endmodule
