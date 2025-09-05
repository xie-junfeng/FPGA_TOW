`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:04:18
// Design Name: 
// Module Name: Cordic_Pre
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


module  Cordic_Pre
(
	input				Clk,
	input				reset,
	input  [19:0]	Phase_in,

	output [19:0]	Phase_pre,
	output [4:0]	Quadrant_flag
);

//* -------------------------------------------------------------- *\\
parameter	PI_2 	 = 20'd131071;//h07FFF;//pi/2=(3.14159265/2)*(2^15-1)
parameter	PI		 = 20'd262143;//h0FFFE;//pi=(3.14159265/2)*(2^15-1)
parameter	PI_3_2 = 20'd393215;//h96CBA;//pi*3/2=(3.14159265/2)*(2^15-1)
parameter	PI_2b	 = 20'd524287;//h96CBA;//pi*3/2=(3.14159265/2)*(2^15-1)

//* reg
reg [19:0]	Phase_pre_r;
reg [19:0]	Phase_pre_r0;
reg [1:0]	Quadrant_flag_r;
reg [2:0]	Special_Point;

/*******************************************************************/
// Div_2Pi  Div_2Pi_INIT//[0~2pi]
// (
	// .clock			( Clk ),
	// .denom			( 18'h07fff),//2*pi
	// .numer			( Phase_in ),
	// .quotient		(  ),
	// .remain			( Phase_2pi )
// );

always@( posedge Clk or posedge reset )
begin
	if( reset )
		Phase_pre_r0 <= 20'd0;
	else if(Phase_in == 20'h80000)
		Phase_pre_r0 <= 20'd0;
	else if(Phase_in[19] == 1'd1)
		Phase_pre_r0 <= Phase_in + PI_2b;
	else
		Phase_pre_r0 <= Phase_in;
end

always@( posedge Clk or posedge reset )
begin
	if( reset )
		begin
			Quadrant_flag_r <= 2'b00;
			Phase_pre_r <= 18'd0;
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

