/* verilator lint_off UNUSED */

module control_unit #(
	parameter DWIDTH = 16
)(
	input clk, rst_n,//clk: clock signal, rst_n: reset signal
	input en, en_alu, en_ram_out,//en:
	input [DWIDTH - 1 : 0] ins,
	output en_group_pulse,
	output en_pc_pulse,
	output en_ram_in,
	output en_str,
	output ldr_sel,
	output alu_in_sel,
	output addr_sel,
	output [7 : 0] offset_addr,
	output [3 : 0] reg_en,
	output [2 : 0] alu_func,
	output [1 : 0] pc_ctrl
);

	wire [DWIDTH - 1 : 0] ir_out;
	wire en_out;

	ir ir_i (
		.clk(clk),
		.rst_n(rst_n),
		.ins(ins),
		.en_in(en_ram_out),//enable addr
		.en_out(en_out),
		.ir_out(ir_out)
	);

	state_transition state_transition_i (
		.clk(clk),
		.rst_n(rst_n),
		.en_in(en),
		.en1(en_out),
		.en_str(en_str),//enable ROM to write
		.en2(en_alu),
		.rd(ir_out[11 : 10]),
		.opcode(ir_out[15 : 12]),
		.en_fetch_pulse(en_ram_in),	
		.en_group_pulse(en_group_pulse),
		.en_pc_pulse(en_pc_pulse),
		.pc_ctrl(pc_ctrl),
		.reg_en(reg_en),
		.ldr_sel(ldr_sel),
		.alu_in_sel(alu_in_sel),
		.alu_func(alu_func),
		.addr_sel(addr_sel)	
	);
			
//always @ (en_out,ir_out) 
	assign offset_addr = ir_out[7 : 0];

endmodule
