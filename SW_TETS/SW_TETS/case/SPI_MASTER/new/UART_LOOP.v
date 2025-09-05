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
            .CLK_FRE(50),         //时钟频率，默认时钟频率为50MHz
            .DATA_WIDTH(DATA_WIDTH),       //有效数据位，缺省为8位
            .PARITY_ON(PARITY_ON),        //校验位，1为有校验位，0为无校验位，缺省为0
            .PARITY_TYPE(PARITY_TYPE),      //校验类型，1为奇校验，0为偶校验，缺省为偶校验
            .BAUD_RATE(BAUD_RATE)      //波特率，缺省为9600
    ) u_uart_rx
    (
        .i_clk_sys(i_clk_sys),         //系统时钟
        .i_rst_n(i_rst_n),             //全局异步复位,低电平有效
        .i_uart_rx(i_uart_rx),         //UART输入
        .o_uart_data(uart_rx_data),    //UART接收数据
        .o_ld_parity(o_ld_parity),     //校验位检验LED，高电平位为校验正确
        .o_rx_done(rx_end)            //UART数据接收完成标志
    );
    
    uart_tx
    #(
        .CLK_FRE(50),                   //时钟频率，默认时钟频率为50MHz
        .DATA_WIDTH(DATA_WIDTH),        //有效数据位，缺省为8位
        .PARITY_ON(PARITY_ON),          //校验位，1为有校验位，0为无校验位，缺省为0
        .PARITY_TYPE(PARITY_TYPE),      //校验类型，1为奇校验，0为偶校验，缺省为偶校验
        .BAUD_RATE(BAUD_RATE)           //波特率，缺省为9600
    ) u_uart_tx
    (   .i_clk_sys      (i_clk_sys),       //系统时钟
        .i_rst_n        (i_rst_n),         //全局异步复位
        .i_data_tx      (uart_tx_data),    //传输数据输入
        .i_data_start   (tx_start),        //传输数据有效
        .o_uart_tx_data (o_uart_tx),       //UART输出
        .o_uart_tx_end  (uart_tx_end)      //UART输出
        
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

