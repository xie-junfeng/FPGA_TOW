`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/21 08:59:12
// Design Name: 
// Module Name: U_UART_MASTER_DRIVE
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


module UART_MASTER_DRIVE
#(
    parameter CLK_FRE = 50,         //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
    parameter DATA_WIDTH = 8,       //��Ч����λ��ȱʡΪ8λ
    parameter PARITY_ON = 1'd0,        //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
    parameter PARITY_TYPE = 1'd0,      //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
    parameter BAUD_RATE = 16'd9600      //�����ʣ�ȱʡΪ9600
)

(
    input         i_clk_sys,
    input         i_rst_n,

    input         i_uart_rx,
    output [7:0]  o_uart_rx_data,       
    output        o_rx_end,
    output        o_verify_flg, 
    
    output        o_uart_tx,        
    input  [7:0]  i_uart_tx_data,
    input         o_tx_start,      
    output        o_uart_tx_end
    );
        
    
    uart_rx 
    #(
            .CLK_FRE(50),         
            .DATA_WIDTH(DATA_WIDTH),       
            .PARITY_ON(PARITY_ON),        
            .PARITY_TYPE(PARITY_TYPE),
            .BAUD_RATE(BAUD_RATE)     
    ) u_uart_rx
    (
        .i_clk_sys(i_clk_sys),       
        .i_rst_n(i_rst_n),           
        .i_uart_rx(i_uart_rx),       
        .o_uart_data(o_uart_rx_data),  
        .o_verify_flg(o_verify_flg), 
        .o_rx_done(o_rx_end)           
    );
    
    uart_tx
    #(
        .CLK_FRE(50),                  
        .DATA_WIDTH(DATA_WIDTH),       
        .PARITY_ON(PARITY_ON),         
        .PARITY_TYPE(PARITY_TYPE),     
        .BAUD_RATE(BAUD_RATE)          
    ) u_uart_t
    (   .i_clk_sys      (i_clk_sys),   
        .i_rst_n        (i_rst_n),     
        .i_data_tx      (i_uart_tx_data),
        .i_data_start   (o_tx_start),    
        .o_uart_tx_data (o_uart_tx),   
        .o_uart_tx_end  (o_uart_tx_end)  
        
        );    

    
    
endmodule
