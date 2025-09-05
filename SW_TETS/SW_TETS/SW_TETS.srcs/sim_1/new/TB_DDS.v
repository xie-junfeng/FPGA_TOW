`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 14:48:02
// Design Name: 
// Module Name: TB_DDS
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


module TB_DDS();
wire[43:0] dout;
    reg                           PLL2_CLK_25MHz            ;
    reg                           RESET                         ; 
     
    //复位初始化 
 initial begin
     RESET <= 1'b0   ;
     #1000
     RESET <= 1'b1   ;
 end
  
  //15MHz时钟
   initial begin
   PLL2_CLK_25MHz = 1'b1      ;
//   #500
   forever begin
    #4 PLL2_CLK_25MHz = ~PLL2_CLK_25MHz;
   end
   end
reg  [10:0]   data4;
reg  [10:0]   data3;
reg  [10:0]   data2;
reg  [10:0]   data1;

 always @(posedge PLL2_CLK_25MHz)
begin

data4<= dout[43:33];
data3<= dout[32:22];
data2<= dout[21:11];
data1<= dout[10:0];
 end


DDS U_DDS (
	.clk			        (PLL2_CLK_25MHz ),
	.rstn				    (RESET),
	.delta_phase		    (16'b000_1000_0000_0000),
	.dout				    (dout)   
);


endmodule
