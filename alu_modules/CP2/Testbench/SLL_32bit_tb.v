module SLL_32bit_tb();
	reg [31:0] in;
	reg [4:0] s;
	wire [31:0] out;
	
	reg clk;
	
	
	SLL_32bit dut(in, s, out);
	
	initial begin
	clk = 1'b0;
	
	@(posedge clk)
	in = 32'h73F7;
	s = 5'd8;
	
	@(posedge clk)
	in = 32'h033F;
	s = 5'd30;
	
	@(posedge clk)
	in = 32'h0005;
	s = 5'd30;
	
	#50
	$stop;
	
	end
	
	always begin
	#10 clk = ~clk;
	end
	
endmodule
