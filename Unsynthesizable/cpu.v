`timescale 1 ns / 1 ns
(* dont_touch = "{true}" *) module cpu #(
	parameter DWIDTH = 16
)(
	input clk, rst_n, en_in,
	input en_ram_out,
	input  [DWIDTH - 1 : 0] ins, ldr_in,
	output [DWIDTH - 1 : 0] addr, str_out,
	output en_ram_in, en_str, en_ldr
);


	wire alu_in_sel;
	wire en_alu;
	wire en_pc_pulse; 
	wire en_group_pulse;
	wire ldr_sel;
	wire [1 : 0] pc_ctrl;
	wire [3 : 0] reg_en;
	wire [2 : 0] alu_func;
	wire [7 : 0] offset_addr;

	data_path data_path_i (
		.clk(clk),
		.rst_n(rst_n),
		.offset(ins[7 : 0]),
		.offset_addr(offset_addr),
		.en_pc_pulse(en_pc_pulse),
		.pc_ctrl(pc_ctrl),
		.en_in(en_group_pulse),
		.reg_en(reg_en),
		.rd(ins[11 : 10]),
		.rs(ins[9 : 8]),
		.alu_in_sel(alu_in_sel),
		.alu_func(alu_func),
		.ldr_sel(ldr_sel),
		.en_out(en_alu),
		.pc_out(addr),
		.ldr_in(ldr_in),
		.str_out(str_out)
	);

	control_unit control_unit_i (
		.clk(clk ) ,
		.rst_n(rst_n) ,
		.en(en_in)  ,
		.en_alu(en_alu ) ,  
		.en_ram_out(en_ram_out) ,
		.ins(ins),
		.offset_addr(offset_addr),
		.en_ram_in(en_ram_in),
		.en_str(en_str),
		.en_ldr(en_ldr),
		.en_group_pulse(en_group_pulse),
		.en_pc_pulse(en_pc_pulse),
		.reg_en(reg_en),
		.alu_in_sel(alu_in_sel),
		.alu_func (alu_func),
		.ldr_sel(ldr_sel),
		.pc_ctrl(pc_ctrl)			
	);
	
endmodule				
