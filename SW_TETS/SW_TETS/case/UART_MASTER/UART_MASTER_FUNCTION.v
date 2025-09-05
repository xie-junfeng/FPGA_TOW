`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/07 16:27:21
// Design Name: 
// Module Name: UART_MASTER_FUNCTION
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
module UART_MASTER_FUNCTION
#(
    parameter CLK_FRE            =   50000000,                //时钟频率，默认时钟频率为50MHz
    parameter BAUD_RATE          =   9600,                    //波特率，缺省为9600
    parameter SPI_INTERVALS      =   CLK_FRE/BAUD_RATE   ,  // CLK_FRE/BAUD_RATE
    parameter REG_CFG_NUM        =   5,                     // 总共需要配置的寄存器数量
    parameter READ_EN            =   0      ,                 // 读功能开启，用于校验读写一致。
    parameter READ_DATA_EN       =   0      ,                 // 读功能开启，用于校验读写一致。
    parameter VIO_EN             =   0      ,                 // VIO功能开启和关闭，用于程序下载1和仿真0。
    
    parameter TX_DATA_WIDTH      =   8     ,    
    parameter RX_DATA_WIDTH      =   8     
)
(
    input  wire                                clk_i                                  , 
    input  wire                                 reset_i                               , //低电平复位
   
    output  reg                                 uart_tx_start_o                        , // 发送启动信号
    (*mark_debug = "true"*)output  reg        [ TX_DATA_WIDTH-1:0]   uart_data_tx_o   , // device initialization done active high indication
    input  wire                                uart_tx_end_i                           , // normally indicate a non supported devcice
    input  wire   [ RX_DATA_WIDTH-1:0]         uart_rx_data_i                                      
    );
   
//////////////////////////////////UART发送配置及格式，单包数据设置///////////////////////////////////////
/////////////////////////////////////具体根据器件手册或自定义设置//////////////////////////////////////////
//

//UART发送配置（不用回读）
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data00    = 8'h08 ;
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data01    = 8'h05 ;
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data02    = 8'h02 ;
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data03    = 8'h03 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data04    = 8'h04 ;     
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data05    = 8'h05 ;   
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data06    = 8'h06 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data07    = 8'h07 ;    
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data08    = 8'h08 ;    
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data09    = 8'h09 ;    
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0A    = 8'h0a ;   
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0B    = 8'h0b ;   
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0C    = 8'h0c ;   
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0D    = 8'h0d ;  
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0E    = 8'h0e ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data0F    = 8'h0f ;  
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data10    = 8'h10 ;  
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data11    = 8'h11 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data12    = 8'h12 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data13    = 8'h13 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data14    = 8'h14 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data15    = 8'h15 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data16    = 8'h16 ; 
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data17    = 8'h17 ;    
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data18    = 8'h18 ;    
    localparam      [TX_DATA_WIDTH-1:0]          Reg_data19    = 8'h19 ;
                                        
 //中间变量             
    reg     [ 4:0]          cfg_sta             ;
    reg     [31:0]          delay_cnt           ;
    reg     [TX_DATA_WIDTH:0]          romdata ;
    reg     [ 15:0]          romaddr             ;
    reg     [RX_DATA_WIDTH-1:0]       read_data;
    reg                                 down;
   (* ram_style="distributed" *)
    reg     [TX_DATA_WIDTH-1:0]      cfg_rom[REG_CFG_NUM-1:0];
     
    always@(posedge clk_i) begin
        romdata    <=  cfg_rom[romaddr]         ;
    end
  
 //////////////////////////////////根据数据格式编写///////////////////////////////////////   
    initial begin
        cfg_rom[  0] = {Reg_data01};
        cfg_rom[  1] = {Reg_data05}; 
        cfg_rom[  2] = {Reg_data06}; 
        cfg_rom[  3] = {Reg_data07};        
        cfg_rom[  4] = {Reg_data08}; 
        cfg_rom[  5] = {Reg_data09}; 
        cfg_rom[  6] = {Reg_data0A};
        cfg_rom[  7] = {Reg_data0B}; 
        cfg_rom[  8] = {Reg_data0C}; 
        cfg_rom[  9] = {Reg_data0D};        
        cfg_rom[ 10] = {Reg_data0E}; 
        cfg_rom[ 11] = {Reg_data0F}; 
        cfg_rom[ 12] = {Reg_data10};
        cfg_rom[ 13] = {Reg_data11};
        cfg_rom[ 14] = {Reg_data12}; 
        cfg_rom[ 15] = {Reg_data13};        
        cfg_rom[ 16] = {Reg_data14}; 
        cfg_rom[ 17] = {Reg_data15}; 
        cfg_rom[ 18] = {Reg_data16};
        cfg_rom[ 19] = {Reg_data17}; 
        cfg_rom[ 20] = {Reg_data18}; 
        cfg_rom[ 21] = {Reg_data19};        
        cfg_rom[ 22] = {Reg_data02}; 
        cfg_rom[ 23] = {Reg_data03};
        cfg_rom[ 24] = {Reg_data04};          
        cfg_rom[ 25] = {Reg_data00};          
        end
        
//////////////////////////////////测试开始控制///////////////////////////////////////
wire start;
 vio_start your_instance_name (
  .clk(clk_i),                // input wire clk
  .probe_out0(start)  // output wire [0 : 0] probe_out0
); 
reg start_raise;
reg start_reg0;
reg start_reg1;
      always@(posedge clk_i) begin
        if (!reset_i) begin
            start_reg0    <=  1'b0    ;
            start_reg1    <=  1'b0    ;
        end else begin
            start_reg0    <=  start;
            start_reg1    <=  start_reg0    ;
        end
    end  
  
      always@(posedge clk_i) begin
        if (!reset_i) begin
            start_raise    <=  1'b0    ;
        end else begin
             start_raise =(~start_reg1 & start_reg0 );
        end
    end  

//////////////////////////////////寄存器发送之间的顺序，与帧协议有关///////////////////////////////////////
    always@(posedge clk_i) begin
        if (!reset_i) begin
            cfg_sta                     <=  5'd0;
            delay_cnt                   <=  32'd0;
            romaddr                     <=  16'd0;
            uart_tx_start_o                 <=  1'b0;
            uart_data_tx_o             <=  24'd0;
            read_data                   <=  16'd0;
            down                        <=  1'd0;
        end else begin
            case(cfg_sta)
                5'd0:begin
                    if(VIO_EN)begin
                         if (start_raise) begin
                             cfg_sta         <=  4'd1 ;
                             delay_cnt       <=  32'd0;
                         end 
                     else begin
                         cfg_sta         <=  4'd0 ;
                     end
                     end    
                     else begin
                         cfg_sta         <=  4'd1 ;
                         delay_cnt       <=  32'd0;
                     end
                end
                5'd1:begin 
                    uart_data_tx_o <= romdata  ;
                    if (delay_cnt >= SPI_INTERVALS) begin 
                        delay_cnt <=  32'd0   ;
                        cfg_sta <=  5'd5    ;
                        uart_tx_start_o   <=  1'b1    ;
                    end else begin
                        cfg_sta         <=  5'd1    ;
                        delay_cnt       <=  delay_cnt + 1'b1;
                    end
                end
                5'd5:begin
                    uart_tx_start_o           <=  1'b0    ;
                    if (uart_tx_end_i) begin
                        if (romaddr == (REG_CFG_NUM-1))  begin
                            cfg_sta     <=  5'd6    ;
                            romaddr     <=  16'd0    ;
                        end 
                        else begin
                            romaddr         <=  romaddr + 16'b1  ;
                            cfg_sta         <=  5'd31   ;
                        end
                    end 
                    else begin
                        cfg_sta         <=  5'd5    ;
                        end
                 end
  
                 5'd31:begin 
                   if (delay_cnt >=SPI_INTERVALS) begin
                         delay_cnt <=  32'd0   ;
                         cfg_sta   <=  5'd16    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  5'd31    ;
                     end
                  end   
                
                5'd16:begin
                    cfg_sta <=  5'd17    ;
                    
                    if(READ_EN)begin
                        uart_tx_start_o <=  1'b1    ;
//                        spi_send_data_o <= {READ_EN,23'd0};
                        uart_data_tx_o <= {READ_EN,cfg_rom[romaddr-1][(TX_DATA_WIDTH-2):16],Reg_data00};
                    end
                    else begin
                        uart_data_tx_o <= uart_data_tx_o;
                    end
                end
                
                5'd17:begin
                    if(READ_EN)begin
                        uart_tx_start_o           <=  1'b0    ;
                        if(uart_tx_end_i) begin
                            read_data <=  uart_rx_data_i   ;                 
                            cfg_sta <=  5'd18   ; 
                        end else begin
                            cfg_sta <=  5'd17    ;
                            end   
                     end
                       else begin
                        cfg_sta <=  5'd18    ;
                       
                       end
                end                
 
                 5'd18:begin
                    if(READ_DATA_EN)begin
                        if(read_data==cfg_rom[romaddr-1'd1][(TX_DATA_WIDTH-1):0]) begin             
                            cfg_sta         <=  5'd1   ; 
                        end 
                        else begin
                            cfg_sta         <=  5'd1   ; 
                            romaddr         <=  romaddr -1'b1  ;
                        end
                    end
                    else begin
                     if(VIO_EN)begin
                        if(start_raise) begin
                            cfg_sta         <=  5'd1  ; 
                        end
                        else begin
                            cfg_sta         <=  5'd18  ;
                        end
                        end
                      else begin
                        cfg_sta         <=  5'd1  ; 
                      end 
                      end
                end   
                5'd6:begin
                    down             <=  1'd1    ;
                    if(VIO_EN)begin
                        cfg_sta          <=  4'd0 ;
                    end
                end                
                default:begin
                    cfg_sta               <=  5'd0    ;
                    delay_cnt             <=  32'd0   ;
                    romaddr               <=  8'd0    ;
                    uart_tx_start_o       <=  1'b0    ;
                    uart_data_tx_o        <=  32'd0   ;
                end
            endcase
        end
    end
    
endmodule

