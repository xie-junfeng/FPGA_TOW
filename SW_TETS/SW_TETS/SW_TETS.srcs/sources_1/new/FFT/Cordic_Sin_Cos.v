`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:03:14
// Design Name: 
// Module Name: Cordic_Sin_Cos
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


module Cordic_Sin_Cos
(
	input				clk,
	input				reset,
	input  [19:0] 	Phase_in,
	
	output [15:0] 	Sin,
	output [15:0] 	Cos
);
					
// ---------- 伪旋转角度 ------------
parameter  rot1	= 19'd65536;	//45°（radian*（2^15-1）  /  tanθ = 2^-i)
parameter  rot2	= 19'd38688;	//26.56505°                                               
parameter  rot3	= 19'd20442;	//14.03624°                                               
parameter  rot4	= 19'd10377;	//7.12502°                                                
parameter  rot5	= 19'd5208;		//3.57633°                                                
parameter  rot6	= 19'd2607;		//1.78991°                                                
parameter  rot7	= 19'd1304;		//0.89517°                                                
parameter  rot8	= 19'd652;		//0.44761°                                                
parameter  rot9	= 19'd326;		//0.22381°                                                
parameter  rot10	= 19'd163;		//0.11191°                                                
parameter  rot11	= 19'd81;		//0.05595°                                                
parameter  rot12	= 19'd41;		//0.02798°                                                
parameter  rot13	= 19'd20;		//0.01399°                                                
parameter  rot14	= 19'd10;		//0.00699°                                                
parameter  rot15	= 19'd5;			//0.00350°                                                
parameter  rot16	= 19'd3;			//0.00175°                                                
parameter  rot17	= 19'd1;			//0.00087°  

parameter  X_START = 24'd2546925;//16'd19897;//伸缩因子，K=0.607252935(K*(2^15-1)),再扩大2^7=128倍，增加精度

//* Reg
reg  [24:0]		x0,y0;
reg  [24:0]		x1,y1;
reg  [24:0]		x2,y2;
reg  [24:0]		x3,y3;
reg  [24:0]		x4,y4;
reg  [24:0]		x5,y5;
reg  [24:0]		x6,y6;
reg  [24:0]		x7,y7;
reg  [24:0]		x8,y8;
reg  [24:0]		x9,y9;
reg  [24:0]		x10,y10;
reg  [24:0]		x11,y11;
reg  [24:0]		x12,y12;
reg  [24:0]		x13,y13;
reg  [24:0]		x14,y14;
reg  [24:0]		x15,y15;
reg  [24:0]		x16,y16;
reg  [24:0]		x17,y17;
reg  [19:0]		z0;
reg  [19:0]		z1;
reg  [19:0]		z2;
reg  [19:0]		z3;
reg  [19:0]		z4;
reg  [19:0]		z5;
reg  [19:0]		z6;
reg  [19:0]		z7;
reg  [19:0]		z8;
reg  [19:0]		z9;
reg  [19:0]		z10;
reg  [19:0]		z11;
reg  [19:0]		z12;
reg  [19:0]		z13;
reg  [19:0]		z14;
reg  [19:0]		z15;
reg  [19:0]		z16;
reg  [19:0]		z17;
reg  [4:0]		Quadrant_r[17:0];
reg  [19:0]		ret_x;
reg  [19:0]		ret_y;
reg  [4:0]		Quadrant;

//* Wire
wire [19:0]		Phase_pre;
wire [4:0]		Quadrant_flag;
wire [19:0]		Sin_w;
wire [19:0]		Cos_w;

/*************************************************************************/
Cordic_Pre  Cordic_Pre_Iint//相位集中在第一象限
(
	.Clk				( clk ),
	.reset			( reset ),
	.Phase_in		( Phase_in ),

	.Phase_pre		( Phase_pre ),
	.Quadrant_flag	( Quadrant_flag )
);

// ------------------------------------------------------
//* Initialize
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x0 <= 25'd0;
			y0 <= 25'd0;
			z0 <= 20'd0;
		end
	else 
		begin
			x0 <= {1'd0,X_START};
			y0 <= 25'd0;
			z0 <= Phase_pre;
		end
end

// --------- Level 1 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x1 <= 25'd0;
			y1 <= 25'd0;
			z1 <= 20'd0;
		end
	else if(z0[19] == 0)
		begin
			x1 <= x0 - y0;
			y1 <= y0 + x0;
			z1 <= z0 - rot1;
		end
	else
		begin
			x1 <= x0 + y0;
			y1 <= y0 - x0;
			z1 <= z0 + rot1;
		end
end


// --------- Level 2 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x2 <= 25'd0;
			y2 <= 25'd0;
			z2 <= 20'd0;
		end
	else if(z1[19] == 0)
		begin
			x2 <= x1 - {{1{y1[24]}},y1[24:1]};
			y2 <= y1 + {{1{x1[24]}},x1[24:1]};
			z2 <= z1 - rot2;
		end
	else
		begin
			x2 <= x1 + {{1{y1[24]}},y1[24:1]};
			y2 <= y1 - {{1{x1[24]}},x1[24:1]};
			z2 <= z1 + rot2;
		end
end

// --------- Level 3 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x3 <= 25'd0;
			y3 <= 25'd0;
			z3 <= 20'd0;
		end
	else if(z2[19] == 0)
		begin
			x3 <= x2 - {{2{y2[24]}},y2[24:2]};
			y3 <= y2 + {{2{x2[24]}},x2[24:2]};
			z3 <= z2 - rot3;
		end
	else
		begin
			x3 <= x2 + {{2{y2[24]}},y2[24:2]};
			y3 <= y2 - {{2{x2[24]}},x2[24:2]};
			z3 <= z2 + rot3;
		end
end

// --------- Level 4 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x4 <= 25'd0;
			y4 <= 25'd0;
			z4 <= 20'd0;
		end
	else if(z3[19] == 0)
		begin
			x4 <= x3 - {{3{y3[24]}},y3[24:3]};
			y4 <= y3 + {{3{x3[24]}},x3[24:3]};
			z4 <= z3 - rot4;
		end
	else
		begin
			x4 <= x3 + {{3{y3[24]}},y3[24:3]};
			y4 <= y3 - {{3{x3[24]}},x3[24:3]};
			z4 <= z3 + rot4;
		end
end

// --------- Level 5 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x5 <= 25'd0;
			y5 <= 25'd0;
			z5 <= 20'd0;
		end
	else if(z4[19] == 0)
		begin
			x5 <= x4 - {{4{y4[24]}},y4[24:4]};
			y5 <= y4 + {{4{x4[24]}},x4[24:4]};
			z5 <= z4 - rot5;
		end
	else 
		begin
			x5 <= x4 + {{4{y4[24]}},y4[24:4]};
			y5 <= y4 - {{4{x4[24]}},x4[24:4]};
			z5 <= z4 + rot5;
		end
end

// --------- Level 6 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x6 <= 25'd0;
			y6 <= 25'd0;
			z6 <= 20'd0;
		end
	else if(z5[19] == 0)
		begin
			x6 <= x5 - {{5{y5[24]}},y5[24:5]};
			y6 <= y5 + {{5{x5[24]}},x5[24:5]};
			z6 <= z5 - rot6;
		end
	else
		begin
			x6 <= x5 + {{5{y5[24]}},y5[24:5]};
			y6 <= y5 - {{5{x5[24]}},x5[24:5]};
			z6 <= z5 + rot6;
		end
end

// --------- Level 7 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x7 <= 25'd0;
			y7 <= 25'd0;
			z7 <= 20'd0;
		end
	else if(z6[19] == 0)
		begin
			x7 <= x6 - {{6{y6[24]}},y6[24:6]};
			y7 <= y6 + {{6{x6[24]}},x6[24:6]};
			z7 <= z6 - rot7;
		end
	else  
		begin
			x7 <= x6 + {{6{y6[24]}},y6[24:6]};
			y7 <= y6 - {{6{x6[24]}},x6[24:6]};
			z7 <= z6 + rot7;
		end
end

// --------- Level 8 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x8 <= 25'd0;
			y8 <= 25'd0;
			z8 <= 20'd0;
		end
	else if(z7[19] == 0)
		begin
			x8 <= x7 - {{7{y7[24]}},y7[24:7]};
			y8 <= y7 + {{7{x7[24]}},x7[24:7]};
			z8 <= z7 - rot8;
		end
	else 
		begin
			x8 <= x7 + {{7{y7[24]}},y7[24:7]};
			y8 <= y7 - {{7{x7[24]}},x7[24:7]};
			z8 <= z7 + rot8;
		end
end

// --------- Level 9 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x9 <= 25'd0;
			y9 <= 25'd0;
			z9 <= 20'd0;
		end
	else if(z8[19] == 0)
		begin
			x9 <= x8 - {{8{y8[24]}},y8[24:8]};
			y9 <= y8 + {{8{x8[24]}},x8[24:8]};
			z9 <= z8 - rot9;
		end
	else  
		begin
			x9 <= x8 + {{8{y8[24]}},y8[24:8]};
			y9 <= y8 - {{8{x8[24]}},x8[24:8]};
			z9 <= z8 + rot9;
		end
end

// --------- Level 10 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x10 <= 25'd0;
			y10 <= 25'd0;
			z10 <= 20'd0;
		end
	else if(z9[19] == 0)
		begin
			x10 <= x9 - {{9{y9[24]}},y9[24:9]};
			y10 <= y9 + {{9{x9[24]}},x9[24:9]};
			z10 <= z9 - rot10;
		end
	else 
		begin
			x10 <= x9 + {{9{y9[24]}},y9[24:9]};
			y10 <= y9 - {{9{x9[24]}},x9[24:9]};
			z10 <= z9 + rot10;
		end
end

// --------- Level 11 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x11 <= 25'd0;
			y11 <= 25'd0;
			z11 <= 20'd0;
		end
	else if(z10[19] == 0)
		begin
			x11 <= x10 - {{10{y10[24]}},y10[24:10]};
			y11 <= y10 + {{10{x10[24]}},x10[24:10]};
			z11 <= z10 - rot11;
		end
	else 
		begin
			x11 <= x10 + {{10{y10[24]}},y10[24:10]};
			y11 <= y10 - {{10{x10[24]}},x10[24:10]};
			z11 <= z10 + rot11;
		end
end

// --------- Level 12 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x12 <= 25'd0;
			y12 <= 25'd0;
			z12 <= 20'd0;
		end
	else if(z11[19] == 0)
		begin
			x12 <= x11 - {{11{y11[24]}},y11[24:11]};
			y12 <= y11 + {{11{x11[24]}},x11[24:11]};
			z12 <= z11 - rot12;
		end
	else 
		begin
			x12 <= x11 + {{11{y11[24]}},y11[24:11]};
			y12 <= y11 - {{11{x11[24]}},x11[24:11]};
			z12 <= z11 + rot12;
		end
end

// --------- Level 13 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x13 <= 25'd0;
			y13 <= 25'd0;
			z13 <= 20'd0;
		end
	else if(z12[19] == 0)
		begin
			x13 <= x12 - {{12{y12[24]}},y12[24:12]};
			y13 <= y12 + {{12{x12[24]}},x12[24:12]};
			z13 <= z12 - rot13;
		end
	else 
		begin
			x13 <= x12 + {{12{y12[24]}},y12[24:12]};
			y13 <= y12 - {{12{x12[24]}},x12[24:12]};
			z13 <= z12 + rot13;
		end
end

// --------- Level 14 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x14 <= 25'd0;
			y14 <= 25'd0;
			z14 <= 20'd0;
		end
	else if(z13[19] == 0)
		begin
			x14 <= x13 - {{13{y13[24]}},y13[24:13]};
			y14 <= y13 + {{13{x13[24]}},x13[24:13]};
			z14 <= z13 - rot14;
		end
	else 
		begin
			x14 <= x13 + {{13{y13[24]}},y13[24:13]};
			y14 <= y13 - {{13{x13[24]}},x13[24:13]};
			z14 <= z13 + rot14;
		end
end

// --------- Level 15 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x15 <= 25'd0;
			y15 <= 25'd0;
			z15 <= 20'd0;
		end
	else if(z14[19] == 0)
		begin
			x15 <= x14 - {{14{y14[24]}},y14[24:14]};
			y15 <= y14 + {{14{x14[24]}},x14[24:14]};
			z15 <= z14 - rot15;
		end
	else 
		begin
			x15 <= x14 + {{14{y14[24]}},y14[24:14]};
			y15 <= y14 - {{14{x14[24]}},x14[24:14]};
			z15 <= z14 + rot15;
		end
end

// --------- Level 16 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x16 <= 25'd0;
			y16 <= 25'd0;
			z16 <= 20'd0;
		end
	else if(z15[19] == 0)
		begin
			x16 <= x15 - {{15{y15[24]}},y15[24:15]};
			y16 <= y15 + {{15{x15[24]}},x15[24:15]};
			z16 <= z15 - rot16;
		end
	else 
		begin
			x16 <= x15 + {{15{y15[24]}},y15[24:15]};
			y16 <= y15 - {{15{x15[24]}},x15[24:15]};
			z16 <= z15 + rot16;
		end
end

// --------- Level 17 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x17 <= 25'd0;
			y17 <= 25'd0;
			z17 <= 20'd0;
		end
	else if(z16[19] == 0)
		begin
			x17 <= x16 - {{16{y16[24]}},y16[24:16]};
			y17 <= y16 + {{16{x16[24]}},x16[24:16]};
			z17 <= z16 - rot17;
		end
	else 
		begin
			x17 <= x16 + {{16{y16[24]}},y16[24:16]};
			y17 <= y16 - {{16{x16[24]}},x16[24:16]};
			z17 <= z16 + rot17;
		end
end


// --------------------------------------------------------------------------------------------
//* 每个Phase所在象限的流水线延迟
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			Quadrant_r[0] <= 4'b0000;
			Quadrant_r[1] <= 4'b0000;
			Quadrant_r[2] <= 4'b0000;
			Quadrant_r[3] <= 4'b0000;
			Quadrant_r[4] <= 4'b0000;
			Quadrant_r[5] <= 4'b0000;
			Quadrant_r[6] <= 4'b0000;
			Quadrant_r[7] <= 4'b0000;
			Quadrant_r[8] <= 4'b0000;
			Quadrant_r[9] <= 4'b0000;
			Quadrant_r[10] <= 4'b0000;
			Quadrant_r[11] <= 4'b0000;
			Quadrant_r[12] <= 4'b0000;
			Quadrant_r[13] <= 4'b0000;
			Quadrant_r[14] <= 4'b0000;
			Quadrant_r[15] <= 4'b0000;
			Quadrant_r[16] <= 4'b0000;
			Quadrant_r[17] <= 4'b0000;
			Quadrant <= 4'b0000;
		end
	else
		begin
			Quadrant_r[0] <= Quadrant_flag;
			Quadrant_r[1] <= Quadrant_r[0];
			Quadrant_r[2] <= Quadrant_r[1];
			Quadrant_r[3] <= Quadrant_r[2];
			Quadrant_r[4] <= Quadrant_r[3];
			Quadrant_r[5] <= Quadrant_r[4];
			Quadrant_r[6] <= Quadrant_r[5];
			Quadrant_r[7] <= Quadrant_r[6];
			Quadrant_r[8] <= Quadrant_r[7];
			Quadrant_r[9] <= Quadrant_r[8];
			Quadrant_r[10] <= Quadrant_r[9];
			Quadrant_r[11] <= Quadrant_r[10];
			Quadrant_r[12] <= Quadrant_r[11];
			Quadrant_r[13] <= Quadrant_r[12];
			Quadrant_r[14] <= Quadrant_r[13];
			Quadrant_r[15] <= Quadrant_r[14];
			Quadrant_r[16] <= Quadrant_r[15];
			Quadrant_r[17] <= Quadrant_r[16];
			Quadrant <= Quadrant_r[17];
		end
end
// assign ret_x = {{2{x17[24]}},x17[24:7]};
// assign ret_y = {{2{y17[24]}},y17[24:7]};
// assign Quadrant = Quadrant_r[17];

always@(posedge clk or posedge reset)
begin
	if(reset)
		ret_x <= 20'd0;
	else if(x17[24]==0 && x17[6]==1)
		ret_x <= {{2{x17[24]}},x17[24:7]} + 20'd1;
	else if(x17[24]==0 && x17[6]==0)
		ret_x <= {{2{x17[24]}},x17[24:7]};
	else if(x17[24]==1 && x17[6]==1)
		ret_x <= {{2{x17[24]}},x17[24:7]} - 20'd1;
	else// if(x17[24]==1 && x17[6]==0)
		ret_x <= {{2{x17[24]}},x17[24:7]};
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		ret_y <= 20'd0;
	else if(y17[24]==0 && y17[6]==1)
		ret_y <= {{2{y17[24]}},y17[24:7]} + 20'd1;
	else if(y17[24]==0 && y17[6]==0)
		ret_y <= {{2{y17[24]}},y17[24:7]};
	else if(y17[24]==1 && y17[6]==1)
		ret_y <= {{2{y17[24]}},y17[24:7]} - 20'd1;
	else// if(y17[24]==1 && y17[6]==0)
		ret_y <= {{2{y17[24]}},y17[24:7]};
end

Cordic_Post  Cordic_Post_Init
(
	.Clk			( clk ),
	.reset			( reset ),
	.ret_x			( ret_x ),
	.ret_y			( ret_y ),
	.Quadrant		( Quadrant ),
	
	.Sin			( Sin_w ),
	.Cos			( Cos_w )
);
assign Sin = {Sin_w[19],Sin_w[14:0]};
assign Cos = {Cos_w[19],Cos_w[14:0]};

endmodule
