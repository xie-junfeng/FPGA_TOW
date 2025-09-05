`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/04 09:23:37
// Design Name: 
// Module Name: UART_TX
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


module uart_tx
#(
   parameter CLK_FRE    = 50,         //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
   parameter DATA_WIDTH = 8,       //��Ч����λ��ȱʡΪ8λ
   parameter PARITY_ON = 0,        //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
   parameter PARITY_TYPE = 0,      //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
   parameter BAUD_RATE = 9600      //�����ʣ�ȱʡΪ9600
)
(   input                      i_clk_sys,      //ϵͳʱ��
   input                       i_rst_n,        //ȫ���첽��λ
   input [DATA_WIDTH-1 : 0]    i_data_tx,      //������������
   input                       i_data_start,   //����������Ч
   output reg                  o_uart_tx_data,       //UART���
   output                       o_uart_tx_end       //UART���
   );
  reg o_uart_tx_end0=1'd0;
  reg o_uart_tx_end1=1'd0;  
       
   //״̬������
           reg [2:0] r_current_state;  //��ǰ״̬
           reg [2:0] r_next_state;     //��̬
               
           localparam STATE_IDLE = 3'b000;         //����״̬
           localparam STATE_START = 3'b001;        //��ʼ״̬
           localparam STATE_DATA = 3'b011;         //���ݷ���״̬
           localparam STATE_PARITY = 3'b100;       //����У�����ͷ���
           localparam STATE_END = 3'b101;          //����״̬
           
           
           localparam CYCLE = CLK_FRE * 1000000 / BAUD_RATE;   //���ؼ�������
           
           reg baud_valid;                         //���ؼ�����Чλ
           reg [15:0] baud_cnt;                    //�����ʼ����� 
           reg baud_pulse;                         //�����ʲ�������
           
           reg [3:0]   r_tx_cnt;      //��������λ����
           
           //�����ʼ�����
           always@(posedge i_clk_sys or negedge i_rst_n)
               begin
                   if(!i_rst_n)
                       baud_cnt <= 16'h0000;
                   else if(!baud_valid)
                       baud_cnt <= 16'h0000;
                   else if(baud_cnt == CYCLE - 1)
                       baud_cnt <= 16'h0000;
                   else
                       baud_cnt <= baud_cnt + 1'b1;
               end
               
           //���ز�������
           always@(posedge i_clk_sys or negedge i_rst_n)
               begin
                   if(!i_rst_n)
                       baud_pulse <= 1'b0;
                   else if(baud_cnt == CYCLE/2-1)
                       baud_pulse <= 1'b1;
                   else
                       baud_pulse <= 1'b0;
               end
           
           //״̬��״̬�仯����
           always@(posedge i_clk_sys or negedge i_rst_n)
               begin
                   if(!i_rst_n)
                       r_current_state <= STATE_IDLE;
                   else if(!baud_valid)
                       r_current_state <= STATE_IDLE;
                   else if(baud_valid && baud_cnt == 16'h0000)
                       r_current_state <= r_next_state;
               end
           
           //״̬����̬����
           always@(*)
               begin
                   case(r_current_state)
                       STATE_IDLE:     
                           r_next_state <= STATE_START;
                       STATE_START:    
                           r_next_state <= STATE_DATA;
                       STATE_DATA:
                       if(r_tx_cnt == DATA_WIDTH)
                           begin
                               if(PARITY_ON == 0)
                                   r_next_state <= STATE_END;
                               else
                                   r_next_state <= STATE_PARITY;       //У��λ����ʱ����У��״̬
                           end
                       else
                           begin
                                   r_next_state <= STATE_DATA;
                           end
                       STATE_PARITY:  
                            r_next_state <= STATE_END;
                       STATE_END:  
                         r_next_state <= STATE_IDLE;
                       default:;
                   endcase
               end
   
   
   reg [DATA_WIDTH-1 : 0]      r_data_tx;
   reg                         r_parity_check;
   //״̬������߼�
   always@(posedge i_clk_sys or negedge i_rst_n)
       begin
           if(!i_rst_n)
               begin
                   o_uart_tx_end0<=1'b0;
                   baud_valid  <= 1'b0;
                   r_data_tx   <= 'd0;
                   o_uart_tx_data   <= 1'b1;
                   r_tx_cnt    <= 4'd0;
                   r_parity_check <= 1'b0;
               end
           else
               case(r_current_state)
                   STATE_IDLE:begin
                    o_uart_tx_end0<=1'b0;
                     o_uart_tx_data   <= 1'b1;
                     r_tx_cnt    <= 4'd0;
                     r_parity_check <= 4'd0;
                     if(i_data_start)
                         begin
                             baud_valid <= 1'b1;
                             r_data_tx <= i_data_tx;
                          end
                     end
                   STATE_START:begin
                           
                           if(baud_pulse)
                                
                               o_uart_tx_data   <= 1'b0;
                       end
                   STATE_DATA:begin
                           if(baud_pulse)
                               begin
                                   r_tx_cnt <= r_tx_cnt + 1'b1;
                                   o_uart_tx_data <= r_data_tx[0];
                                   r_parity_check <= r_parity_check + r_data_tx[0];
                                   r_data_tx <= {1'b0 ,r_data_tx[DATA_WIDTH-1:1]};
                               end
                       end
                   STATE_PARITY:begin
                           if(baud_pulse)
                               begin
                                   if(PARITY_TYPE == 1)
                                       o_uart_tx_data <= r_parity_check+ 1'b1;
                                   else
                                       o_uart_tx_data <= r_parity_check ;
                               end
                       end
                   STATE_END:begin
                            o_uart_tx_end0<=1'd1;
                           if(baud_pulse)
                               begin
                                   o_uart_tx_data <= 1'b1;
                                   baud_valid <= 1'b0;
                                   
                               end
                       end
                   default:;
               endcase
       end



wire cs_raise;
reg  o_uart_tx_end2;

      always@(posedge i_clk_sys  or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_uart_tx_end0    <=  1'b0    ;
            o_uart_tx_end1    <=  1'b0    ;
        end else begin
            o_uart_tx_end1    <=  o_uart_tx_end0    ;
            o_uart_tx_end2    <=   o_uart_tx_end1    ;
        end
    end  
    
  assign   o_uart_tx_end =(~o_uart_tx_end2 & o_uart_tx_end1 );
endmodule

