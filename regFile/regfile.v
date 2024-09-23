module regFile(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
data_readRegB
);

    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;
    output [31:0] data_readRegA, data_readRegB;

    /* Write part */
    wire [31:0] writeReg;
    decoder_5_32 writeDecoder(
        .in(ctrl_writeReg), 
        .en(1'b1), //Reserved for potential enable signal 
        .out(writeReg)
    );

    wire [31:0] en_Reg;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: gen_writeEnable
            and writeEnable(en_Reg[i], ctrl_writeEnable, writeReg[i]);
        end
    endgenerate

    /* RegFile generation */
    wire [31:0] regFileOut [31:0];

    generate
        for (i = 0; i < 32; i = i + 1) begin: gen_regFile
            reg_group_32 regFile(
                .q(data_writeReg), 
                .en(en_Reg[i]), 
                .clk(clk), 
                .rst(rst), 
                .d(regFileOut[i][31:0])
            );
        end
    endgenerate
    
	 
endmodule
