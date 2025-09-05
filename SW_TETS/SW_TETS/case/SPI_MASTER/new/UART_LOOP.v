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
module uart_loop(
    input i_clk_sys,
    input i_rst_n,
    input i_uart_rx,
    output o_uart_tx,
    output o_ld_parity
    );
    
    localparam DATA_WIDTH = 8;
    localparam BAUD_RATE = 9600;
    localparam PARITY_ON = 1'd0;
    localparam PARITY_TYPE = 1'd1;
    

    wire tx_start;
    wire [DATA_WIDTH-1 : 0]uart_tx_data; 
       
    wire rx_end;    
    wire[DATA_WIDTH-1 : 0] uart_rx_data;
    wire uart_tx_end;
    
    uart_rx 
    #(
            .CLK_FRE(50),         //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
            .DATA_WIDTH(DATA_WIDTH),       //��Ч����λ��ȱʡΪ8λ
            .PARITY_ON(PARITY_ON),        //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
            .PARITY_TYPE(PARITY_TYPE),      //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
            .BAUD_RATE(BAUD_RATE)      //�����ʣ�ȱʡΪ9600
    ) u_uart_rx
    (
        .i_clk_sys(i_clk_sys),         //ϵͳʱ��
        .i_rst_n(i_rst_n),             //ȫ���첽��λ,�͵�ƽ��Ч
        .i_uart_rx(i_uart_rx),         //UART����
        .o_uart_data(uart_rx_data),    //UART��������
        .o_ld_parity(o_ld_parity),     //У��λ����LED���ߵ�ƽλΪУ����ȷ
        .o_rx_done(rx_end)            //UART���ݽ�����ɱ�־
    );
    
    uart_tx
    #(
        .CLK_FRE(50),                   //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
        .DATA_WIDTH(DATA_WIDTH),        //��Ч����λ��ȱʡΪ8λ
        .PARITY_ON(PARITY_ON),          //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
        .PARITY_TYPE(PARITY_TYPE),      //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
        .BAUD_RATE(BAUD_RATE)           //�����ʣ�ȱʡΪ9600
    ) u_uart_tx
    (   .i_clk_sys      (i_clk_sys),       //ϵͳʱ��
        .i_rst_n        (i_rst_n),         //ȫ���첽��λ
        .i_data_tx      (uart_tx_data),    //������������
        .i_data_start   (tx_start),        //����������Ч
        .o_uart_tx_data (o_uart_tx),       //UART���
        .o_uart_tx_end  (uart_tx_end)      //UART���
        
        );

    UART_MASTER_FUNCTION   U_UART_MASTER_FUNCTION
    (   .clk_i              (i_clk_sys),     
        .reset_i            (i_rst_n),    
        .uart_tx_start_o    (tx_start),       
        .uart_data_tx_o     (uart_tx_data),       
        .uart_tx_end_i      (uart_tx_end),
        .uart_rx_data_i     (uart_rx_data)      
       );



endmodule

