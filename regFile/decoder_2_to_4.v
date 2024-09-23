module decoder_2_to_4(in, en, out);
    input en;
    input [1:0] in;
    output [3:0] out;

    wire not_in_0, not_in_1, en_n;

    not (en_n, en);
    not (not_in_0, in[0]);
    not (not_in_1, in[1]);

    nor (out[0], in[0], in[1], en_n);
    and (out[1], in[0], not_in_1, en);
    and (out[2], not_in_0, in[1], en);
    and (out[3], in[0], in[1], en);
endmodule
