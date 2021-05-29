`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 11:43:12 PM
// Design Name: 
// Module Name: calc
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


module calc(
	input CLOCK,
	input RESET,
	input INPUT_DATA_ENABLE,
	input [31:0] INPUT_DATA[8][8],
	output OUTPUT_DATA_ENABLE,
	output [31:0] OUTPUT_DATA[8][8]
    );

	logic [31:0] output_data[8][8];
	logic output_data_enable = 1'b0;

genvar k,l;
generate
	for (k=0;k<8;k=k+1) begin
		for(l=0;l<8;l=l+1) begin
			assign OUTPUT_DATA[k][l] = output_data[k][l];
		end
	end
endgenerate
	assign OUTPUT_DATA_ENABLE = output_data_enable;

genvar i,j;
generate
	for (i=0;i<8;i=i+1) begin
		for(j=0;j<8;j=j+1) begin
			always @(posedge CLOCK) begin
				if (RESET==1'b1) begin
					output_data[i][j] <= 32'h0;			
					output_data_enable <= 1'b0;
				end else begin
					if (INPUT_DATA_ENABLE == 1'b1) begin
						output_data[i][j] <= INPUT_DATA[j][i];			
						output_data_enable = 1'b1;
					end else begin
						output_data_enable = 1'b0;
					end
				end
			end
		end
	end
endgenerate

endmodule
