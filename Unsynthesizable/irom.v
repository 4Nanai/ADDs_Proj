`timescale 1 ns / 1 ns
(* dont_touch = "{true}" *) module irom #(
	parameter DWIDTH = 16,
	parameter AWIDTH = 8,
	parameter DEPTH  = 1 << AWIDTH
)(
	input clk, rst_n,
	input [AWIDTH - 1 : 0] addr,
    input [DWIDTH - 1 : 0] str_in,
    input en_ldr,//enable load to reg_group
	input ready, en_str, //ready: enable ins out, en_str: enable store in
	output [DWIDTH - 1 : 0] dout, ldr_out,
	output valid
); 

	
	wire reg_din = ready ? 1'b1 : 1'b0;

	ASYNCR_EN_REG reg_i (
		// input
		.clk (clk),
		.rst_n (rst_n),
		.en  (1'b1),
		.d   (reg_din),
		// output
		.q    (valid)
	);

	SYNC_ROM #(
		.DWIDTH (DWIDTH),
		.AWIDTH (AWIDTH),
		.DEPTH  (DEPTH)
	) sync_rom_i (
		// input
		.clk  (clk),
		.en   (ready),
		.addr (addr),
		.str_in(str_in),
		.en_ldr(en_ldr),
		.en_str(en_str),
		// output
		.dout (dout),
		.ldr_out(ldr_out)
	);


endmodule
