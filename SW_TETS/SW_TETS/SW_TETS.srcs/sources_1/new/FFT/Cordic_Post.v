`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:03:48
// Design Name: 
// Module Name: Cordic_Post
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

module  Cordic_Post
(
	input			Clk,
	input			reset,
	input  [19:0]	ret_x,
	input  [19:0]	ret_y,
	input  [4:0]	Quadrant,
	
	output [19:0]	Sin,
	output [19:0]	Cos
);

// -------------------------------------------------- \\
//* reg
reg  [19:0]	sin_r;
reg  [19:0]	cos_r;

/****************************************************************/
always@(posedge Clk or posedge reset)
begin
	if(reset)
		begin
			sin_r <= 20'd0;
			cos_r <= 20'd0;
		end
	else
		case(Quadrant)
			5'b00000://第一象限
				begin
					sin_r <= ret_y;
					cos_r <= ret_x;
				end
			5'b00001://第二象限
				begin
					sin_r <= ret_y;
					cos_r <= 0 - ret_x;
				end
			5'b00010://第四象限
				begin
					sin_r <= 0 - ret_y;
					cos_r <= ret_x;
				end
			5'b00011://第三象限
				begin
					sin_r <= 0 - ret_y;
					cos_r <= 0 - ret_x;
				end
			5'b00100,5'b00101,5'b00110,5'b00111://0
				begin
					sin_r <= 20'd0;
					cos_r <= 20'd32767;
				end
			5'b01000,5'b01001,5'b01010,5'b01011://90
				begin
					sin_r <= 20'd32767;
					cos_r <= 20'd0;
				end
			5'b01100,5'b01101,5'b01110,5'b01111://180
				begin
					sin_r <= 20'd0;
					cos_r <= 20'd1015809;
				end
			5'b10000,5'b10001,5'b10010,5'b10011://270
				begin
					sin_r <= 20'd1015809;
					cos_r <= 20'd0;
				end
			default:;
		endcase
end
assign  Sin = sin_r;
assign  Cos = cos_r;

endmodule

