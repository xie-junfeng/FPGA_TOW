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
 //-------------------����λ����������----------------
    parameter DATA_WIDTH                 = 8,      
    parameter SEND_WITH                  = DATA_WIDTH,       
    parameter RECE_WITH                  = DATA_WIDTH,       
//-------------------UARTͨѶģʽ����------------------    
    parameter PARITY_ON                  = 1'd0,              //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
    parameter PARITY_TYPE                = 1'd1,              //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
 
 //-------------------��ģʽ�Ĵ�����Ŀ����-------------
    parameter  REG_CFG_NUM_INIT          =   1,               // ��ʼ���ܹ���Ҫ���õļĴ�������
    parameter  REG_CFG_NUM_WRITE_PRE0    =   1,               // д��һ��Ԥ��ģʽ0�ļĴ�������
    parameter  REG_CFG_NUM_WRITE_PRE1    =   1,               // д�ڶ���Ԥ��ģʽ1�ļĴ�������
    parameter  REG_CFG_NUM_READ_PRE0     =   1,               // ��Ԥ��ģʽ1�ļĴ�������

 //----------------------��������----------------------- 
    parameter CLK_FRE                    = 50000000,                //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
    parameter BAUD_RATE                  = 16'd9600,          //�����ʣ�ȱʡΪ9600

//-----------------------��ʱ����----------------------  
parameter  SPI_INTERVALS1                =   CLK_FRE/BAUD_RATE,                              // �Ĵ���֮�����ʱ ����ʱ��СΪ��1/clk*SPI_INTERVALS��
parameter  INITIAL_DELAY                 =   0,    

//-----------------------���ܿ�������------------------   
    parameter  CHEAK_DATA_EN             =   0,               // �����ܿ���������У���дһ�¡������أ���
    parameter  INIT_REG_EN               =   0                // �費��Ҫ����ʼ���Ĵ������á�1-����0-�أ����أ���)
)

(
    input  wire                                i_clk_sys, 
    input  wire                                i_rst_n,    
    input   wire   [7:0]                       i_mode_chose,  //ģʽѡ�����ڲ�ͬģʽѡ����źŶ˿ڣ���Ҫ���ڵ��ԣ�����ȷ����д�ɲ�����ʽ
   //������ӿ���Ҫ����VIO����
    input   wire   [SEND_WITH-1:0]             i_send_data , 
    output  reg    [RECE_WITH-1:0]             o_recive_data ,     
    (*mark_debug = "true"*)output reg [ 7:0]  cfg_sta  ,   

    output  reg    [SEND_WITH-1:0]             o_send_data, // ���͵�����
    output  reg                                o_start      ,               // ���������ź�
    input  wire                                i_end,                       // ���͵Ľ����ź�
   
    (*mark_debug = "true"*)input  wire   [ RECE_WITH-1:0]         i_rece_data, 
    input  wire                                 i_rx_end                //���յ�����                      
    );

//////////////////////////////////VIO�������������///////////////////////////////////////// 


//////////////////////////////////////////////////////////////////////////////////////////// 


//////////////////////////////ͨ��������Чλ���ش����ķ�ʽ���ģʽ�仯///////////////////
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

///////////////////////////////////////// �Ĵ���ֵԤ��//////////////////////////////////////                                            
//####################################ģʽһ����ʼ�����õļĴ���ֵ##########################
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

    cfg_rom_init[ 0] = 8'h01;  //���ڲ���  
    cfg_rom_init[ 1] = 8'h02;  //���ڲ���  
    cfg_rom_init[ 2] = 8'h04;  //���ڲ���  
    cfg_rom_init[ 3] = 8'h08;  //���ڲ���   
    cfg_rom_init[ 4] = 8'h10;  //���ڲ���          
    cfg_rom_init[ 5] = 8'h20;  //���ڲ���   
    cfg_rom_init[ 6] = 8'h40;  //���ڲ���    
 
end  
     
always@(posedge i_clk_sys) begin
    romdata_init    <=  cfg_rom_init[romaddr_init]         ;
end   

//####################################ģʽ����Ԥ��_�̶�ģʽд��0################################## 
reg     [SEND_WITH-1:0]          romdata_write_mode0 ;
reg     [ 15:0]                   romaddr_write_mode0   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_write_mode0[REG_CFG_NUM_WRITE_PRE0-1:0];  
 initial begin
     cfg_rom_write_mode0[ 0] = 8'h04;  
      
//    cfg_rom_write_mode0[ 0] = 32'h00000080;  //���ڲ���  
     end  
     
always@(posedge i_clk_sys) begin
    romdata_write_mode0    <=  cfg_rom_write_mode0[romaddr_write_mode0]         ;
end     

//####################################ģʽ����Ԥ��_�̶�ģʽд��1################################## 
reg     [SEND_WITH-1:0]          romdata_write_mode1 ;
reg     [ 15:0]                   romaddr_write_mode1   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_write_mode1[REG_CFG_NUM_WRITE_PRE1-1:0];  
 initial begin
//     cfg_rom_write_mode1[0] = 8'h01; 
     
    cfg_rom_write_mode1[ 0] = 8'h11;   //���ڲ���   
 end  
always@(posedge i_clk_sys) begin
    romdata_write_mode1    <=  cfg_rom_write_mode1[romaddr_write_mode1]         ;
end     

//####################################ģʽ����Ԥ��_�̶���ȡģʽ################################## 
reg     [SEND_WITH-1:0]          romdata_read_mode0 ;
reg     [ 15:0]                      romaddr_read_mode0   ;
(* ram_style="distributed" *)
 reg    [SEND_WITH-1:0]         cfg_rom_read_mode0[REG_CFG_NUM_READ_PRE0-1:0];  
 initial begin
//    cfg_rom_read_mode0[ 0] = 8'h00;      
    
     cfg_rom_read_mode0[0] = 8'h01;  //���ڲ���  
 end  

always@(posedge i_clk_sys) begin
    romdata_read_mode0    <=  cfg_rom_read_mode0[romaddr_write_mode1]         ;
end   

///////////////////////////////////////////////////////////////////////////////////////////// 


////////////////////////////////////////ģʽ״̬��////////////////////////////////////////////
//ע�ͣ�����Ҫ�Ż���Դ���ģ�������ȥ���ò�����ģʽ             
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
 //###############################################��λ��ʼ���ȴ���ʱ####################################################//                   
 
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
                  
 //#####################################################ģʽѡ��#######################################################//                   
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
                  
 //###############################################״̬��2-7��ʼ���Ĵ�������####################################################//                 
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
                        o_send_data <= cfg_rom_init[romaddr_init-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
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
 
                 8'd7:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_init[romaddr_init-1'd1][(SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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
              
                 
 //###########################################״̬��12-18���̶�ģʽд��0############################# 
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
                        o_send_data <= cfg_rom_write_mode0[romaddr_write_mode0-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
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
 
                 8'd17:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_write_mode0[romaddr_write_mode0-1'd1][(SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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

 //###########################################״̬��22-28���̶�ģʽд��1###########################
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
                        o_send_data <= cfg_rom_write_mode1[romaddr_write_mode1-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
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
 
                 8'd27:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_write_mode1[romaddr_write_mode1-1'd1][(SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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

//###########################################״̬��32-38�������Ĵ���д��###########################
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
                        o_send_data <= {1'b0,i_send_data[SEND_WITH-2:0]};      //��Ҫ�޸�send_data_VIO�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
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
 
                 8'd37:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==i_send_data[SEND_WITH-2:0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�send_data_VIO������λ�������Ƿ�һ��   
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


 //###########################################״̬��42-44���̶�ģʽ�Ĵ�����ȡ########################
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

 //###########################################״̬��52-27�������Ĵ�����ȡ########################

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
  //######################################״̬��62-64����ʱѭ����ȡ�����Ĵ���########################

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


