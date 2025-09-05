`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/04 09:22:37
// Design Name: 
// Module Name: UART_LOOP
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
module UART
#(
 //-------------------����λ����������----------------
    parameter DATA_WIDTH                 = 8,          
    
//-------------------UARTͨѶģʽ����------------------    
    parameter PARITY_ON                  = 1'd0,              //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
    parameter PARITY_TYPE                = 1'd1,              //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
 
 //-------------------��ģʽ�Ĵ�����Ŀ����-------------
    parameter  REG_CFG_NUM_INIT          =   4,               // ��ʼ���ܹ���Ҫ���õļĴ�������
    parameter  REG_CFG_NUM_WRITE_PRE0    =   1,               // д��һ��Ԥ��ģʽ0�ļĴ�������
    parameter  REG_CFG_NUM_WRITE_PRE1    =   1,               // д�ڶ���Ԥ��ģʽ1�ļĴ�������
    parameter  REG_CFG_NUM_READ_PRE0     =   1,               // ��Ԥ��ģʽ1�ļĴ�������

 //----------------------��������----------------------- 
    parameter CLK_FRE                    = 50000000,                //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
    parameter BAUD_RATE                  = 16'd9600,          //�����ʣ�ȱʡΪ9600

//-----------------------���ܿ�������------------------   
    parameter  CHEAK_DATA_EN             =   0,               // �����ܿ���������У���дһ�¡������أ���
    parameter  INIT_REG_EN               =   0                // �費��Ҫ����ʼ���Ĵ������á�1-����0-�أ����أ���)
)
(
//ʱ�Ӽ���λ
    input  wire                                i_clk_sys,
    input                                       i_rst_n,
//ģʽ
    input   wire     [7:0]                     i_mode_chose,   
 //����ӿ�     
    input                                       i_uart_rx,
    output o_uart_tx,
 //Ӳ����������״̬���    
    
//����Ĵ�������
   input   wire       [DATA_WIDTH-1:0]         send_data_reg0_i,
//�������
   output  wire       [DATA_WIDTH-1:0]         recive_data_reg0_o,
//����
    output                                     o_verify_flg
    );
    
    wire tx_start;
    wire [DATA_WIDTH-1 : 0]uart_tx_data; 
       
    wire rx_end;    
    wire[DATA_WIDTH-1 : 0] uart_rx_data;
    wire uart_tx_end;
    
/////////////////////////////////VIO��������//////////////////////////////

reg   [7:0]                     mode_chose_src;
reg   [DATA_WIDTH-1:0]          send_data0_i_src;

wire                            SW_VIO;
wire  [7:0]                     mode_chose_VIO;
wire  [DATA_WIDTH-1:0]          send_data_VIO;
wire  [4:0]                     cfg_sta_VIO;


 VIO_UART_DEMO U_VIO_UART_DEMO(
  .clk      (i_clk_sys),                // input wire clk
  .probe_in0(uart_rx_data),    // input wire [0 : 0] probe_in0
  .probe_in1(cfg_sta_VIO),    // input wire [0 : 0] probe_in0
  .probe_out0(SW_VIO),  // output wire [0 : 0] probe_out1  
  .probe_out1(mode_chose_VIO),  // output wire [0 : 0] probe_out1
  .probe_out2(send_data_VIO)
);

always@(posedge i_clk_sys or negedge i_rst_n)   
begin 
    if(!i_rst_n)begin
      mode_chose_src <= 8'd0; 
      send_data0_i_src<= 32'd0; 
       end
    else if(SW_VIO)
       begin
      mode_chose_src <= mode_chose_VIO; 
      send_data0_i_src<= send_data_VIO; 
       end
    else begin
      mode_chose_src <= i_mode_chose; 
      send_data0_i_src<= send_data_reg0_i; 
    end
end

/////////////////////////////////////////////////////////////////////////


UART_MASTER_DRIVE 
    #(
        .CLK_FRE(50),                  
        .DATA_WIDTH(DATA_WIDTH),       
        .PARITY_ON(PARITY_ON),         
        .PARITY_TYPE(PARITY_TYPE),     
        .BAUD_RATE(BAUD_RATE)          
    ) 

U_UART_MASTER_DRIVE
(  .i_clk_sys           (i_clk_sys),   
   .i_rst_n             (i_rst_n),
        
   .i_uart_rx           (i_uart_rx),
   .o_uart_rx_data      (uart_rx_data), 
   .o_rx_end             (rx_end),   
   .o_verify_flg         (o_verify_flg), 
    
   .o_uart_tx            (o_uart_tx), 
   .i_uart_tx_data       (uart_tx_data),      
   .o_tx_start           (tx_start),
   .o_uart_tx_end        (uart_tx_end)  
   
   );

  UART_MASTER_FUNCTION   
      #(
        .DATA_WIDTH(DATA_WIDTH),                       
        .PARITY_ON(PARITY_ON),         
        .PARITY_TYPE(PARITY_TYPE),     
        .REG_CFG_NUM_INIT(REG_CFG_NUM_INIT),
         .REG_CFG_NUM_WRITE_PRE0(REG_CFG_NUM_WRITE_PRE0),       
         .REG_CFG_NUM_WRITE_PRE1(REG_CFG_NUM_WRITE_PRE1), 
         .REG_CFG_NUM_READ_PRE0(REG_CFG_NUM_READ_PRE0),  
         .CLK_FRE(CLK_FRE),                  
         .BAUD_RATE(BAUD_RATE),     
         .INIT_REG_EN(INIT_REG_EN)           
    ) 
  
  
  U_UART_MASTER_FUNCTION
  (   .i_clk_sys          (i_clk_sys),     
      .i_rst_n            (i_rst_n),    
      
      .i_mode_chose       (mode_chose_src), 
	  .i_send_data        (send_data0_i_src), 
	  .cfg_sta            (cfg_sta_VIO  ),
	  
      
      .o_send_data        (uart_tx_data),   
      .o_start            (tx_start),     
      .i_end              (uart_tx_end),
      
      .i_rece_data        (uart_rx_data),   
      .i_rx_end            (rx_end)    
     );
     
     
     

endmodule

