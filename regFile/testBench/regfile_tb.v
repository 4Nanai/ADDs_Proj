`timescale 1 ns / 100 ps

module regfile_tb();
	reg clock, ctrl_writeEnable, ctrl_reset;
	reg [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	reg [31:0] data_writeReg;
	wire [31:0] data_readRegA, data_readRegB;
	
	regfile dut(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
		ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
		data_readRegB);
		
	integer i;
	
	initial begin
	
		clock = 1'b0;
		ctrl_reset = 1'b1;
		@(posedge clock)
		ctrl_reset = 1'b0;
		@(posedge clock)
		ctrl_reset = 1'b1;
		@(posedge clock)
		for (i = 0; i < 32; i = i + 1) begin
			writeReg(i, 32'h0EA0DEAD);
		end
		@(posedge clock)
		ctrl_readRegA = 5'd10;
		ctrl_readRegB = 5'd30;
		
		@(posedge clock)
		writeReg(5, 32'hD0E0A0D0);
		@(posedge clock)
		writeReg(25, 32'h00FEED00);
		@(posedge clock)
		ctrl_readRegA = 5'd5;
		ctrl_readRegB = 5'd25;
		#30 $stop;
	end
	
	always #10 clock = ~clock;
	
	task writeReg;
		input [4:0] Reg_addr;
		input [31:0] writeData;
		
		begin
			@(posedge clock)
			ctrl_writeEnable = 1'b1;
			ctrl_writeReg = Reg_addr;
			data_writeReg = writeData;
			
			@(posedge clock)
			ctrl_writeEnable = 1'b0;
		end
		
	endtask

	
endmodule
