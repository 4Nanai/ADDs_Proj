`timescale 1 ns / 1 ns
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
`define ALU_MOV     3'b000
`define ALU_ADD     3'b001
`define ALU_SUB     3'b010
`define ALU_AND     3'b011
`define ALU_OR      3'b100
module state_transition (
	input clk, rst_n,
	input en_in,
	input en1,
	input en2,
	input [1 : 0] rd,
	input [3 : 0] opcode,
	output reg en_fetch_pulse,
	output reg en_group_pulse,
	output reg en_pc_pulse,
	output reg [1 : 0] pc_ctrl,
	output reg [3 : 0] reg_en,
	output reg ldr_sel,
	output reg alu_in_sel,
	output reg en_str,
	output reg en_ldr,
	output reg [2 : 0] alu_func
);
	reg en_fetch_reg, en_fetch;
	reg en_group_reg, en_group;
	reg en_pc_reg,    en_pc;

	reg [3 : 0] current_state, next_state;

	localparam INIT= 4'b0000;
	localparam IF = 4'b0001;
	localparam ID = 4'b0010;
    localparam EX_AL = 4'b1000;
	localparam WB = 4'b0011;

	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			current_state <= INIT;
		end
		else begin 
			current_state <= next_state;
		end
	end

	always @ (*) begin
		case (current_state)
			INIT: begin
				if (en_in) begin 
					next_state = IF;
				end
				else begin
					next_state = INIT;
				end
			end

			IF: begin
				if (en1) begin
					next_state = ID;
				end
				else begin
					next_state = current_state;
				end
			end

			ID: begin
			     if(opcode[3] == 1'b0) begin
			         next_state = EX_AL;
			     end
			     else if(opcode == `ORI || opcode == `OR || opcode == `LDRI || opcode == `STR || opcode == `JMP) begin
			         next_state = EX_AL;
			     end
			     else begin
			         next_state = current_state;
			     end
			end

			EX_AL: begin
			    if (opcode == `LDRI) begin
			        next_state = WB;
			    end
			    else if (opcode == `STR) begin
			        next_state = IF;
			    end
			    else if (opcode == `JMP) begin
                    next_state = IF;
                end
				else if (en2) begin
				    next_state = WB;
				end
				else begin
					next_state = current_state;
				end
			end  

			WB: begin
				next_state = IF;
			end

			default: next_state = current_state;
		endcase
	end
    always @ (*) begin
        if(!rst_n) begin
            en_fetch = 1'b0;/* en_fetch_pulse/en_ram_in/ready(to irom):enable ROM ouput address */
			en_group = 1'b0;/* en_group_pulse(to reg_group): enable to read register group */
			en_pc = 1'b0;/* en_pc_pulse(to pc): enable pc to output */
			pc_ctrl = 2'b00;/* pc_ctrl(to pc): select fetch ins. type */
			en_str = 1'b0;/* en_str(to irom): enable ROM to store data */
			en_ldr = 1'b0;/* en_ldr(to irom): enable ROM to output data */
			reg_en = 4'b0000;/* reg_en(to reg_group): select write regs. */
			ldr_sel = 1'b0;/* ldr_sel(to datapath mux): 0 to sel. alu_out, 1 to sel. ROM out */
			alu_in_sel = 1'b0;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
			alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func. */
		end
		else begin
            case (next_state)
                INIT: begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    en_str = 1'b0;
                    en_ldr = 1'b0;
                    reg_en = 4'b0000;
                    ldr_sel = 1'b0;
                    alu_in_sel = 1'b0;
                    alu_func = `ALU_MOV;
                end
                
				IF: begin
                    en_fetch = 1'b1;/* en_fetch_pulse/en_ram_in/ready(to irom):enable ROM ouput address */
                    en_group = 1'b0;
                    en_pc = 1'b1;/* en_pc_pulse(to pc): enable pc to output */
                    pc_ctrl = 2'b01;/* pc_ctrl(to pc): select fetch ins. type */
                    en_str = 1'b0;
                    en_ldr = 1'b0;
                    reg_en = 4'b0000;
                    ldr_sel = 1'b0;
                    alu_in_sel = 1'b0;
                    alu_func = `ALU_MOV;
                end
                
                ID: begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    en_str = 1'b0;
                    en_ldr = 1'b0;
                    reg_en = 4'b0000;
                    ldr_sel = 1'b0;
                    alu_in_sel = 1'b0;
                    alu_func = `ALU_MOV;
				end

				EX_AL: begin
					case (opcode)
					    `MOVI: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;/* 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func.= MOV */
					    end
					    `MOV: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b1;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func.= MOV */
					    end
					    `ADDI: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b0;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_ADD;/* alu_func(to alu): sel. alu func.= ADD */
					    end
						`ADD: begin
						    en_fetch = 1'b0;
						    en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
						    en_pc = 1'b0;
						    pc_ctrl = 2'b00;
						    en_str = 1'b0;
						    en_ldr = 1'b0;
						    reg_en = 4'b0000;
						    ldr_sel = 1'b0;
						    alu_in_sel = 1'b1;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
						    alu_func = `ALU_ADD;/* alu_func(to alu): sel. alu func.= ADD */
						end
						`SUBI: begin
						    en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_SUB;/* alu_func(to alu): sel. alu func.= SUB */
						end
						`SUB: begin
						    en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b1;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_SUB;/* alu_func(to alu): sel. alu func.= SUB */
						end
						`ANDI: begin
						    en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_AND;/* alu_func(to alu): sel. alu func.= AND */
						end
						`AND: begin
						    en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b1;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_AND;/* alu_func(to alu): sel. alu func.= AND */
						end
						`ORI: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_OR;/* alu_func(to alu): sel. alu func.= OR */
						end
						`OR: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b1;/* alu_in_sel(to alu_mux): 0 to sel. imme, 1 to sel. rs_q */
                            alu_func = `ALU_OR;/* alu_func(to alu): sel. alu func.= OR */
						end
						`LDRI: begin
                            en_fetch = 1'b0;
                            en_group = 1'b0;
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b0;
                            en_ldr = 1'b1;/* en_ldr(to irom): enable ROM to output data */
                            reg_en = 4'b0000;
                            ldr_sel = 1'b1;
                            alu_in_sel = 1'b0;
                            alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func.= MOV */
						end
                        /* actually no LDR */
//						`LDR: begin
//						end
						/* actually no STRI */
//						`STRI: begin
//						end
						`STR: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b0;
                            pc_ctrl = 2'b00;
                            en_str = 1'b1;/* en_str(to irom): enable ROM to store data */
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;
                            alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func.= MOV */
						end
						`JMP: begin
                            en_fetch = 1'b0;
                            en_group = 1'b1;/* en_group_pulse(to reg_group): enable to read register group */
                            en_pc = 1'b1;/* en_pc_pulse(to pc): enable pc to output */
                            pc_ctrl = 2'b10;/* 01: let PC = PC + 1, 10: let PC = offset */
                            en_str = 1'b0;
                            en_ldr = 1'b0;
                            reg_en = 4'b0000;
                            ldr_sel = 1'b0;
                            alu_in_sel = 1'b0;
                            alu_func = `ALU_MOV;/* alu_func(to alu): sel. alu func.= MOV */
						end
						default: begin
							en_fetch = 1'b0;
							en_group = 1'b1;
							en_pc = 1'b0;
							pc_ctrl = 2'b00;
							en_str = 1'b1;
                            en_ldr = 1'b0;
							reg_en = 4'b0000;
							ldr_sel = 1'b0;
							alu_in_sel = 1'b1;
							alu_func = `ALU_MOV;
						end
					endcase
				end

				WB: begin
					en_fetch = 1'b0;
					en_group = 1'b0;
					en_pc = 1'b0;
					pc_ctrl = 2'b00;
				    en_str = 1'b0;
                    en_ldr = 1'b0;
                    if(opcode == `LDRI) begin
                        ldr_sel = 1'b1;
                    end
                    else begin
                        ldr_sel = 1'b0;
                    end
					alu_in_sel = 1'b0;
					alu_func = 3'b000;
					case(rd)//enable reg_group to write
						2'b00: reg_en = 4'b0001;
						2'b01: reg_en = 4'b0010;
						2'b10: reg_en = 4'b0100;
						2'b11: reg_en = 4'b1000;
						default: reg_en = 4'b0000;
					endcase
				end

				default: begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    en_str = 1'b0;
                    en_ldr = 1'b0;
                    reg_en = 4'b0000;
                    ldr_sel = 1'b0;
                    alu_in_sel = 1'b0;
                    alu_func = `ALU_MOV;
				end
			endcase
		end
	end

	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			en_fetch_reg <= 1'b0;
			en_pc_reg <= 1'b0;
			en_group_reg <= 1'b0;
		end
		else begin
			en_fetch_reg <= en_fetch;
			en_pc_reg <= en_pc;
			en_group_reg <= en_group;
		end
	end

	always @ (*) begin
		en_fetch_pulse = en_fetch & (~en_fetch_reg);
	end

	always @ (*) begin
		en_pc_pulse = en_pc & (~en_pc_reg);
	end

	always @ (*) begin
		en_group_pulse = en_group & (~en_group_reg);
	end
endmodule
