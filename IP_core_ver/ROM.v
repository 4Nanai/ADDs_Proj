
module rom(
    input clk, rst_n,
    input en_rom,
    input [ 0 : 0 ] en_str,
    input [ 7 : 0 ] addr,
    input [ 15 : 0 ] din,
    output [ 15 : 0 ] dout,
    output valid
    );
    wire reg_din = en_rom ? 1'b1 : 1'b0;
    blk_mem_gen_0 bram (
      .clka(clk),    // input wire clka
      .ena(en_rom),      // input wire ena
      .wea(en_str),      // input wire [0 : 0] wea
      .addra(addr),  // input wire [7 : 0] addra
      .dina(din),    // input wire [15 : 0] dina
      .douta(dout)  // output wire [15 : 0] douta
    );
    ASYNCR_EN_REG reg_en (
      .clk (clk),
      .en(en_rom),
      .rst_n(rst_n),
      .d(reg_din),
      .q(valid)
    );
endmodule
