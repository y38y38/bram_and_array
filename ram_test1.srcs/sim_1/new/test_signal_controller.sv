`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 10:15:58 AM
// Design Name: 
// Module Name: test_signal_controller
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


module test_signal_controller();

localparam STEP 	= 8;
localparam TEST_TIME = (8*20);

logic clock;
logic reset;
logic start;
logic [31:0] input_ram_address;
logic [31:0] output_ram_address;
logic [3:0] status;

logic [31:0] addrb;
logic clkb;
logic [31:0] dinb;
logic [31:0] doutb;
logic enb;
logic rstb;
logic [3:0] web;



always begin
	clock = 0; #(STEP/2);
	clock = 1; #(STEP/2);
end

signal_controller  signal_controller_inst(
	.CLOCK(clock),
	.RESET(reset),
	.START(start),
	.INPUT_RAM_ADDRESS(input_ram_address),
	.OUTPUT_RAM_ADDRESS(output_ram_address),
	.STATUS(status),

	.ADDRB(addrb),
	.CLKB(clkb),
	.DINB(dinb),
	.DOUTB(doutb),
	.ENB(enb),
	.RSTB(rstb),
	.WEB(web)
);



initial begin
	reset = 1'b1;
	#STEP;
	reset = 1'b0;
	input_ram_address = 32'h0;
	output_ram_address = 32'h40;
	start = 1'b1;
	#STEP;
	start = 1'b0;
	#TEST_TIME;
end


always @(negedge clkb) begin
	doutb[15:0] <= (addrb>>1);	
	doutb[31:16] <= (addrb>>1) + 1;	
end


endmodule


