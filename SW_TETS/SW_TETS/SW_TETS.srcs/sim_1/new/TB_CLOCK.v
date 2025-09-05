`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 20:07:37
// Design Name: 
// Module Name: TB_CLOCK
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

module TB_CLOCK();
 parameter                       SPI_SEND_WITH        = 32 ;  
 parameter                       SPI_RECE_WITH        = 32   ;  
    reg                           CLK_100MHz                  ;
    reg                           RESET                         ; 
wire spi_cs_o;
wire spi_sclk;
wire spi_mosi;  
     
    //复位初始化 
 initial begin
     RESET <= 1'b0   ;
     #20
     RESET <= 1'b1   ;
 end
  
  //15MHz时钟
   initial begin
   CLK_100MHz = 1'b1      ;
//   #500
   forever begin
    #5 CLK_100MHz = ~CLK_100MHz;
   end
   end


reg            [7:0]                      mode_chose;

  //15MHz时钟
   initial begin
   mode_chose = 8'b0      ;
//   #500
   forever begin
    #500000   mode_chose = 8'd0     ;
//    #2500000     mode_chose = 8'd2      ;
//    #2500000     mode_chose = 8'd3      ;
//    #2500000     mode_chose = 8'd4      ;
   end
   end
wire spi_miso;

XND4351_TOP_LOOP u_XND4351_TOP (
  .clk_i(CLK_100MHz), 
  .rst_i(RESET), 

  .mode_chose      (mode_chose ), 
  
  .spi_cs_o(spi_cs_o), 
  .spi_sclk_o(spi_sclk), 
  .spi_miso_i(spi_miso), 
  .spi_mosi_o(spi_mosi)
  
);


 SPI_SLAVE_TOP	U_SPI_SLAVE_TOP(
		.fpga_sys_clk_i(CLK_100MHz), 			
		.fpga_sys_rst_i(RESET), 
			
		.spi_sclk_i(spi_sclk),				
		.spi_cs_i(spi_cs_o),			
		.spi_mosi_i(spi_mosi), 	
		.spi_miso_o(spi_miso)
		);



endmodule
