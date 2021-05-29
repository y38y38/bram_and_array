`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2021 10:34:11 PM
// Design Name: 
// Module Name: signal_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module signal_controller(
	//for module control
	input CLOCK,
	input RESET,
	input START,
	input [31:0] INPUT_RAM_ADDRESS,
	input [31:0] OUTPUT_RAM_ADDRESS,
	output [3:0] STATUS,

	//BRAM IF
	output [31:0] ADDRB,
	output CLKB,
	output [31:0] DINB,
	input [31:0] DOUTB,
	output ENB,
	output RSTB,
	output [3:0] WEB

	
    );


//	logic [31:0] read_address = 32'b0;

//	assign ADDRB = INPUT_RAM_ADDRESS;
	assign CLKB = CLOCK;

	logic enb;
//	assign ENB = enb;

	logic [3:0] state;
	localparam STATE_IDLE = 4'h0;
	localparam STATE_READ = 4'h1;
	localparam STATE_READING = 4'h2;
	localparam STATE_CALC = 4'h3;
	localparam STATE_WRITE = 4'h4;
	localparam STATE_WRITEING = 4'h5;


	assign STATUS = state;
	assign RSTB =  RESET;

/*
	always @( posedge CLOCK) begin
		if (RESET == 1'b1) begin
			read_address = 32'h0;
		end else begin
			if (START == 1'b1) begin
				read_address <= INPUT_RAM_ADDRESS;
			end
			
		end
	end
*/
	logic [31:0] ram_address = 32'h0;
	logic [7:0] read_counter = 7'h0;
	logic [31:0] block[8][8];
	logic calc_start = 1'b0;
	logic [31:0] calc_output_data[8][8];
	logic calc_output_data_enable = 1'b0;

	logic [7:0] write_counter = 6'h0;

	logic [31:0] dinb;
	logic [3:0] web;

	assign DINB = dinb;
	assign ENB = enb;
	assign WEB = web;

	calc calc_inst(
		.CLOCK(CLOCK),
		.RESET(RESET),
		.INPUT_DATA_ENABLE(calc_start),
		.INPUT_DATA(block),
		
		.OUTPUT_DATA_ENABLE(calc_output_data_enable),
		.OUTPUT_DATA(calc_output_data)
	);

	assign ADDRB = ram_address;

	always @( posedge CLOCK) begin
		if (RESET == 1'b1) begin
			state = STATE_IDLE;
			read_counter <= 32'h0;
			web <= 4'b0;
			enb <= 1'b1;
		end else begin
			if (START == 1'b1) begin
				state <= STATE_READING;
				ram_address <= INPUT_RAM_ADDRESS;
				read_counter <= 32'h00;
				write_counter <= 32'h00;
			end
			if (state == STATE_READING) begin
				if (read_counter != 32'h80)  begin
					block[read_counter>>4][(read_counter>>1) & 32'h7] <= DOUTB[15:0];
					block[read_counter>>4][((read_counter>>1) & 32'h7) + 1] <= DOUTB[31:16];
					ram_address <= INPUT_RAM_ADDRESS +  read_counter + 4;
					read_counter <= read_counter + 4;
				end else begin
//					read_counter <= 32'h0;
					state <= STATE_CALC;
					calc_start <= 1'b1;
				end
			end
			if (state == STATE_CALC) begin
				calc_start <= 1'b0;
				if (calc_output_data_enable == 1'b1) begin
					ram_address <= OUTPUT_RAM_ADDRESS;
					state <= STATE_WRITE;
				end
				
			end
			if (state == STATE_WRITE) begin
				if(write_counter < 32'h80) begin
					dinb[15:0] <= calc_output_data[write_counter>>4][(write_counter>>1) & 32'h7];
					dinb[31:16] <= calc_output_data[write_counter>>4][((write_counter>>1) & 32'h7) + 1];
					web <= 4'b1111;
					ram_address <= OUTPUT_RAM_ADDRESS +  write_counter + 4;
					write_counter <= write_counter + 4;
				end else begin
					write_counter <= 32'h0;
					state <= STATE_IDLE;
					web <= 4'b0000;
				end
			end

			
		end
	end
endmodule
