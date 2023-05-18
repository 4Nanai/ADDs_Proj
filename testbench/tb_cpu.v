`timescale 1 ns/1 ns
`define MOVI   4'b0000
`define MOV    4'b0001 
`define ADDI   4'b0010
`define ADD    4'b0011
`define SUBI   4'b0100
`define SUB    4'b0101
`define ANDI   4'b0110
`define AND    4'b0111
`define ORI    4'b1000
`define OR     4'b1001
`define LDRI   4'b1010
`define STR    4'b1011
`define JMP    4'b1100
`define IROM(addr) cpu.irom_i.sync_rom_i.mem[addr]
`define REGFILE cpu.cpu_i.data_path_i.reg_group_i
`define X0 2'b00
`define X1 2'b01
`define X2 2'b10
`define X3 2'b11

`define DX0 `REGFILE.q0 
`define DX1 `REGFILE.q1
`define DX2 `REGFILE.q2
`define DX3 `REGFILE.q3

`define DWIDTH 16
`define AWIDTH 12

module tb_cpu();
    parameter Tclk=10;
    reg clk, rst_n, en_in;

	always #Tclk clk=~clk;

	cpu_top cpu(
    .clk  (clk),
    .rst_n(rst_n),
    .en_in(en_in)
    );

	reg  [31 : 0] cycle;
	wire [31 : 0] timeout_cycle = 150;

	reg done;
	reg [31 : 0]  all_tests_passed = 0;
	reg [31 : 0]  current_test_id = 0;
	reg [255 : 0] current_test_type; // 32 bytes 
	reg [31 : 0]  current_output;
	reg [31 : 0]  current_result;

	// Count the number of cycles. 
	always @(posedge clk) begin
		cycle <= (done === 0) ? cycle + 1 : 0;
	end
	
	// Check for timeout
	initial begin
		// `===` is logical equality
		while (all_tests_passed === 0) begin
			@(posedge clk); // wait for the rising edge
			if (cycle === timeout_cycle) begin
				$display("[Falied] Timeout at [%d] test %s, expected_result = %h, got = %h",
						current_test_id, current_test_type, current_result, current_output);
				$finish();
			end
		end
	end

	task reset;
	begin
		@(negedge clk);
		rst_n = 0;
		@(negedge clk);
		rst_n = 1;
	end
	endtask

	function [`DWIDTH - 1 : 0] get_rd;
		input [1 : 0] register;
		begin
			case (register)
				`X0: get_rd = `DX0;
				`X1: get_rd = `DX1;
				`X2: get_rd = `DX2;
				`X3: get_rd = `DX3;
			endcase
		end
	endfunction

	task check_result_rf;
		input [1 : 0]  register;
		input [`DWIDTH - 1  : 0] result;
		input [255 : 0] test_type;

		begin
			done = 0;
			current_test_id   = current_test_id + 1;
			current_test_type = test_type;
			current_result    = result;

			while (get_rd(register) !== result) begin
				current_output = get_rd(register);
				@(posedge clk);
			end
			// finish
			done = 1;
			$display("[%d] Test %s passed!", current_test_id, test_type);
		end
	endtask


	//reg [1 : 0] RS1, RS2; // register
	//reg [`DWIDTH - 1 : 0] RD1, RD2; // register value 
	reg [`AWIDTH - 1 : 0] START_ADDR; // start instruction address

	initial
	begin
		`ifdef IVERILOG
			$dumpfile("tb_cpu.vcd");
			$dumpvars(0, tb_cpu);
		`endif
        
		clk = 0;
		rst_n = 0;
		#(Tclk*2) rst_n = 1;

		en_in=0;
        #(Tclk*3) en_in = 1;

		reset();

		START_ADDR = `AWIDTH'd0;

		`REGFILE.x0.q = 0;
		`REGFILE.x1.q = 0;
        `REGFILE.x2.q = 0;
        `REGFILE.x3.q = 0;
		
		
		// test cases
		`IROM(START_ADDR + 0) = {`MOVI, `X0, `X0, 8'd1};//test MOVI: 1
        check_result_rf(`X0, `DWIDTH'd1, "MOVI" );//check result: X0 = 1 X1 = 0 X2 = 0 X3 = 0

		`IROM(START_ADDR + 1) = {`MOVI, `X1, `X0, 8'd3};//test MOVI: 403
        check_result_rf(`X1, `DWIDTH'd3, "MOVI" );//check result: X0 = 1 X1 = 3 X2 = 0 X3 = 0

        `IROM(START_ADDR + 2) = {`MOV, `X2, `X0, 8'd0};//test MOV: 1800
        check_result_rf(`X2, `DWIDTH'd1, "MOV" );//check result: X0 = 1 X1 = 3 X2 = 1 X3 = 0

        `IROM(START_ADDR + 3) = {`ADD, `X2, `X0, 8'd0};//test ADD: 3800
        check_result_rf(`X2, `DWIDTH'd2, "ADD" );//check result: X0 = 1 X1 = 3 X2 = 2 X3 = 0

        `IROM(START_ADDR + 4) = {`ADDI, `X3, `X0, 8'd6};//test ADDI: 2C06
        check_result_rf(`X3, `DWIDTH'd6, "ADDI" );//check result: X0 = 1 X1= 3 X2 = 2 X3 = 6

        `IROM(START_ADDR + 5) = {`SUB, `X3, `X2, 8'd0};//test SUB: 5E00
        check_result_rf(`X3, `DWIDTH'd4, "SUB" );//check result: X0 = 1 X1 = 3 X2 = 2 X3 = 4

        `IROM(START_ADDR + 6) = {`SUBI, `X0, `X0, 8'd1};//test SUBI: 4001
        check_result_rf(`X0, `DWIDTH'd0, "SUBI" );//check result: X0 = 0 X1 = 3 X2 = 2 X3 = 4

        `IROM(START_ADDR + 7) = {`ANDI, `X3, `X0, 8'd12};//test ANDI: 6C0C
        check_result_rf(`X3, `DWIDTH'd4, "ANDI" );//check result: X0 = 0 X1 = 3 X2 = 2 X3 = 4

        `IROM(START_ADDR + 8) = {`AND, `X1, `X2, 8'd0};//test AND: 7600
        check_result_rf(`X1, `DWIDTH'd2, "AND" );//check result: X0 = 0 X1 = 2 X2 = 2 X3 = 4

        `IROM(START_ADDR + 9) = {`JMP, `X0, `X0, 8'd20};//test JMP: C014
        `IROM(START_ADDR + 20) = {`MOVI, `X0, `X0, 8'd10};//check if jump to addr 20
        check_result_rf(`X0, `DWIDTH'd10, "JMP" );//check result: X0 = 10 X1 = 2 X2 = 6 X3 = 4

        `IROM(START_ADDR + 21) = {`OR, `X2, `X3, 8'd0};//test OR: 9B00
        check_result_rf(`X2, `DWIDTH'd6, "OR" );//check result: X0 = 10 X1 = 2 X2 = 6 X3 = 4

        `IROM(START_ADDR + 22) = {`ORI, `X0, `X0, 8'd127};//test ORI: 807F
        check_result_rf(`X0, `DWIDTH'd127, "ORI" );//check result: X0 = 127 X1 = 2 X2 = 10 X3 = 4
        
        /* STATR LOAD TEST */

        `IROM(START_ADDR + 23) = {`LDRI, `X1, `X0, 8'd101};//test LDRI
        check_result_rf(`X1, `DWIDTH'd50, "LDRI" );//check result: X0 = 127 X1 = 50 X2 = 10 X3 = 4

        /* END OF LOAD TEST*/

        /* STATR STORE TEST*/
        
        `IROM(START_ADDR + 24) = {`STR, `X0, `X1, 8'd0};//test STR
        check_result_rf(`X1, `DWIDTH'd50, "STR" );//check result: X0 = 127 X1 = 50 X2 = 10 X3 = 4
        
        /* END OF STORE TEST*/
        
		#100;
		$display("All tests passed!");
		$finish();
	end
         
endmodule