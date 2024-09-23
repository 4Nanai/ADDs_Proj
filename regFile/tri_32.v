module tri_32(in, z, out);
	input [31:0] in;
	input z;
	output [31:0] out;
	
	genvar i;
	generate
	for (i = 0; i < 32; i = i + 1) begin: gen_tri
		bufif1 tri_gates(out[i], in[i], z);
	end
	endgenerate

endmodule
