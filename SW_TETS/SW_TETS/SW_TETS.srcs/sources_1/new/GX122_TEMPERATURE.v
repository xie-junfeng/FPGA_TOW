`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 08:57:43
// Design Name: 
// Module Name: GX122_TEMPERATURE
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

module GX122_TEMPERATURE
#(
 //-------------------����λ����������----------------
parameter  SPI_SEND_WITH             = 16,                // ��������λ��
parameter  SPI_RECE_WITH             = 16,                // ��������λ��

//-------------------SPIͨѶģʽ����------------------
parameter  CPOL                      =   1,                // CPOL=0:serial clock low when idle; CPOL=1:serial clock high when idle
parameter  CPHA                      =   0,                // CPHA=0 capture serial data at 1st edge; CPHA=1: capture serial data at 2nd edge

 //-------------------��ģʽ�Ĵ�����Ŀ����-------------
parameter  REG_CFG_NUM_INIT          =   1,               // ��ʼ���ܹ���Ҫ���õļĴ�������
parameter  REG_CFG_NUM_WRITE_PRE0    =   1,               // д��һ��Ԥ��ģʽ0�ļĴ�������
parameter  REG_CFG_NUM_WRITE_PRE1    =   1,               // д�ڶ���Ԥ��ģʽ1�ļĴ�������
parameter  REG_CFG_NUM_READ_PRE0     =   1,               // ��Ԥ��ģʽ1�ļĴ�������

//----------------------��������-----------------------
parameter  SPI_INTERVALS1            =   1000,          // �Ĵ���֮�����ʱ ����ʱ��СΪ��1/clk*SPI_INTERVALS��
parameter  INITIAL_DELAY             =   0,             // ��λ����ʱ��ÿ�ʼ���üĴ��� ,��ʼ����ʱ����ʱ��СΪ��1/clk*INITIAL_INTERVALS1��12500000
parameter  CS_BEFOR_DELY             =   0   ,          // CS_BEFOR_DELY
parameter  CS_END_DELY               =   0   ,          //CS_END_DELY 
parameter  MOSI_IDLE_STATE           =   1'dZ,              //idle state of spi mosi
parameter  MASTER_SPI_FREQUENCY      =   100,             // �ź�Ƶ�ʷ�Ƶϵ��
 
//-----------------------���ܿ�������------------------     
parameter  CHEAK_DATA_EN             =   0,               // �����ܿ���������У���дһ�¡������أ���
parameter  INIT_REG_EN               =   0                // �費��Ҫ����ʼ���Ĵ������á�1-����0-�أ����أ���

)

(
//ʱ�Ӽ���λ
input   wire                                  clk_i, 
input   wire                                  rst_i,
//ģʽ����
input   wire     [7:0]                        mode_chose,
 //����ӿ� 
output  wire                                  spi_cs_o,
output  wire                                  spi_sclk_o,
input   wire                                  spi_miso_i,
output  wire                                  spi_mosi_o,                       
output  wire                                  LE,  
//Ӳ����������״̬���                       
input   wire                                  monitor0_i,
input   wire                                  monitor1_i,
//����Ĵ�������
input   wire       [SPI_SEND_WITH-1:0]        send_data_reg0_i,
//�������
output  wire       [SPI_SEND_WITH-1:0]        recive_data_reg0_o
//����

    );
 
reg  [SPI_SEND_WITH-1:0]     send_data0_i_src;
reg [7:0]   mode_chose_src;


/////////////////////////////////VIO��������//////////////////////////////
wire                            SW_VIO;
wire  [7:0]                     mode_chose_VIO;
wire  [SPI_RECE_WITH-1:0]       send_data_VIO;
wire  [4:0]                     cfg_sta_VIO;


VIO_U_XND4351 VIO_U_GX122 (
  .clk(clk_i),                // input wire clk
  .probe_in0(monitor0_i),    // input wire [0 : 0] probe_in0
  .probe_in1(monitor1_i),    // input wire [0 : 0] probe_in0
  .probe_in2({recive_data_reg0_o[15:3],10'b1001110001}),    // input wire [0 : 0] probe_in0
  .probe_in3(cfg_sta_VIO),    // input wire [0 : 0] probe_in0
  .probe_out0(SW_VIO),  // output wire [0 : 0] probe_out1  
  .probe_out1(mode_chose_VIO),  // output wire [0 : 0] probe_out1
  .probe_out2(send_data_VIO)
);

//-------����--------
always@(posedge clk_i or negedge rst_i)   
begin 
    if(!rst_i)begin
      mode_chose_src <= 8'd0; 
      send_data0_i_src<= 32'd0; 
       end
    else if(SW_VIO)
       begin
      mode_chose_src <= mode_chose_VIO; 
      send_data0_i_src<= send_data_VIO; 
       end
    else begin
      mode_chose_src <= mode_chose; 
      send_data0_i_src<= send_data_reg0_i; 
    end
end

////////////////////////////////////////////////////////////////////

wire spi_start;
wire [SPI_SEND_WITH-1:0] spi_send_data;
wire spi_trans_end;
wire [SPI_RECE_WITH-1:0] spi_rece_data;
wire spi_busy;

 GX122_SPI_MASTER	       
#(
  .SPI_SEND_WITH         ( SPI_SEND_WITH ),
  .SPI_RECE_WITH         ( SPI_RECE_WITH ),
  .CS_BEFOR_DELY         ( CS_BEFOR_DELY) ,  
  .CS_END_DELY           ( CS_END_DELY  ) ,  
  .CPOL                  ( CPOL  ) , 
  .CPHA                  ( CPHA  ) , 
  .MOSI_IDLE_STATE       ( MOSI_IDLE_STATE)  
)
 
 GX122_SPI_MASTER(
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

 GX122_SPI_FUNCTION	
 #( 
  .SPI_SEND_WITH            ( SPI_SEND_WITH ),
  .SPI_RECE_WITH            ( SPI_RECE_WITH ),
  
  .REG_CFG_NUM_INIT         ( REG_CFG_NUM_INIT) ,  
  .REG_CFG_NUM_WRITE_PRE0   ( REG_CFG_NUM_WRITE_PRE0  ) ,  
  .REG_CFG_NUM_WRITE_PRE1   ( REG_CFG_NUM_WRITE_PRE1  ) , 
  .REG_CFG_NUM_READ_PRE0   ( REG_CFG_NUM_READ_PRE0  ) ,
   
  .SPI_INTERVALS1           ( SPI_INTERVALS1)  ,
  .INITIAL_DELAY            ( INITIAL_DELAY)  ,
  
  .CHEAK_DATA_EN            ( CHEAK_DATA_EN)  ,  
  .INIT_REG_EN              ( INIT_REG_EN)  

)
 
 GX122_SPI_FUNCTION(
		.clk                (clk_i), 			
		.reset              (rst_i), 		
        .mode_chose         (mode_chose_src),        
        
		.send_data          (send_data0_i_src   ), 
		.recive_data        (recive_data_reg0_o ), 
		.cfg_sta            (cfg_sta_VIO  ),

		.spi_start_o        (spi_start), 
		.spi_send_data_o    (spi_send_data), 
		.spi_end_i          (spi_trans_end), 		
		.spi_rece_data_i    (spi_rece_data)
		);
		
endmodule