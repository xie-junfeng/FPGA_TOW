`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: л����
// 
// Create Date: 2025/04/21 14:36:47
// Design Name: 
// Module Name: XND4351_SPI_FUNCTION_MASTER_LOOP
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

module GX122_SPI_FUNCTION
#(
//-------------------��ģʽ�Ĵ�������------------------
parameter  REG_CFG_NUM_INIT          =   1,                                 // ��ʼ���ܹ���Ҫ���õļĴ�������
parameter  REG_CFG_NUM_WRITE_PRE0    =   1,                                 //��һ��Ԥ��ģʽ0�ļĴ�������
parameter  REG_CFG_NUM_WRITE_PRE1    =   1,                                 //�ڶ���Ԥ��ģʽ1�ļĴ�������
parameter  REG_CFG_NUM_READ_PRE0     =   1,                                 //�ڶ���Ԥ��ģʽ1�ļĴ�������
//-----------------------��ʱ����----------------------  
parameter  SPI_INTERVALS1            =   1000,                              // �Ĵ���֮�����ʱ ����ʱ��СΪ��1/clk*SPI_INTERVALS��
parameter  INITIAL_DELAY             =   12500000,                          // ��λ����ʱ��ÿ�ʼ���üĴ��� ,��ʼ����ʱ����ʱ��СΪ��1/clk*INITIAL_INTERVALS1��12500000
//-----------------------���ܿ�������------------------     
parameter  CHEAK_DATA_EN             =   0,                                 // �����ܿ���������У���дһ�¡������أ���
parameter  INIT_REG_EN               =   0,                                 // �費��Ҫ����ʼ���Ĵ������á�1-����0-�أ����أ���
//-----------------------λ������----------------------    
parameter  SEND_DATA_WITH            =   29,                     
parameter  SEND_DATA_ADRESS          =   3, 
parameter  ADRESS_WITH               =   SEND_DATA_ADRESS  ,                 // ��ַλ�� 
parameter  W_DATA_WITH               =   SEND_DATA_WITH    ,                 // д����λ��  
parameter  SPI_SEND_WITH             =   SEND_DATA_WITH +SEND_DATA_ADRESS,   // д��λ�� WRITE_WITH=W_DATA_WITH+ADRESS_WITH
parameter  SPI_RECE_WITH             =   SEND_DATA_WITH +SEND_DATA_ADRESS    // ����λ�� 

)
(
    input  wire                                clk, 
    input  wire                                reset,    
    input   wire   [7:0]                       mode_chose,  //ģʽѡ�����ڲ�ͬģʽѡ����źŶ˿ڣ���Ҫ���ڵ��ԣ�����ȷ����д�ɲ�����ʽ
   //������ӿ���Ҫ����VIO����
    input   wire   [SPI_SEND_WITH-1:0]         send_data , 
    output  reg    [SPI_RECE_WITH-1:0]         recive_data ,     
    (*mark_debug = "true"*)output reg [ 7:0]  cfg_sta  ,   

    output  reg  [SPI_SEND_WITH-1:0]   spi_send_data_o, // ���͵�����
    output  reg                                spi_start_o      ,               // ���������ź�
    input  wire                                spi_end_i,                       // ���͵Ľ����ź�
    (*mark_debug = "true"*)input  wire   [ SPI_RECE_WITH-1:0]         spi_rece_data_i                 //���յ�����                      
    );

//////////////////////////////////VIO�������������///////////////////////////////////////// 


//////////////////////////////////////////////////////////////////////////////////////////// 


//////////////////////////////ͨ��������Чλ���ش����ķ�ʽ���ģʽ�仯///////////////////
reg      mode_chose_chage;
reg [7:0]mode_chose_reg0=8'd0;
reg [7:0]mode_chose_reg1=8'd0;

    always@(posedge clk or negedge reset) begin
     if (!reset) begin
         mode_chose_reg0    <=  8'b0    ;
         mode_chose_reg1    <=  8'b0    ;
     end else begin
         mode_chose_reg0    <=  mode_chose;
         mode_chose_reg1    <=  mode_chose_reg0    ;
     end
    end
    
    always@(posedge clk or negedge reset) begin
    if (!reset) begin
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
reg     [SPI_SEND_WITH-1:0]          romdata_init   ;
reg     [ 15:0]                   romaddr_init   ;
(* ram_style="distributed" *)
reg     [SPI_SEND_WITH-1:0]         cfg_rom_init[REG_CFG_NUM_INIT-1:0];

initial begin
    cfg_rom_init[ 0] = 32'h00000006;
    cfg_rom_init[ 1] = 32'h00580005;
    cfg_rom_init[ 2] = 32'h008C803C; 
    cfg_rom_init[ 3] = 32'h00480003; 
    cfg_rom_init[ 4] = 32'h01004E42;        
    cfg_rom_init[ 5] = 32'h080003E9; 
    cfg_rom_init[ 6] = 32'h00510000;    

//    cfg_rom_init[ 0] = 32'h00000001;  //���ڲ���  
//    cfg_rom_init[ 1] = 32'h00000002;  //���ڲ���  
//    cfg_rom_init[ 2] = 32'h00000004;  //���ڲ���  
//    cfg_rom_init[ 3] = 32'h00000008;  //���ڲ���   
//    cfg_rom_init[ 4] = 32'h00000010;  //���ڲ���          
//    cfg_rom_init[ 5] = 32'h00000020;  //���ڲ���   
//    cfg_rom_init[ 6] = 32'h00000040;  //���ڲ���    
 
end  
     
always@(posedge clk) begin
    romdata_init    <=  cfg_rom_init[romaddr_init]         ;
end   

//####################################ģʽ����Ԥ��_�̶�ģʽд��0################################## 
reg     [SPI_SEND_WITH-1:0]          romdata_write_mode0 ;
reg     [ 15:0]                   romaddr_write_mode0   ;
(* ram_style="distributed" *)
 reg    [SPI_SEND_WITH-1:0]         cfg_rom_write_mode0[REG_CFG_NUM_WRITE_PRE0-1:0];  
 initial begin
     cfg_rom_write_mode0[ 0] = 32'h004A0000;  
      
//    cfg_rom_write_mode0[ 0] = 32'h00000080;  //���ڲ���  
     end  
     
always@(posedge clk) begin
    romdata_write_mode0    <=  cfg_rom_write_mode0[romaddr_write_mode0]         ;
end     

//####################################ģʽ����Ԥ��_�̶�ģʽд��1################################## 
reg     [SPI_SEND_WITH-1:0]          romdata_write_mode1 ;
reg     [ 15:0]                   romaddr_write_mode1   ;
(* ram_style="distributed" *)
 reg    [SPI_SEND_WITH-1:0]         cfg_rom_write_mode1[REG_CFG_NUM_WRITE_PRE1-1:0];  
 initial begin
     cfg_rom_write_mode1[0] = 32'h00510000; 
     
//    cfg_rom_write_mode1[ 0] = 32'h00000100;   //���ڲ���   
 end  
always@(posedge clk) begin
    romdata_write_mode1    <=  cfg_rom_write_mode1[romaddr_write_mode1]         ;
end     

//####################################ģʽ����Ԥ��_�̶���ȡģʽ################################## 
reg     [SPI_SEND_WITH-1:0]          romdata_read_mode0 ;
reg     [ 15:0]                   romaddr_read_mode0   ;
(* ram_style="distributed" *)
 reg    [SPI_SEND_WITH-1:0]         cfg_rom_read_mode0[REG_CFG_NUM_READ_PRE0-1:0];  
 initial begin
    cfg_rom_read_mode0[ 0] = 32'h00000100;      
    
 //     cfg_rom_write_mode1[0] = 32'h00510000;  //���ڲ���  
 end  

always@(posedge clk) begin
    romdata_read_mode0    <=  cfg_rom_read_mode0[romaddr_read_mode0]         ;
end   

///////////////////////////////////////////////////////////////////////////////////////////// 


////////////////////////////////////////ģʽ״̬��////////////////////////////////////////////
//ע�ͣ�����Ҫ�Ż���Դ���ģ�������ȥ���ò�����ģʽ             
 reg     [31:0]                            delay_cnt;
 reg     [SPI_RECE_WITH-1:0]                  read_data;   
 reg     [7:0]                             send_data_number;   

    always@(posedge clk or negedge reset) begin                                           
        if (!reset) begin                                                               
            cfg_sta                     <=  5'd0;                                       
            delay_cnt                   <=  32'd0;
            romaddr_init                <=  16'd0;
            romaddr_write_mode0         <=  16'd0;
            romaddr_write_mode1         <=  16'd0;  
            romaddr_read_mode0         <=  16'd0; 
                                  
            spi_start_o                 <=  1'b0;
            spi_send_data_o             <=  24'd0;
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
                        case(mode_chose)
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
                    spi_send_data_o <= romdata_init  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd3    ;
                end
 
                8'd3:begin
                      spi_start_o           <=  1'b0    ;
                      if (spi_end_i) begin
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
                        spi_start_o <=  1'b1 ;
                        spi_send_data_o <= cfg_rom_init[romaddr_init-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
                    end 
                
                8'd6:begin
                     spi_start_o <=  1'b0    ;
                     if(spi_end_i) begin
                            read_data <=  spi_rece_data_i   ;              
                            cfg_sta <=  8'd7   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd6    ;
                     end   
                end                
 
                 8'd7:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_init[romaddr_init-1'd1][(SPI_SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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
                    spi_send_data_o <= romdata_write_mode0  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd13    ;
                end
 
                8'd13:begin
                      spi_start_o           <=  1'b0    ;
                      if (spi_end_i) begin
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
                        spi_start_o <=  1'b1 ;
                        spi_send_data_o <= cfg_rom_write_mode0[romaddr_write_mode0-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
                    end 
                
                8'd16:begin
                     spi_start_o <=  1'b0    ;
                     if(spi_end_i) begin
                            read_data <=  spi_rece_data_i   ;              
                            cfg_sta <=  8'd17   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd16    ;
                     end   
                end                
 
                 8'd17:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_write_mode0[romaddr_write_mode0-1'd1][(SPI_SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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
                    spi_send_data_o <= romdata_write_mode1  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd23    ;
                end
 
                8'd23:begin
                      spi_start_o           <=  1'b0    ;
                      if (spi_end_i) begin
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
                        spi_start_o <=  1'b1 ;
                        spi_send_data_o <= cfg_rom_write_mode1[romaddr_write_mode1-1];      //��Ҫ�޸�cfg_rom_init[romaddr-1]�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
                    end 
                
                8'd26:begin
                     spi_start_o <=  1'b0    ;
                     if(spi_end_i) begin
                            read_data <=  spi_rece_data_i   ;              
                            cfg_sta <=  8'd27   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd26    ;
                     end   
                end                
 
                 8'd27:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==cfg_rom_write_mode1[romaddr_write_mode1-1'd1][(SPI_SEND_WITH-1):0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�W_DATA_WITH     
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
                    spi_send_data_o <= send_data  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd33    ;
                end
 
                8'd33:begin
                      spi_start_o           <=  1'b0    ;
                      if (spi_end_i) begin
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
                        spi_start_o <=  1'b1 ;
                        spi_send_data_o <= {1'b0,send_data[SPI_SEND_WITH-2:0]};      //��Ҫ�޸�send_data_VIO�Ķ�д����Ϊ�˴η��͵�������Ҫ�޸Ķ�д����λ
                    end 
                
                8'd36:begin
                     spi_start_o <=  1'b0    ;
                     if(spi_end_i) begin
                            read_data <=  spi_rece_data_i   ;              
                            cfg_sta <=  8'd37   ; 
                     end 
                     else begin
                        cfg_sta <=  8'd36    ;
                     end   
                end                
 
                 8'd37:begin   //���ڿ����ض������ܣ��ڳ�ʼ���������Ժ���лض������Ƿ�һ��
                        if(read_data==send_data[SPI_SEND_WITH-2:0]) begin        //��CHEAK_DATA_EN=1ʱ����Ҫ�޸�send_data_VIO������λ�������Ƿ�һ��   
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
                    spi_send_data_o <= romdata_read_mode0  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd43    ;
                end
 
                8'd43:begin
                      spi_start_o           <=  1'b0    ;
                      if (spi_end_i) begin
                          if (romaddr_read_mode0 == (REG_CFG_NUM_READ_PRE0-1))  begin
                              cfg_sta     <=  8'd1    ;
                              romaddr_read_mode0     <=  16'd0    ;
                          end 
                          else begin
                              romaddr_read_mode0         <=  romaddr_read_mode0 + 16'b1  ;
                              read_data[romaddr_read_mode0]   <=  spi_rece_data_i   ;
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
                    spi_send_data_o <= send_data  ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd53    ;
                end
 
                8'd53:begin
                      spi_start_o          <=  1'b0    ;
                      if (spi_end_i) begin
                              recive_data  <=  spi_rece_data_i   ;
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
                    spi_send_data_o <= 16'b1000_0000_0000_0000 ;
                    spi_start_o   <=  1'b1      ;
                    cfg_sta       <=  8'd63    ;
                end
 
                8'd63:begin
                      spi_start_o          <=  1'b0    ;
                      if (spi_end_i) begin
                              recive_data  <=  spi_rece_data_i   ;
                              cfg_sta      <=  8'd64  ;
                      end 
                      else begin
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