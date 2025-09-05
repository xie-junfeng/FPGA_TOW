`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/04 09:25:30
// Design Name: 
// Module Name: UART_LOOP_TB
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

module TB_UART_MASTER(
    );
    
    reg clk_sys;
    reg rst_n;
    reg uart_in;
    wire uart_out;
    wire parity;
   reg  [7:0]mode_chose; 
    wire data;
    UART U_UART(
        .i_clk_sys(clk_sys),
        .i_rst_n(rst_n),
        
         .i_mode_chose(mode_chose),
                
        .i_uart_rx(data),
        .o_uart_tx(data),
        .o_verify_flg(parity)
        );
        
        
    initial begin
        clk_sys = 1'b0;
        rst_n = 1'b0;
        uart_in = 1'b1;
    end
     //15MHz ±÷”
   initial begin
   mode_chose = 8'b0      ;
//   #500
   forever begin
    #500000   mode_chose = 8'd1     ;
//    #2500000     mode_chose = 8'd2      ;
//    #2500000     mode_chose = 8'd3      ;
//    #2500000     mode_chose = 8'd4      ;
   end
   end 
    
    
    
    always #10 clk_sys = ~clk_sys;
    
    localparam ELEMENT_TIME = 104160;
    reg [7:0] DATA = 8'hAC;
    
    
    
    
    
    initial begin
        #100 rst_n = 1'b1;
        #20000;
        
        uart_in = 1'b0;
        #ELEMENT_TIME
        uart_in = DATA[0];
        #ELEMENT_TIME
        uart_in = DATA[1];
        #ELEMENT_TIME
        uart_in = DATA[2];
        #ELEMENT_TIME
        uart_in = DATA[3];
        #ELEMENT_TIME
        uart_in = DATA[4];
        #ELEMENT_TIME
        uart_in = DATA[5];
        #ELEMENT_TIME
        uart_in = DATA[6];
        #ELEMENT_TIME
        uart_in = DATA[7];
        #ELEMENT_TIME
        uart_in = 1'b1;
        #ELEMENT_TIME
        uart_in = 1'b1;
    end

endmodule

