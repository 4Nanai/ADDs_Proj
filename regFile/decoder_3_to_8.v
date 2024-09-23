module decoder_3_to_8(in, en, out);
	input [2:0] in;
	input en;
	output [7:0] out;
	
	wire MS4bit,  //stands for Most Significant 4 bits
		 LS4bit,  //stands for Last Significant 4 bits
		 in_MSB_n;//stands for MSB of input wire [2:0] in

	not (in_MSB_n, in[2]);

	and (MS4bit, en, in[2]);
	and (LS4bit, en, in_MSB_n);

	decoder_2_to_4 decoder_LSB(
		.in(in[1:0]), 
		.en(LS4bit), 
		.out(out[3:0])
		);

	decoder_2_to_4 decoder_MSB(
		.in(in[1:0]), 
		.en(MS4bit), 
		.out(out[7:4])
		);
endmodule
