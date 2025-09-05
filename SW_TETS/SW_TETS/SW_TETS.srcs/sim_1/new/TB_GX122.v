`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 09:23:14
// Design Name: 
// Module Name: TB_GX122
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


module TB_GX122_MASTER();
 parameter                       SPI_SEND_WITH        = 16 ;  
 parameter                       SPI_RECE_WITH        = 16   ;  
    reg                           CLK_100MHz                  ;
    reg                           RESET                         ; 
wire spi_cs_o;
wire spi_sclk;
wire spi_mosi;wire spi_mosi_o ;
     
    //��λ��ʼ�� 
 initial begin
     RESET <= 1'b0   ;
     #20
     RESET <= 1'b1   ;
 end
  
  //15MHzʱ��
   initial begin
   CLK_100MHz = 1'b1      ;
//   #500
   forever begin
    #5 CLK_100MHz = ~CLK_100MHz;
   end
   end


reg            [7:0]                      mode_chose;

  //15MHzʱ��
   initial begin
   mode_chose = 8'b0      ;
//   #500
   forever begin
    #500000   mode_chose = 8'd7     ;
//    #2500000     mode_chose = 8'd2      ;
//    #2500000     mode_chose = 8'd3      ;
//    #2500000     mode_chose = 8'd4      ;
   end
   end
wire spi_miso;
wire [15:0]Tempe_data;

GX122_TEMPERATURE  
#(
  .SPI_SEND_WITH         ( SPI_SEND_WITH ),
  .SPI_RECE_WITH         ( SPI_RECE_WITH ) 
)

U_GX122_TEMPERATURE
(
  .clk_i                 (CLK_100MHz), 
  .rst_i                 (RESET), 
//ģʽ����
  .mode_chose            (mode_chose ), 
   //����ӿ�   
  .spi_cs_o(spi_cs_o), 
  .spi_sclk_o(spi_sclk), 
  .spi_miso_i(spi_miso), 
  .spi_mosi_o(spi_mosi_o),
	.LE		      	           (),	  
  	 //Ӳ����������״̬���
    .monitor0_i		           (),
    .monitor1_i		           (),	    
    //��������
    .send_data_reg0_i		   (32'd0),
    //�������
	.recive_data_reg0_o		   (Tempe_data)	    
  
  
);


GX122_SPI_SLAVE_TOP
    #(
    	.DATA_WITH(SPI_SEND_WITH)
    )
 
 U_GX122_U_SPI_SLAVE_TOP
 (
		.fpga_sys_clk_i(CLK_100MHz), 			
		.fpga_sys_rst_i(RESET), 
			
		.spi_sclk_i(spi_sclk),				
		.spi_cs_i(spi_cs_o),			
		.spi_mosi_i(spi_mosi_o), 	
		.spi_miso_o(spi_miso)
		);



endmodule
