`timescale 1ns/100ps   
module decoder_tb();
    reg [4:0] in;
    reg en;
    reg clk;
    wire [31:0] out;

    decoder_5_to_32 dut(in, en, out);

    initial begin
        clk = 1'b0;
        @(posedge clk)
        en = 0;
        in = 5'd1;
        @(posedge clk)
        en = 1;
        @(posedge clk)
        in = 5'd31;
        @(posedge clk)
        in = 5'd25;
        @(posedge clk)
        en = 0;
        in = 5'd18;
        @(posedge clk)
        en = 1;
        @(posedge clk)
        in = 5'd12;
        #30 $stop;
    end

    always 
    #10 clk = ~clk;
endmodule
