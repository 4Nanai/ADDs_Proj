module reg_group_32(q, en, clk, rst, d);
    input [31:0] d;
    input en, clk, rst; // rst == 0 reset 1'b0; 
    output [31:0] q;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: gen_reg
            register reg_group(
                .q(q[i]), 
                .d(d[i]), 
                .en(en), 
                .clk(clk), 
                .rst(rst)
            );
        end
    endgenerate
endmodule
