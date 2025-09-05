`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:53:49
// Design Name: 
// Module Name: Pruning_Cordic_Pre
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


module  Pruning_Cordic_Pre
(
	input				Clk,
	input				reset,
	input  signed[31:0]	Phase_in,

	output signed[31:0]	Phase_pre,
	output		 [4:0]	Quadrant_flag
);

//* -------------------------------------------------------------- *\\
localparam	PI_2	= 32'd536870912;//pi/2=(3.14159265/2)*(2^31-1)
localparam	PI		= 32'd1073741824;//pi=(3.14159265/2)*(2^31-1)
localparam	PI_3_2	= 32'd1610612735;//pi*3/2=(3.14159265/2)*(2^31-1)
localparam	PI_2b	= 32'd2147483647;//pi*2=(3.14159265/2)*(2^31-1)

// ---------------------------------------------------------------------
//* Reg
reg signed[31:0]	Phase_pre_r0;
reg signed[31:0]	Phase_pre_r;
reg		  [1:0]		Quadrant_flag_r;
reg		  [2:0]		Special_Point;

/*******************************************************************/
always@( posedge Clk or posedge reset )
begin
	if( reset )
		Phase_pre_r0 <= 32'd0;
	else if(Phase_in == 32'h80000000)
		Phase_pre_r0 <= 32'd0;
	else if(Phase_in[31] == 1'd1)
		Phase_pre_r0 <= Phase_in + PI_2b;
	else
		Phase_pre_r0 <= Phase_in;
end

always@( posedge Clk or posedge reset )
begin
	if( reset )
		begin
			Quadrant_flag_r <= 2'b00;
			Phase_pre_r <= 32'd0;
		end
	else if( Phase_pre_r0 <= PI_2 )//第一象限
		begin
			Quadrant_flag_r <= 2'b00;
			Phase_pre_r <= Phase_pre_r0;
		end
	else if( Phase_pre_r0 <= PI )//第二象限
		begin
			Quadrant_flag_r <= 2'b01;
			Phase_pre_r <= PI - Phase_pre_r0;
		end
	else if( Phase_pre_r0 <= PI_3_2 )//第三象限
		begin
			Quadrant_flag_r <= 2'b11;
			Phase_pre_r <= Phase_pre_r0 - PI;
		end
	else//第四象限
		begin
			Quadrant_flag_r <= 2'b10;
			Phase_pre_r <= PI_2b - Phase_pre_r0;
		end

end

always@( posedge Clk or posedge reset )
begin
	if( reset )
		Special_Point <= 3'b000;
	else if( Phase_pre_r0 == 0 )//第一象限
		Special_Point <= 3'b001;
	else if( Phase_pre_r0 == PI_2 )//第二象限
		Special_Point <= 3'b010;
	else if( Phase_pre_r0 == PI )//第三象限
		Special_Point <= 3'b011;
	else if( Phase_pre_r0 == PI_3_2 )//第四象限
		Special_Point <= 3'b100;
	else//第四象限
		Special_Point <= 3'b000;

end
assign Phase_pre = Phase_pre_r;
assign Quadrant_flag = {Special_Point,Quadrant_flag_r};

endmodule

