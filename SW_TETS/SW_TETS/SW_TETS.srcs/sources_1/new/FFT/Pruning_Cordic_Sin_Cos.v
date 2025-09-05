`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:52:40
// Design Name: 
// Module Name: Pruning_Cordic_Sin_Cos
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


module Pruning_Cordic_Sin_Cos
(
	input			clk,
	input			reset,
	input  [31:0] 	Phase_in,
	
	output [31:0] 	Sin,
	output [31:0] 	Cos
);
					
// ---------- 伪旋转角度 ------------
localparam  rot0	= 32'd268435456;//45°（radian*（2^15-1）  /  tanθ = 2^-i)
localparam  rot1	= 32'd158466703;//26.56505°                                               
localparam  rot2	= 32'd83729454;//14.03624°                                               
localparam  rot3	= 32'd42502378;//7.12502°                                                
localparam  rot4	= 32'd21333666;//3.57633°                                                
localparam  rot5	= 32'd10677233;//1.78991°                                                
localparam  rot6	= 32'd5339919;//0.89517°                                                
localparam  rot7	= 32'd2670123;//0.44761°                                                
localparam  rot8	= 32'd1335082;//0.22381°                                                
localparam  rot9	= 32'd667543;//0.11191°                                                
localparam  rot10	= 32'd333772;//0.05595°                                                
localparam  rot11	= 32'd166886;//0.02798°                                                
localparam  rot12	= 32'd83443;//0.01399°                                                
localparam  rot13	= 32'd41722;//0.00699°                                                
localparam  rot14	= 32'd20861;//0.00350°                                                
localparam  rot15	= 32'd10430;//0.00175°                                                
localparam  rot16	= 32'd5215;//0.00087°                                              
localparam  rot17	= 32'd2608;//0.00044°   
localparam  rot18	= 32'd1304;                                          
localparam  rot19	= 32'd652;                                          
localparam  rot20	= 32'd326;                                          
localparam  rot21	= 32'd163;                                          
localparam  rot22	= 32'd81;                                          
localparam  rot23	= 32'd41;                                          
localparam  rot24	= 32'd20;                                          
localparam  rot25	= 32'd10;                                          
localparam  rot26	= 32'd5;                                          
localparam  rot27	= 32'd3;                                          
localparam  rot28	= 32'd1;                                          
localparam  rot29	= 32'd1;

localparam  X_START = 46'd21365813207646;//45'd2546925;//16'd19897;//伸缩因子，K=0.607252935(K*(2^15-1)),再扩大2^7=128倍，增加精度

// ---------------------------------------------------------------------
//* Reg
reg  signed[45:0]		x[29:0];
reg  signed[45:0]		y[29:0];
reg  signed[31:0]		z[29:0];
reg  signed[31:0]		ret_x;
reg  signed[31:0]		ret_y;
reg			[4:0]		Quadrant_r[30:0];
reg			[4:0]		Quadrant;

// ---------------------------------------------------------------------
//* Wire
wire signed[31:0]		Sin_w;
wire signed[31:0]		Cos_w;
wire signed[31:0]		rot[29:0];
wire	   [31:0]		Phase_pre;
wire	   [4:0]		Quadrant_flag;

// -----------------------------------------------------------------------
assign  rot[0]	= rot0;
assign  rot[1]	= rot1;         
assign  rot[2]	= rot2;        
assign  rot[3]	= rot3;        
assign  rot[4]	= rot4;        
assign  rot[5]	= rot5;        
assign  rot[6]	= rot6;       
assign  rot[7]	= rot7;       
assign  rot[8]	= rot8;       
assign  rot[9]	= rot9;      
assign  rot[10]	= rot10;      
assign  rot[11]	= rot11;      
assign  rot[12]	= rot12;     
assign  rot[13]	= rot13;     
assign  rot[14]	= rot14;     
assign  rot[15]	= rot15;     
assign  rot[16]	= rot16;  
assign  rot[17]	= rot17;
assign  rot[18]	= rot18;
assign  rot[19]	= rot19;
assign  rot[20]	= rot20;
assign  rot[21]	= rot21;
assign  rot[22]	= rot22;
assign  rot[23]	= rot23;
assign  rot[24]	= rot24;
assign  rot[25]	= rot25;
assign  rot[26]	= rot26;
assign  rot[27]	= rot27;
assign  rot[28]	= rot28;
assign  rot[29]	= rot29;

/*************************************************************************/
Pruning_Cordic_Pre  Cordic_Pre_Iint//相位集中在第一象限
(
	.Clk			( clk ),
	.reset			( reset ),
	.Phase_in		( Phase_in ),

	.Phase_pre		( Phase_pre ),
	.Quadrant_flag	( Quadrant_flag )
);

// --------- Level 1 ----------
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			x[0] <= 46'd0;
			y[0] <= 46'd0;
			z[0] <= 32'd0;
		end
	else if(Phase_pre[31] == 0)
		begin
			x[0] <= X_START;
			y[0] <= X_START;
			z[0] <= Phase_pre - rot[0];
		end
	else
		begin
			x[0] <= X_START;
			y[0] <= ~X_START+1;
			z[0] <= Phase_pre + rot[0];
		end
end

genvar	j;
generate
	for(j=1;j<30;j=j+1)
		begin : Level_n
			always@(posedge clk or posedge reset)
			begin
				if(reset)
					begin
						x[j] <= 46'd0;
						y[j] <= 46'd0;
						z[j] <= 32'd0;
					end
				else if(z[j-1][31] == 0)
					begin
						x[j] <= x[j-1] - {{j{y[j-1][45]}},y[j-1][45:j]};
						y[j] <= y[j-1] + {{j{x[j-1][45]}},x[j-1][45:j]};
						z[j] <= z[j-1] - rot[j];
					end
				else 
					begin
						x[j] <= x[j-1] + {{j{y[j-1][45]}},y[j-1][45:j]};
						y[j] <= y[j-1] - {{j{x[j-1][45]}},x[j-1][45:j]};
						z[j] <= z[j-1] + rot[j];
					end
			end
		end
endgenerate

// --------------------------------------------------------------------------------------------
//* 每个Phase所在象限的流水线延迟always@(posedge clk or posedge reset)
always@(posedge clk or posedge reset)
begin
	if(reset)
		Quadrant_r[0] <= 4'b0000;
	else
		Quadrant_r[0] <= Quadrant_flag;
end

genvar	k;
generate
	for(k=1;k<31;k=k+1)
		begin : Quadrant_Cache
			always@(posedge clk or posedge reset)
			begin
				if(reset)
					Quadrant_r[k] <= 4'b0000;
				else
					Quadrant_r[k] <= Quadrant_r[k-1];
			end
		end
endgenerate

always@(posedge clk or posedge reset)
begin
	if(reset)
		Quadrant <= 4'b0000;
	else
		Quadrant <= Quadrant_r[29];
end

// --------------------------------------------------------------------------------------------
//* 四舍五入
always@(posedge clk or posedge reset)
begin
	if(reset)
		ret_x <= 32'd0;
	else if(x[29][45]==0 && x[29][13]==1)
		ret_x <= x[29][45:14] + 32'd1;
	else if(x[29][45]==0 && x[29][13]==0)
		ret_x <= x[29][45:14];
	else if(x[29][45]==1 && x[29][13:0] > 14'h2000)
		ret_x <= x[29][45:14] + 32'd1;
	else
		ret_x <= x[29][45:14];
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		ret_y <= 32'd0;
	else if(y[29][45]==0 && y[29][13]==1)
		ret_y <= y[29][45:14] + 32'd1;
	else if(y[29][45]==0 && y[29][13]==0)
		ret_y <= y[29][45:14];
	else if(y[29][45]==1 && y[29][7:0] > 14'h2000)
		ret_y <= y[29][45:14] + 32'd1;
	else
		ret_y <= y[29][45:14];
end

Pruning_Cordic_Post  Cordic_Post_Init
(
	.Clk			( clk ),
	.reset			( reset ),
	.ret_x			( ret_x ),
	.ret_y			( ret_y ),
	.Quadrant		( Quadrant ),
	
	.Sin			( Sin_w ),
	.Cos			( Cos_w )
);
assign Sin = Sin_w;
assign Cos = Cos_w;

endmodule
