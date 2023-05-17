/* verilator lint_off UNUSED */ 
`timescale 1ns / 1ns
(* dont_touch = "{true}" *) module cpu_top #(
	parameter DWIDTH = 16,
	parameter AWIDTH = 8
)( input clk, rst_n,
 input en_in,
 output [15 : 0] ram_out
);
    wire en_ram_in, en_ram_out, en_str, en_ldr;
    wire [DWIDTH - 1 : 0] addr, ins, str, ldr;
    
    cpu cpu_i (
		.clk(clk),
		.rst_n(rst_n),
		.en_in(en_in),
		.en_str(en_str),
		.en_ldr(en_ldr),
		.en_ram_out(en_ram_out),
		.ins(ins),
		.en_ram_in(en_ram_in),
		.addr(addr),
		.str_out(str),
		.ldr_in(ldr)
    );
	
	irom irom_i (
		// input
		.clk   (clk),
		.rst_n (rst_n),
		.addr  (addr[AWIDTH - 1 : 0]),
		.ready (en_ram_in),
		.str_in(str),
		.en_ldr(en_ldr),
		.en_str(en_str),
		// output
		.dout  (ins),
		.valid (en_ram_out),
		.ldr_out(ldr)
	);
	assign ram_out = ldr;
endmodule
