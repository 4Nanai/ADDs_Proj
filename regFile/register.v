module register(q, d, en, clk, rst);
input d, en, clk, rst;
output reg q;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		q <= 1'b0;
	end
	else begin
		if (en) begin
			q <= d;
		end
	end
end
endmodule
