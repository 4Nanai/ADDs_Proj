module regfile(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
data_readRegB
);

    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;
    output [31:0] data_readRegA, data_readRegB;

    /* Write part */
    wire [31:0] writeReg;
    decoder_5_to_32 writeDecoder(
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
                .d(data_writeReg), 
                .en(en_Reg[i]), 
                .clk(clock), 
                .rst(ctrl_reset), 
                .q(regFileOut[i][31:0])
            );
        end
    endgenerate
    
	 /* Read regFile decoder */
	 wire [31:0] readReg_A, readReg_B;
	 decoder_5_to_32 read_decoder_A(
		.in(ctrl_readRegA),
		.en(1'b1), // reserved for potential enable signal
		.out(readReg_A)
	 );
	 
	 decoder_5_to_32 read_decoder_B(
		.in(ctrl_readRegB),
		.en(1'b1), // reserved for potential enable signal
		.out(readReg_B)
	 );
	 
	 /* Tri-state gate for DataA */
	 generate
		for (i = 0; i < 32; i = i + 1) begin: gen_tri_32_32_A
			tri_32 tri_32_32_A(
				.in(regFileOut[i][31:0]),
				.z(readReg_A[i]),
				.out(data_readRegA)
			);
		end
	 endgenerate
	 
	 generate
		for (i = 0; i < 32; i = i + 1) begin: gen_tri_32_32_B
			tri_32 tri_32_32_B(
				.in(regFileOut[i][31:0]),
				.z(readReg_B[i]),
				.out(data_readRegB)
			);
		end
	 endgenerate
	 
endmodule
