/* verilator lint_off UNUSED */ 

module cpu_top #(
	parameter DWIDTH = 16,
	parameter AWIDTH = 12
)( input clk, rst_n,
 input en_in,
 output en_out
);
    wire en_ram_in, en_ram_out, en_str;
    wire [DWIDTH - 1 : 0] addr, str, rom_to_cpu;
    
    cpu cpu_i (
		.clk(clk),
		.rst_n(rst_n),
		.en_in(en_in),
		.en_str(en_str),
		.en_ram_out(en_ram_out),
		.ins(rom_to_cpu),
		.en_ram_in(en_ram_in),
		.addr(addr),
		.str_out(str),
		.ldr_in(rom_to_cpu)
    );
	rom rom_i (
		// input
		.clk   (clk),
		.rst_n (rst_n),
		.addr  (addr[AWIDTH - 1 : 0]),
		.en_rom (en_ram_in),
		.din(str),
		.en_str(en_str),
		// output
		.dout  (rom_to_cpu),
		.valid (en_ram_out)
	);
	assign en_out = en_ram_out;
endmodule
