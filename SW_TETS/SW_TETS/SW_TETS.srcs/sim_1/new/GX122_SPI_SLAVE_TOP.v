`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 15:33:13
// Design Name: 
// Module Name: GX122_SPI_SLAVE_TOP
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


module GX122_SPI_SLAVE_TOP
#(
parameter DATA_WITH = 32
)
(
    input                           fpga_sys_clk_i                     ,
    input                           fpga_sys_rst_i   
                      ,
    input                           spi_sclk_i                         ,
    input                           spi_cs_i                           ,
    input                           spi_mosi_i                         ,
    output                          spi_miso_o     
    
    );    
    
 wire  [(DATA_WITH-1):0] data_tx;
 wire  [(DATA_WITH-1):0] data_rx;  
 wire   tx_en;
 wire   rx_en;  
  
  
GX122_SPI_SLAVE 
    #(
    	.DATA_WITH(DATA_WITH)
    )

GX122_SPI_SLAVE(
	.fpga_sys_clk_i(fpga_sys_clk_i), 			
	.fpga_sys_rst_i(fpga_sys_rst_i), 
		
	.spi_sclk_i(spi_sclk_i),				
	.spi_cs_i(spi_cs_i),			
	.spi_mosi_i(spi_mosi_i), 	
	.spi_miso_o(spi_miso_o), 
			
	.data_tx_i(data_tx), 		
	.data_rx_o(data_rx), 	
	.tx_en_i(tx_en), 		
	.rx_en_o(rx_en) 	
	
		);   
    
GX122_SPI_SLAVE_FUNCTION
    #(
    	.DATA_WITH(DATA_WITH)
    )


	GX122_SPI_SLAVE_FUNCTION_SLAVE(
	.fpga_sys_clk_i(fpga_sys_clk_i), 			
	.fpga_sys_rst_i(fpga_sys_rst_i),

	.data_tx_o(data_tx), 		
	.data_rx_i(data_rx), 		
	.tx_en_o(tx_en), 		
	.rx_en_i(rx_en) 	 
	
		);       
    
    
endmodule
