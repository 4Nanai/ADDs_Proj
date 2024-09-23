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
	clk = 1'b0;
	
	@(negedge clk)
	d = 1;
	en = 0;
	rst = 1;
	@(negedge clk)
	rst = 0;
	@(negedge clk)
	@(negedge clk)
	rst = 1;
	@(negedge clk)
	d = 1;
	@(negedge clk)
	en = 1;
	@(negedge clk)
	@(negedge clk)
	d = 0;
	@(negedge clk)
	d = 1;
	@(negedge clk)
	d = 0;
	
	
	#30 $stop;
	end
	always #10 clk = ~clk;
	
endmodule
	