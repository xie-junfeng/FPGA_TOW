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
 //-------------------数据位宽配置配置----------------
    parameter DATA_WIDTH                 = 8,      
    parameter SEND_WITH                  = DATA_WIDTH,       
    parameter RECE_WITH                  = DATA_WIDTH,       
//-------------------UART通讯模式配置------------------    
    parameter PARITY_ON                  = 1'd0,              //校验位，1为有校验位，0为无校验位，缺省为0
    parameter PARITY_TYPE                = 1'd1,              //校验类型，1为奇校验，0为偶校验，缺省为偶校验
 
 //-------------------各模式寄存器数目配置-------------
    parameter  REG_CFG_NUM_INIT          =   1,               // 初始化总共需要配置的寄存器数量
    parameter  REG_CFG_NUM_WRITE_PRE0    =   1,               // 写第一类预设模式0的寄存器数量
    parameter  REG_CFG_NUM_WRITE_PRE1    =   1,               // 写第二类预设模式1的寄存器数量
    parameter  REG_CFG_NUM_READ_PRE0     =   1,               // 读预设模式1的寄存器数量

 //----------------------参数配置----------------------- 
    parameter CLK_FRE                    = 50000000,                //时钟频率，默认时钟频率为50MHz
    parameter BAUD_RATE                  = 16'd9600,          //波特率，缺省为9600

//-----------------------延时配置----------------------  
parameter  SPI_INTERVALS1                =   CLK_FRE/BAUD_RATE,                              // 寄存器之间的延时 （延时大小为：1/clk*SPI_INTERVALS）
parameter  INITIAL_DELAY                 =   0,    

//-----------------------功能开关配置------------------   
    parameter  CHEAK_DATA_EN             =   0,               // 读功能开启，用于校验读写一致。（开关：）
    parameter  INIT_REG_EN               =   0                // 需不需要做初始化寄存器配置。1-开，0-关（开关：）)
)

(
    input  wire                                i_clk_sys, 
    input  wire                                i_rst_n,    
    input   wire   [7:0]                       i_mode_chose,  //模式选择，用于不同模式选择的信号端口，主要用于调试，后期确定可写成参数形式
   //该输入接口主要用于VIO调试
    input   wire   [SEND_WITH-1:0]             i_send_data , 
    output  reg    [RECE_WITH-1:0]             o_recive_data ,     
    (*mark_debug = "true"*)output reg [ 7:0]  cfg_sta  ,   

    output  reg    [SEND_WITH-1:0]             o_send_data, // 发送的数据
    output  reg                                o_start      ,               // 发送启动信号
    input  wire                                i_end,                       // 发送的结束信号
   
    (*mark_debug = "true"*)input  wire   [ RECE_WITH-1:0]         i_rece_data, 
    input  wire                                 i_rx_end                //接收的数据                      
    );

//////////////////////////////////VIO控制区域调试区///////////////////////////////////////// 


//////////////////////////////////////////////////////////////////////////////////////////// 


//////////////////////////////通过数据有效位边沿触发的方式检测模式变化///////////////////
reg      mode_chose_chage;
reg [7:0]mode_chose_reg0=8'd0;
reg [7:0]mode_chose_reg1=8'd0;

    always@(posedge i_clk_sys or negedge i_rst_n) begin
     if (!i_rst_n) begin
         mode_chose_reg0    <=  8'b0    ;
         mode_chose_reg1    <=  8'b0    ;
     end else begin
         mode_chose_reg0    <=  i_mode_chose;
         mode_chose_reg1    <=  mode_chose_reg0    ;
     end
    end
    
    always@(posedge i_clk_sys or negedge i_rst_n) begin
    if (!i_rst_n) begin
        mode_chose_chage  <=  1'b0    ;
    end 
    else begin 
        if(mode_chose_reg1!=mode_chose_reg0)begin
            mode_chose_chage  <=  1'b1  ;
         end
         else begin
            mode_chose_chage  <=  1'b0  ;
         end
    end
    end

///////////////////////////////////////// 寄存器值预设//////////////////////////////////////                                            
//####################################模式一：初始化配置的寄存器值##########################
reg     [SEND_WITH-1:0]          romdata_init   ;
reg     [ 15:0]                   romaddr_init   ;
(* ram_style="distributed" *)
reg     [SEND_WITH-1:0]         cfg_rom_init[REG_CFG_NUM_INIT-1:0];

initial begin
//    cfg_rom_init[ 0] = 8'h01;
//    cfg_rom_init[ 1] = 8'h02;
//    cfg_rom_init[ 2] = 8'h34; 
//    cfg_rom_init[ 3] = 8'h03; 
//    cfg_rom_init[ 4] = 8'h42;        
//    cfg_rom_init[ 5] = 8'hE9; 
//    cfg_rom_init[ 6] = 8'h00;    

    cfg_rom_init[ 0] = 8'h01;  //用于测试  
    cfg_rom_init[ 1] = 8'h02;  //用于测试  
    cfg_rom_init[ 2] = 8'h04;  //用于测试  
    cfg_rom_init[ 3] = 8'h08;  //用于测试   
    cfg_rom_init[ 4] = 8'h10;  //用于测试          
    cfg_rom_init[ 5] = 8'h20;  //用于测试   
    cfg_rom_init[ 6] = 8'h40;  //用于测试    
 
end  
     
always@(posedge i_clk_sys) begin
    romdata_init    <=  cfg_rom_init[romaddr_init]         ;
end   

//####################################模式二：预设_固定模式写入0################################## 
reg     [SEND_WITH-1:0]          romdata_write_mode0 ;
reg     [ 15:0]                   romaddr_write_mode0   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_write_mode0[REG_CFG_NUM_WRITE_PRE0-1:0];  
 initial begin
     cfg_rom_write_mode0[ 0] = 8'h04;  
      
//    cfg_rom_write_mode0[ 0] = 32'h00000080;  //用于测试  
     end  
     
always@(posedge i_clk_sys) begin
    romdata_write_mode0    <=  cfg_rom_write_mode0[romaddr_write_mode0]         ;
end     

//####################################模式二：预设_固定模式写入1################################## 
reg     [SEND_WITH-1:0]          romdata_write_mode1 ;
reg     [ 15:0]                   romaddr_write_mode1   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_write_mode1[REG_CFG_NUM_WRITE_PRE1-1:0];  
 initial begin
//     cfg_rom_write_mode1[0] = 8'h01; 
     
    cfg_rom_write_mode1[ 0] = 8'h11;   //用于测试   
 end  
always@(posedge i_clk_sys) begin
    romdata_write_mode1    <=  cfg_rom_write_mode1[romaddr_write_mode1]         ;
end     

//####################################模式三：预设_固定读取模式################################## 
reg     [SEND_WITH-1:0]          romdata_read_mode0 ;
reg     [ 15:0]                      romaddr_read_mode0   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_read_mode0[REG_CFG_NUM_READ_PRE0-1:0];  
 initial begin
//    cfg_rom_read_mode0[ 0] = 8'h00;      
    
     cfg_rom_read_mode0[0] = 8'h01;  //用于测试  
 end  

always@(posedge i_clk_sys) begin
    romdata_read_mode0    <=  cfg_rom_read_mode0[romaddr_write_mode1]         ;
end   

///////////////////////////////////////////////////////////////////////////////////////////// 


////////////////////////////////////////模式状态机////////////////////////////////////////////
//注释：如需要优化资源消耗，可自行去掉用不到的模式             
 reg     [31:0]                            delay_cnt;
 reg     [RECE_WITH-1:0]                  read_data;   
 reg     [7:0]                             send_data_number;   

    always@(posedge i_clk_sys or negedge i_rst_n) begin                                           
        if (!i_rst_n) begin                                                               
            cfg_sta                     <=  5'd0;                                       
            delay_cnt                   <=  32'd0;
            romaddr_init                <=  16'd0;
            romaddr_write_mode0         <=  16'd0;
            romaddr_write_mode1         <=  16'd0;  
            romaddr_read_mode0         <=  16'd0; 
                                  
            o_start                     <=  1'b0;
            o_send_data                 <=  32'd0;
            read_data                   <=  16'd0;
            send_data_number            <=  8'd0;
        end else begin
            case(cfg_sta)
 //###############################################复位初始化等待延时####################################################//                   
 
                 8'd0:begin 
                   if (delay_cnt >=INITIAL_DELAY) begin
                         delay_cnt <=  32'd0   ;
                         if(INIT_REG_EN)begin
                            cfg_sta   <=  8'd2    ;
                         end
                         else begin
                            cfg_sta   <=  8'd1    ;
                         end
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd0    ;
                     end
                  end  
                  
 //#####################################################模式选择#######################################################//                   
                 8'd1:begin
                       send_data_number            <=  8'd0;
                       delay_cnt       <=  32'd0;
                       romaddr_init         <=  8'd0  ;
                       romaddr_write_mode0         <=  16'd0;
                       romaddr_write_mode1         <=  16'd0;  
                       romaddr_read_mode0         <=  16'd0;   
                                            
                       if(mode_chose_chage)begin
                        case(i_mode_chose)
                        8'd0:begin
                            cfg_sta         <=  8'd1 ;
                            end
                        8'd1:begin
                            cfg_sta         <=  8'd2 ;
                        end
                         8'd2:begin
                            cfg_sta         <=  8'd12 ;
                         end
                          8'd3:begin
                            cfg_sta         <=  8'd22 ;                           
                        end          
                           8'd4:begin
                            cfg_sta         <=  8'd32 ;                           
                        end                         
                            8'd5:begin
                            cfg_sta         <=  8'd42 ;                                                      
                        end 
                          8'd6:begin
                            cfg_sta         <=  8'd52 ;                                                                           
                        end   
                           8'd7:begin
                            cfg_sta         <=  8'd62 ;                                                                           
                        end                                                                   
                    default:begin
                        cfg_sta               <=  cfg_sta    ;
                        end                                                          
                        endcase
                       end
                       else begin
                              cfg_sta         <=  cfg_sta ;
                       end                                    
                end                 
                  
 //###############################################状态机2-7初始化寄存器配置####################################################//                 
                8'd2:begin 
                    o_send_data <= romdata_init  ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd3    ;
                end
 
                8'd3:begin
                      o_start           <=  1'b0    ;
                      if (i_end) begin
                          if (romaddr_init == (REG_CFG_NUM_INIT-1))  begin
                              cfg_sta     <=  8'd1    ;
                              romaddr_init     <=  16'd0    ;
                          end 
                          else begin
                              romaddr_init         <=  romaddr_init + 16'b1  ;
                              cfg_sta         <=  8'd4  ;
                          end
                      end 
                      else begin
                          cfg_sta         <=  8'd3    ;
                          end
                     end
                 
                 8'd4:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         if(CHEAK_DATA_EN)begin
                            cfg_sta   <=  8'd5 ;
                         end
                         else begin
                            cfg_sta   <=  8'd2 ;
                         end
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd4    ;
                     end
                  end  

                8'd5:begin
                        cfg_sta <=  8'd6    ;
                        o_start <=  1'b1 ;
                        o_send_data <= cfg_rom_init[romaddr_init-1];      //需要修改cfg_rom_init[romaddr-1]的读写控制为此次发送的数据需要修改读写控制位
                    end 
                
                8'd6:begin
                     o_start <=  1'b0    ;
                     if(i_rx_end) begin
                            read_data <=  i_rece_data   ;              
                            cfg_sta <=  8'd7   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd6    ;
                     end   
                end                
 
                 8'd7:begin   //用于开启回读读功能，在初始化配置完以后进行回读查验是否一致
                        if(read_data==cfg_rom_init[romaddr_init-1'd1][(SEND_WITH-1):0]) begin        //当CHEAK_DATA_EN=1时，需要修改W_DATA_WITH     
                            cfg_sta         <=  8'd8   ; 
                        end 
                        else begin
                            cfg_sta         <=  8'd7   ; 
                            romaddr_init         <=  romaddr_init -1'b1  ;
                        end
                end   
                 8'd8:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         cfg_sta   <=  8'd2    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd8    ;
                     end
                  end       
//###################################################################################################
              
                 
 //###########################################状态机12-18：固定模式写入0############################# 
                8'd12:begin 
                    o_send_data <= romdata_write_mode0  ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd13    ;
                end
 
                8'd13:begin
                      o_start           <=  1'b0    ;
                      if (i_end) begin
                          if (romaddr_write_mode0 == (REG_CFG_NUM_WRITE_PRE0-1))  begin
                              cfg_sta     <=  8'd1    ;
                              romaddr_write_mode0     <=  16'd0    ;
                          end 
                          else begin
                              romaddr_write_mode0         <=  romaddr_write_mode0 + 16'b1  ;
                              cfg_sta         <=  8'd14  ;
                          end
                      end 
                      else begin
                          cfg_sta         <=  8'd13    ;
                          end
                     end
                 
                 8'd14:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         if(CHEAK_DATA_EN)begin
                            cfg_sta   <=  8'd15 ;
                         end
                         else begin
                            cfg_sta   <=  8'd12 ;
                         end
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd14    ;
                     end
                  end  

                8'd15:begin
                        cfg_sta <=  8'd16    ;
                        o_start <=  1'b1 ;
                        o_send_data <= cfg_rom_write_mode0[romaddr_write_mode0-1];      //需要修改cfg_rom_init[romaddr-1]的读写控制为此次发送的数据需要修改读写控制位
                    end 
                
                8'd16:begin
                     o_start <=  1'b0    ;
                     if(i_rx_end) begin
                            read_data <=  i_rece_data   ;              
                            cfg_sta <=  8'd17   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd16    ;
                     end   
                end                
 
                 8'd17:begin   //用于开启回读读功能，在初始化配置完以后进行回读查验是否一致
                        if(read_data==cfg_rom_write_mode0[romaddr_write_mode0-1'd1][(SEND_WITH-1):0]) begin        //当CHEAK_DATA_EN=1时，需要修改W_DATA_WITH     
                            cfg_sta         <=  8'd18   ; 
                        end 
                        else begin
                            cfg_sta         <=  8'd17   ; 
                            romaddr_write_mode0         <=  romaddr_write_mode0 -1'b1  ;
                        end
                end   
                 8'd18:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         cfg_sta   <=  8'd12    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd18    ;
                     end
                  end      
 //##################################################################################################

 //###########################################状态机22-28：固定模式写入1###########################
                8'd22:begin 
                    o_send_data <= romdata_write_mode1  ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd23    ;
                end
 
                8'd23:begin
                      o_start           <=  1'b0    ;
                      if (i_end) begin
                          if (romaddr_write_mode1 == (REG_CFG_NUM_WRITE_PRE1-1))  begin
                              cfg_sta     <=  8'd1    ;
                              romaddr_write_mode1     <=  16'd0    ;
                          end 
                          else begin
                              romaddr_write_mode1         <=  romaddr_write_mode1 + 16'b1  ;
                              cfg_sta         <=  8'd24  ;
                          end
                      end 
                      else begin
                          cfg_sta         <=  8'd23    ;
                          end
                     end
                 
                 8'd24:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         if(CHEAK_DATA_EN)begin
                            cfg_sta   <=  8'd25 ;
                         end
                         else begin
                            cfg_sta   <=  8'd22 ;
                         end
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd24    ;
                     end
                  end  

                8'd25:begin
                        cfg_sta <=  8'd26    ;
                        o_start <=  1'b1 ;
                        o_send_data <= cfg_rom_write_mode1[romaddr_write_mode1-1];      //需要修改cfg_rom_init[romaddr-1]的读写控制为此次发送的数据需要修改读写控制位
                    end 
                
                8'd26:begin
                     o_start <=  1'b0    ;
                     if(i_rx_end) begin
                            read_data <=  i_rece_data   ;              
                            cfg_sta <=  8'd27   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd26    ;
                     end   
                end                
 
                 8'd27:begin   //用于开启回读读功能，在初始化配置完以后进行回读查验是否一致
                        if(read_data==cfg_rom_write_mode1[romaddr_write_mode1-1'd1][(SEND_WITH-1):0]) begin        //当CHEAK_DATA_EN=1时，需要修改W_DATA_WITH     
                            cfg_sta         <=  8'd28   ; 
                        end 
                        else begin
                            cfg_sta         <=  8'd27   ; 
                            romaddr_write_mode1         <=  romaddr_write_mode1 -1'b1  ;
                        end
                end   
                 8'd28:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         cfg_sta   <=  8'd22    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd28    ;
                     end
                  end    
 //#################################################################################################

//###########################################状态机32-38：单个寄存器写入###########################
                8'd32:begin 
                    o_send_data <= i_send_data  ;
                    o_start   <=  1'b1          ;
                    cfg_sta       <=  8'd33     ;
                end
 
                8'd33:begin
                      o_start           <=  1'b0    ;
                      if (i_end) begin
                          cfg_sta         <=  8'd34  ;
                      end 
                      else begin
                          cfg_sta         <=  8'd33    ;
                          end
                     end
                 
                 8'd34:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         if(CHEAK_DATA_EN)begin
                            cfg_sta   <=  8'd35 ;
                         end
                         else begin
                            cfg_sta   <=  8'd1 ;
                         end
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd34    ;
                     end
                  end  

                8'd35:begin
                        cfg_sta <=  8'd36    ;
                        o_start <=  1'b1 ;
                        o_send_data <= {1'b0,i_send_data[SEND_WITH-2:0]};      //需要修改send_data_VIO的读写控制为此次发送的数据需要修改读写控制位
                    end 
                
                8'd36:begin
                     o_start <=  1'b0    ;
                     if(i_rx_end) begin
                            read_data <=  i_rece_data   ;              
                            cfg_sta <=  8'd37   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd36    ;
                     end   
                end                
 
                 8'd37:begin   //用于开启回读读功能，在初始化配置完以后进行回读查验是否一致
                        if(read_data==i_send_data[SEND_WITH-2:0]) begin        //当CHEAK_DATA_EN=1时，需要修改send_data_VIO的数据位的数据是否一致   
                            cfg_sta         <=  8'd38   ; 
                        end 
                        else begin
                            cfg_sta         <=  8'd37   ; 
                        end
                end   
                 8'd38:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0   ;
                         cfg_sta   <=  8'd1    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd38    ;
                     end
                  end      
//#################################################################################################


 //###########################################状态机42-44：固定模式寄存器读取########################
                8'd42:begin 
                    o_send_data <= romdata_read_mode0  ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd43    ;
                end
 
                8'd43:begin
                      o_start           <=  1'b0    ;
                      if (i_end) begin
                          if (romaddr_read_mode0 == (REG_CFG_NUM_READ_PRE0-1))  begin
                              cfg_sta     <=  8'd1    ;
                              romaddr_read_mode0     <=  16'd0    ;
                          end 
                          else begin
                              romaddr_read_mode0         <=  romaddr_read_mode0 + 16'b1  ;
                              read_data[romaddr_read_mode0]   <=  i_rece_data   ;
                              cfg_sta               <=  8'd44  ;
                          end
                      end 
                      else begin
                          cfg_sta         <=  8'd43    ;
                          end
                     end
                 
                 8'd44:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0 ;  
                         cfg_sta   <=  8'd42  ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd44    ;
                     end
                  end             
 
  //#############################################################################################

 //###########################################状态机52-27：单个寄存器读取########################

                8'd52:begin 
                    o_send_data <= i_send_data  ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd53    ;
                end
 
                8'd53:begin
                      o_start          <=  1'b0    ;
                      if (i_rx_end) begin
                              o_recive_data  <=  i_rece_data   ;
                              cfg_sta      <=  8'd54  ;
                      end 
                      else begin
                          cfg_sta         <=  8'd53    ;
                          end
                     end
                 
                 8'd54:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0 ;  
                         cfg_sta     <=  8'd1    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd54    ;
                     end
                  end     
  //################################################################################################# 
  //######################################状态机62-64：定时循环读取单个寄存器########################

                8'd62:begin 
                    o_send_data <= 16'b1000_0000_0000_0000 ;
                    o_start   <=  1'b1      ;
                    cfg_sta       <=  8'd63    ;
                end
 
                8'd63:begin
                      o_start          <=  1'b0    ;
                      if (i_rx_end) begin
                              o_recive_data  <=  i_rece_data   ;
                              cfg_sta      <=  8'd64  ;
                      end 
                      else begin
                            cfg_sta      <=  8'd63  ;
                          end
                     end
                 
                 8'd64:begin 
                   if (delay_cnt >=SPI_INTERVALS1) begin
                         delay_cnt <=  32'd0 ;  
                         cfg_sta     <=  8'd62    ;
                    end
                      else begin
                         delay_cnt <=  delay_cnt + 1'b1;
                         cfg_sta   <=  8'd1    ;
                     end
                  end     
  //################################################################################################# 
   
                 default:begin
                 cfg_sta               <=  5'd0    ;
                end
            endcase
        end
    end
endmodule


