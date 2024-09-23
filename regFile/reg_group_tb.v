module reg_group_tb();
	 reg [31:0] d;
    reg en, clk, rst; // rst == 0 reset 1'b0; 
    wire [31:0] q;
	 
	 reg_group_32 dut(q, en, clk, rst, d);
	 
	 initial begin
	 clk = 1'b0;
	 d = 32'h0ea0dead;
	 en = 0;
	 rst = 1;
	 
	 @(negedge clk)
	 rst = 0;
	 @(negedge clk)
	 rst = 1;
	 @(negedge clk)
	 en = 1;
	 @(negedge clk)
	 d = 32'h0000dead;
	 @(negedge clk)
	 d = 32'h0ea00000;
	 #30 $stop;
	 
	 end
	 
	 always #10 clk = ~clk;
endmodule
