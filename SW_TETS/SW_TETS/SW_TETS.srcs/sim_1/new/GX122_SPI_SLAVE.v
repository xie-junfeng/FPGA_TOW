`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 15:35:46
// Design Name: 
// Module Name: GX122_SPI_SLAVE
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


module GX122_SPI_SLAVE
#(
parameter DATA_WITH     = 32,
parameter SPI_MODE      = 0
)
(
input		            fpga_sys_clk_i,	
input		            fpga_sys_rst_i,
		
input		            spi_sclk_i,
input		            spi_cs_i,
input		            spi_mosi_i,
output		            spi_miso_o,

input		             tx_en_i,		
input	[(DATA_WITH-1):0]	 data_tx_i,		

output		             rx_en_o,	
output	[(DATA_WITH-1):0]	data_rx_o

		);
		
wire	tx_clock, rx_clock;
wire	sclk_free_state;

GX122_SPI_SCK	
    #(
    	.DATA_WITH(DATA_WITH)
    )
SPI_SCK(
	.fpga_sys_clk_i(fpga_sys_clk_i),		
	.fpga_sys_rst_i(fpga_sys_rst_i),
			
	.spi_sclk_i(spi_sclk_i),			
	.SPI_MODE(SPI_MODE),
	.tx_en_i(tx_en_i),			
	.tx_clock_o(tx_clock),		
	.rx_clock_o(rx_clock),		
	.sclk_free_state(sclk_free_state)	
	);


GX122_SPI_TX 
    #(
    	.DATA_WITH(DATA_WITH)
    )
 SPI_TX(
	.fpga_sys_clk_i(fpga_sys_clk_i),			
	.fpga_sys_rst_i(fpga_sys_rst_i),		
	.tx_clock_i(tx_clock),		
	.sclk_free_state(sclk_free_state),
	.spi_cs_i(spi_cs_i),
	.spi_miso_o(spi_miso_o),

	.data_tx_i(data_tx_i)
	);

GX122_SPI_RX
    #(
    	.DATA_WITH(DATA_WITH)
    )
	SPI_RX(
		.fpga_sys_clk_i(fpga_sys_clk_i),
		.fpga_sys_rst_i(fpga_sys_rst_i),
		
		.spi_cs_i(spi_cs_i),
		.rx_clock_i(rx_clock), 		
		.spi_mosi_i(spi_mosi_i),
		.data_rx_o(data_rx_o),
		.rx_en_o(rx_en_o)
		
		);
		
 endmodule
