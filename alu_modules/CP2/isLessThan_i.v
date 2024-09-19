module isLessThan_i(MSB, overFlow, out); //Simply do XOR operation
	input MSB, overFlow;
	output out;
	
	xor xor_MSB_OF(out, MSB, overFlow);
endmodule
