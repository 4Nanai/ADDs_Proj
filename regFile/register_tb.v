`timescale 1ns / 1ps

module register_tb();
	reg d, en, clk, rst;
	wire q;
	
	register dut(
	.d(d),
	.q(q),
	.en(en),
	.clk(clk),
	.rst(rst)
	);
	
	initial begin
	d = 0;
	clk = 0;
	rst = 1;
	en = 0;
	forever #20 clk = ~clk;
	end
	
	initial begin
	#30
	rst = 0;
	#20
	rst = 1;
	d = 1;
	#40
	d = 0;
	en = 1;
	#40
	d = 1;
	#40
	d = 0;
	#40
	d = 1;
	#80
	$stop;
	end
	
endmodule
	