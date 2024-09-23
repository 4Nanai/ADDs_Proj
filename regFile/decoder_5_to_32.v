module decoder_5_to_32(in, en, out);
	input [4:0] in;
	input en;
	output [31:0] out;
	
	wire MS16bit,  //stands for Most Significant 8 bits
		 LS16bit,  //stands for Last Significant 8 bits
		 in_MSB_n;//stands for MSB of input wire [3:0] in

	not (in_MSB_n, in[4]);

	and (MS8bit, en, in[4]);
	and (LS8bit, en, in_MSB_n);

	decoder_4_to_16 decoder_LSB(
		.in(in[3:0]), 
		.en(LS8bit), 
		.out(out[15:0])
		);

	decoder_4_to_16 decoder_MSB(
		.in(in[3:0]), 
		.en(MS8bit), 
		.out(out[31:16])
		);
endmodule
