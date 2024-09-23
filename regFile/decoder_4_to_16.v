module decoder_4_to_16(in, en, out);
	input [3:0] in;
	input en;
	output [15:0] out;
	
	wire MS8bit,  //stands for Most Significant 8 bits
		 LS8bit,  //stands for Last Significant 8 bits
		 in_MSB_n;//stands for MSB of input wire [3:0] in

	not (in_MSB_n, in[3]);

	and (MS8bit, en, in[3]);
	and (LS8bit, en, in_MSB_n);

	decoder_3_to_8 decoder_LSB(
		.in(in[2:0]), 
		.en(LS8bit), 
		.out(out[7:0])
		);

	decoder_3_to_8 decoder_MSB(
		.in(in[2:0]), 
		.en(MS8bit), 
		.out(out[15:8])
		);
endmodule
