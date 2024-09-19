module isNotEqual_i(in, out); //Simply do OR operation
	input [31:0] in;
	output out; //1'b1 => notEqual, 1'b0 => Equal
	
	wire [15:0] cascade_1_out;
	wire [7:0] cascade_2_out;
	wire [3:0] cascade_3_out;
	wire [1:0] cascade_4_out;
	
	genvar i;
	generate
	for (i = 0; i < 32; i = i + 2) begin: orCascade_1
		or (cascade_1_out[i / 2], in[i], in[i + 1]);
	end
	endgenerate
	
	generate
	for (i = 0; i < 16; i = i + 2) begin: orCascade_2
		or (cascade_2_out[i / 2], cascade_1_out[i], cascade_1_out[i + 1]);
	end
	endgenerate
	
	generate
	for (i = 0; i < 8; i = i + 2) begin: orCascade_3
		or (cascade_3_out[i / 2], cascade_2_out[i], cascade_2_out[i + 1]);
	end
	endgenerate
	
	generate
	for (i = 0; i < 4; i = i + 2) begin: orCascade_4
		or (cascade_4_out[i / 2], cascade_3_out[i], cascade_3_out[i + 1]);
	end
	endgenerate
	
	generate
	for (i = 0; i < 2; i = i + 2) begin: orCascade_5
		or (out, cascade_4_out[i], cascade_4_out[i + 1]);
	end
	endgenerate
	
endmodule
