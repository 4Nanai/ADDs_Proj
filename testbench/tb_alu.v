`timescale 1ns / 1ps

module tb_alu();
    //declaration of signals
    reg clk, rst_n, en_in;
    reg [2:0] alu_func; 
    reg [15:0] alu_a;
    reg [15:0] alu_b;
    wire [15:0] alu_out;
    wire en_out;
    //instantiation of the dut
    alu dut(
        .clk(clk),
        .rst_n(rst_n),
        .en_in(en_in),
        .alu_func(alu_func),
        .alu_a(alu_a),
        .alu_b(alu_b),
        .en_out(en_out),
        .alu_out(alu_out));
    //specify the stimulus
    initial begin
    rst_n = 0;
    clk = 0;
    forever #10 clk = ~clk;
    end
    initial
        begin
        #50
        rst_n = 1;
        en_in = 1;
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b000;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b000;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b001;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b001;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b010;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b010;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b011;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b011;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b100;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b100;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b101;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b101;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b110;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b110;
        #20
        alu_a = 16'b0000_0000_0100_0001;
        alu_b = 16'b0000_0000_0010_0001;
        alu_func = 3'b111;
        end
endmodule
