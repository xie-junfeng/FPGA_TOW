`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/18 16:12:12
// Design Name: 
// Module Name: XND4351_TB
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


module TB_DSA();
 parameter                       SPI_SEND_WITH        = 32 ;  
 parameter                       SPI_RECE_WITH        = 32   ;  
    reg                           PLL2_CLK_25MHz            ;
    reg                           RESET                         ; 
wire spi_cs_o;
wire spi_sclk;
wire spi_mosi;  
     
    //复位初始化 
 initial begin
     RESET <= 1'b0   ;
     #100
     RESET <= 1'b1   ;
 end
  
  //15MHz时钟
   initial begin
   PLL2_CLK_25MHz = 1'b1      ;
//   #500
   forever begin
    #5 PLL2_CLK_25MHz = ~PLL2_CLK_25MHz;
   end
   end



DSA_Top u_DSA_Top (
	.Clk_25MHz			       (PLL2_CLK_25MHz ),
	.Reset				       (RESET),
	
  	.ALT_TIF_Gain_U91	       (8'D0   ), //       ARW637_RFOUT_DSA_SDI1_U91_reg
	.ALT_TRF_Gain_U92	       (8'D0   ),    //   ARW637_RFOUT_DSA_SDI2_U92_reg
	.ALT_TRF_Gain_U94	       (8'D0   ),        //ARW637_RFOUT_DSA_SDI3_U94_reg
	.ALT_TRF_Gain_U37	       (8'b10000001),
	.ALT_TIF_Gain_U81	       (8'b10000001),
	.ALT_RIF_Gain_U43	       (8'b10000001),     
	
	.ALT_TIF_Gain_U91_LE       (  ),          // ALT_TIF_Gain
	.ALT_TIF_Gain_U91_CLK      (  ),
	.ALT_TIF_Gain_U91_SERNIN   ( ),
	
	.ALT_TIF_Gain_U92_LE       (  ),            // ALT_TRF_Gain1  U104
	.ALT_TIF_Gain_U92_CLK      (   ),
	.ALT_TIF_Gain_U92_SERNIN   ( ),            //     
		
	.ALT_TIF_Gain_U94_LE        (  ),          // ALT_TRF_Gain2  U105 join
	.ALT_TIF_Gain_U94_CLK       ( ),          // ALT_RIF_Gain   U50  join   
	.ALT_TIF_Gain_U94_SERNIN    (  ),

	.ALT_TIF_Gain_U37_LE       ( ),          // ALT_TRF_Gain3 U107
	.ALT_TIF_Gain_U37_CLK      (  ),
	.ALT_TIF_Gain_U37_SERNIN   (  ),
	
	.ALT_TIF_Gain_U81_LE       (  ),          // ALT_RRF_Gain  U43 
    .ALT_TIF_Gain_U81_CLK      (  ),
	.ALT_TIF_Gain_U81_SERNIN   ( ),
	
	.ALT_TIF_Gain_U43_LE       (   ),          // ALT_RRF_Gain  U43 
    .ALT_TIF_Gain_U43_CLK      (  ),
	.ALT_TIF_Gain_U43_SERNIN   (  )
    
);


endmodule
