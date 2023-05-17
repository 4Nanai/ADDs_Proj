/* verilator lint_off UNDRIVEN */

module SYNC_ROM #(
	parameter DWIDTH = 16,
	parameter AWIDTH = 12,
	parameter DEPTH  = 1 << AWIDTH
)(
	input clk,
	input en,//pc enable
	input en_str,//store enable
	input en_ldr,//load enable
	input [AWIDTH - 1 : 0] addr,//pc addr
	input [DWIDTH - 1 : 0] str_in,//store data in
	output reg [DWIDTH - 1 : 0] dout, ldr_out//dout: ins out, ldr_out: load to reg_group
);

	reg [DWIDTH - 1 : 0] mem[0 : DEPTH - 1];

    initial begin
        mem[100] = 16'd0;
        mem[101] = 16'd50;
        ldr_out = 16'd0;
    end

/*
	initial begin
		mem[0] = 16'b0000_0000_0000_0100; //mov r0 #4, R[x0] = 4;
		mem[1] = 16'b0011_0100_0000_0000; //add r1 r0, R[x1] += R[x0];
		mem[2] = 16'b0011_1001_0000_0000; //add r2 r1, R[x2] += R[x1]; 
		mem[3] = 16'b1010_0000_0000_0000; //jump #0
	end
*/
// If not give a input(driven) to mem or initialize it, the verilator will 
// rise a undriven warning. But doesn't matter here, so we turn off this warning.


	always @(posedge clk) begin
		if (en) begin 
			dout <= mem[addr];		
		end
	end
    always @(posedge clk) begin
        if (en_str) begin
            #2
        	mem[100] <= str_in;
        end
    end
    always @(posedge clk) begin
        if (en_ldr) begin
            ldr_out <= mem[dout[7:0]];
        end
    end
endmodule
