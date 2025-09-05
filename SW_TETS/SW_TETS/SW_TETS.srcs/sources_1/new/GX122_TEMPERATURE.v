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
 //-------------------数据位宽配置配置----------------
parameter  SPI_SEND_WITH             = 16,                // 发送数据位宽
parameter  SPI_RECE_WITH             = 16,                // 接收数据位宽

//-------------------SPI通讯模式配置------------------
parameter  CPOL                      =   1,                // CPOL=0:serial clock low when idle; CPOL=1:serial clock high when idle
parameter  CPHA                      =   0,                // CPHA=0 capture serial data at 1st edge; CPHA=1: capture serial data at 2nd edge

 //-------------------各模式寄存器数目配置-------------
parameter  REG_CFG_NUM_INIT          =   1,               // 初始化总共需要配置的寄存器数量
parameter  REG_CFG_NUM_WRITE_PRE0    =   1,               // 写第一类预设模式0的寄存器数量
parameter  REG_CFG_NUM_WRITE_PRE1    =   1,               // 写第二类预设模式1的寄存器数量
parameter  REG_CFG_NUM_READ_PRE0     =   1,               // 读预设模式1的寄存器数量

//----------------------参数配置-----------------------
parameter  SPI_INTERVALS1            =   1000,          // 寄存器之间的延时 （延时大小为：1/clk*SPI_INTERVALS）
parameter  INITIAL_DELAY             =   0,             // 复位后延时多久开始配置寄存器 ,初始化延时（延时大小为：1/clk*INITIAL_INTERVALS1）12500000
parameter  CS_BEFOR_DELY             =   0   ,          // CS_BEFOR_DELY
parameter  CS_END_DELY               =   0   ,          //CS_END_DELY 
parameter  MOSI_IDLE_STATE           =   1'dZ,              //idle state of spi mosi
parameter  MASTER_SPI_FREQUENCY      =   100,             // 信号频率分频系数
 
//-----------------------功能开关配置------------------     
parameter  CHEAK_DATA_EN             =   0,               // 读功能开启，用于校验读写一致。（开关：）
parameter  INIT_REG_EN               =   0                // 需不需要做初始化寄存器配置。1-开，0-关（开关：）

)

(
//时钟及复位
input   wire                                  clk_i, 
input   wire                                  rst_i,
//模式配置
input   wire     [7:0]                        mode_chose,
 //物理接口 
output  wire                                  spi_cs_o,
output  wire                                  spi_sclk_o,
input   wire                                  spi_miso_i,
output  wire                                  spi_mosi_o,                       
output  wire                                  LE,  
//硬件反馈输入状态监控                       
input   wire                                  monitor0_i,
input   wire                                  monitor1_i,
//输入寄存器配置
input   wire       [SPI_SEND_WITH-1:0]        send_data_reg0_i,
//数据输出
output  wire       [SPI_SEND_WITH-1:0]        recive_data_reg0_o
//其他

    );
 
reg  [SPI_SEND_WITH-1:0]     send_data0_i_src;
reg [7:0]   mode_chose_src;


/////////////////////////////////VIO测试区域//////////////////////////////
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

//-------输入--------
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