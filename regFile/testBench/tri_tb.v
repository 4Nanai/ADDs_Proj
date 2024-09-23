module tri_tb();
	reg [31:0] in;
	reg z, clk;
	wire [31:0] out;
	
	tri_32 dut(in, z, out);
	
	initial begin
	clk = 1'b0;
	@(posedge clk)
	in = 32'd23498;
	z = 0;
	@(posedge clk)
	z = 1;
	@(posedge clk)
	in = 32'd3247;
	@(posedge clk)
	z = 0;
	#30 $stop;
	
	end
	always #10 clk = ~clk;
endmodule
