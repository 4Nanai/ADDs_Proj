
`define ALU_MOV     3'b000
`define ALU_ADD     3'b001
`define ALU_SUB     3'b010
`define ALU_AND     3'b011
`define ALU_OR     3'b100

module alu #(
	parameter DWIDTH = 16
)(
	input clk, rst_n, en_in,
	input  [2:0] alu_func,
	input  [DWIDTH - 1:0] alu_a, alu_b,
	output reg [DWIDTH - 1:0] alu_out,
	output reg en_out
);
	localparam defaultval = {(DWIDTH){1'b0}};

	always @(negedge rst_n or posedge clk) begin
		if(rst_n ==1'b0) begin
			alu_out <= defaultval;
			en_out  <= 1'b0;
		end
		else if (en_in == 1'b1) begin
			en_out  <= 1'b1;
			case (alu_func)
			    `ALU_MOV: alu_out <= alu_b;
			    `ALU_ADD: alu_out <= alu_a + alu_b;
			    `ALU_SUB: alu_out <= alu_a - alu_b;
			    `ALU_AND: alu_out <= alu_a & alu_b;
			    `ALU_OR: alu_out <= alu_a | alu_b;
				default:   alu_out <= defaultval;
			endcase
		end
		else begin
			en_out <= 1'b0;
		end
	end
endmodule