`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/21 14:33:26
// Design Name: 
// Module Name: XND4351_TOP_LOOP
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


module XND4351_TOP_LOOP
#(
 parameter                       SPI_SEND_WITH        = 32  ,  
 parameter                       SPI_RECE_WITH        = 32  , 
 parameter                       MASTER_SPI_FREQUENCY =8'd100
)
(
input   wire                                   clk_i, 
input   wire                                   rst_i,
input   wire     [7:0]                         mode_chose,

output  wire                                    spi_cs_o,
output  wire                                    spi_sclk_o,
input   wire                                    spi_miso_i,
output  wire                                    spi_mosi_o,                       

output  wire                                    LE     ,                            
input   wire                                    PLL_LOCK,
input   wire                                    OUTMUX
    );
reg  [SPI_SEND_WITH-1:0]     s_send_data0_i_src;
reg  [SPI_SEND_WITH-1:0]     s_send_data1_i_src;  
    
reg [7:0]   mode_chose_src;
    
//////////////////////////////////////////////////////////////
wire         SW_VIO;
wire  [7:0]   mode_chose_VIO;
wire  [SPI_RECE_WITH-1:0]       send_data_VIO;
wire  [SPI_RECE_WITH-1:0]       recive_data_VIO;
wire  [4:0]       cfg_sta_VIO;


VIO_U_XND4351 VIO_U_XND4351 (
  .clk(clk_i),                // input wire clk
  .probe_in0(PLL_LOCK),    // input wire [0 : 0] probe_in0
  .probe_in1(OUTMUX),    // input wire [0 : 0] probe_in0
  .probe_in2(recive_data_VIO),    // input wire [0 : 0] probe_in0
  .probe_in3(cfg_sta_VIO),    // input wire [0 : 0] probe_in0
  .probe_out0(SW_VIO),  // output wire [0 : 0] probe_out1  
  .probe_out1(mode_chose_VIO),  // output wire [0 : 0] probe_out1
  .probe_out2(send_data_VIO)
);


always@(posedge clk_i or negedge rst_i)   
begin 
    if(!rst_i)begin
      mode_chose_src <= 7'd0; 
       end
    else if(SW_VIO)
       begin
      mode_chose_src <= mode_chose_VIO; 
       end
    else begin
      mode_chose_src <= mode_chose; 
    end
end

////////////////////////////////////////////////////////////////////

wire spi_start;
wire [SPI_SEND_WITH-1:0] spi_send_data;
wire spi_trans_end;
wire [SPI_RECE_WITH-1:0] spi_rece_data;
wire spi_busy;


 XND4351_SPI_MASTER_LOOP	         U_XND4351_SPI_MASTER_LOOP(
		.clk                (clk_i), 			
		.reset              (~rst_i), 		
		
	    .spi_csn_o          (spi_cs_o), 		
		.spi_sclk           (spi_sclk_o), 		
	    .spi_mosi           (spi_mosi_o), 		
		.spi_miso           (spi_miso_i) ,	
		.LE                 (LE) ,			
		.spi_baud           (MASTER_SPI_FREQUENCY),			
		.spi_start          (spi_start), 
		.spi_send_data_i    (spi_send_data), 		
		.spi_trans_end_o    (spi_trans_end), 		
		.spi_rece_data_o    (spi_rece_data), 		
		.spi_busy_o         (spi_busy) 			
		);


 XND4351_SPI_FUNCTION_MASTER_LOOP	XND4351_SPI_FUNCTION_MASTER_LOOP(
		.clk                (clk_i), 			
		.reset              (rst_i), 		
        .mode_chose         (mode_chose_src),        
        
		.send_data_VIO      (send_data_VIO      ), 
		.recive_data_VIO    (recive_data_VIO   ), 
		.cfg_sta            (cfg_sta_VIO  ),

		.spi_send_data_o    (spi_send_data), 	
		.spi_start_o        (spi_start), 
		.spi_end_i          (spi_trans_end), 		
		.spi_rece_data_i    (spi_rece_data)		
		
		);
		
		endmodule
