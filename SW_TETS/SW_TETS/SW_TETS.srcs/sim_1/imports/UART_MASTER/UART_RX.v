`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/04 09:23:15
// Design Name: 
// Module Name: UART_RX
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


module uart_rx
#(
    parameter CLK_FRE = 50,         //ʱ��Ƶ�ʣ�Ĭ��ʱ��Ƶ��Ϊ50MHz
    parameter DATA_WIDTH = 8,       //��Ч����λ��ȱʡΪ8λ
    parameter PARITY_ON = 1'd0,        //У��λ��1Ϊ��У��λ��0Ϊ��У��λ��ȱʡΪ0
    parameter PARITY_TYPE = 1'd0,      //У�����ͣ�1Ϊ��У�飬0ΪżУ�飬ȱʡΪżУ��
    parameter BAUD_RATE = 9600      //�����ʣ�ȱʡΪ9600
)
(
    input                           i_clk_sys,      //ϵͳʱ��
    input                           i_rst_n,        //ȫ���첽��λ,�͵�ƽ��Ч
    input                           i_uart_rx,      //UART����
    output reg[DATA_WIDTH-1 :0]     o_uart_data,    //UART��������
    output reg                      o_verify_flg,    //У��λ����LED���ߵ�ƽλΪУ����ȷ
    output reg                      o_rx_done       //UART���ݽ�����ɱ�־
    );
    
    /*
    UART�������첽���룬�����ͬ����FPGA�ڲ���ʱ����
    ����ʡ�ԣ������첽��·�У�����ʱ����ͬ����һ������ϰ��
    */
    reg sync_uart_rx;
    always@(posedge i_clk_sys or negedge i_rst_n)
        begin
            if(!i_rst_n)
                sync_uart_rx <= 1'b1;
            else
                sync_uart_rx <= i_uart_rx;
        end
    
    /*
    ���������������·��ƽ���ж�rx�Ƿ����źŴ���
    ����������ź�����Ϊ�жϱ�׼������Ч�ų�ë����������������
    */
    reg [4:0] r_flag_rcv_start;
    wire w_rcv_start;
    always@(posedge i_clk_sys or negedge i_rst_n)
        begin
            if(!i_rst_n)
                r_flag_rcv_start <= 5'b11111;
            else
                r_flag_rcv_start <= {r_flag_rcv_start[3:0], sync_uart_rx};
        end
    
    
    //״̬������
    reg [2:0] r_current_state;  //��ǰ״̬
    reg [2:0] r_next_state;     //��̬
        
    localparam STATE_IDLE = 3'b000;         //����״̬
    localparam STATE_START = 3'b001;        //��ʼ״̬
    localparam STATE_DATA = 3'b011;         //���ݽ���״̬
    localparam STATE_PARITY = 3'b100;       //����У��״̬
    localparam STATE_END = 3'b101;          //����״̬
    
    
    localparam CYCLE = CLK_FRE * 1000000 / BAUD_RATE;   //���ؼ�������
    
    reg baud_valid;                         //���ؼ�����Чλ
    reg [15:0] baud_cnt;                    //�����ʼ����� 
    reg baud_pulse;                         //�����ʲ�������
    
    reg [3:0]   r_rcv_cnt;      //��������λ����
    
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
 
 
 reg flag;   
    //״̬��״̬�仯����
    always@(posedge i_clk_sys or negedge i_rst_n)
        begin
            if(!i_rst_n)begin
                r_current_state <= STATE_IDLE;
                flag<= 1'd0;
                end
            else if(!baud_valid)begin
                r_current_state <= STATE_IDLE;
                flag<= 1'd0;
                end
            else if(baud_valid && baud_cnt == 16'h0000)begin
                r_current_state <= r_next_state;
                flag<= 1'd1;
                end
             else
                flag<= 1'd0;
        end
    
    //״̬����̬����
    always@(*)
        begin
            case(r_current_state)
                STATE_IDLE:     r_next_state <= STATE_START;
                STATE_START:    r_next_state <= STATE_DATA;
                STATE_DATA:
                    if(r_rcv_cnt == DATA_WIDTH)
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
                STATE_PARITY:   r_next_state <= STATE_END;
                STATE_END:      r_next_state <= STATE_IDLE;
                default:;
            endcase
        end
    
    
    reg[DATA_WIDTH - 1 :0] r_data_rcv;
    reg r_parity_check;
    
    //״̬������߼�
    always@(posedge i_clk_sys or negedge i_rst_n)
        begin
            if(!i_rst_n)
                begin
                    baud_valid <= 1'b0;
                    r_data_rcv <= 'd0;
                    r_rcv_cnt <= 4'd0;
                    r_parity_check <= 1'b0;
                    o_uart_data <= 'd0;
                    o_verify_flg <= 1'b0;
                    o_rx_done <= 1'b0;
                end
            else
                case(r_current_state)
                    STATE_IDLE:begin
                            //����״̬�¶ԼĴ������и�λ
                            r_rcv_cnt <= 4'd0;
                            r_data_rcv <= 'd0;
                            r_parity_check <= 1'b0;
                            o_rx_done <= 1'b0;
                            //������⵽�͵�ƽʱ��ΪUART�������ݣ�����baud_valid
                            if(r_flag_rcv_start == 5'b00000)
                                baud_valid <= 1'b1;
                        end
                    STATE_START:begin
                            if(baud_pulse && sync_uart_rx)     //�����ʲ������嵽��ʱ�ٴμ���Ƿ�Ϊ�͵�ƽ�������Ϊ�͵�ƽ����Ϊǰ�����⣬���½���IDLE״̬
                                baud_valid <= 1'b0;
                        end
                    STATE_DATA:begin
                            if(baud_pulse)
                                begin
                                    r_data_rcv <= {sync_uart_rx, r_data_rcv[DATA_WIDTH-1 : 1]}; //������λ�洢
                                    r_rcv_cnt <= r_rcv_cnt + 1'b1;                          //����λ����
                                    r_parity_check <= r_parity_check + sync_uart_rx;        //У��λ���ӷ���֤�ߵ�ƽ����ż
                                end
                        end
                    STATE_PARITY:begin
                            if(baud_pulse)
                                begin
                                //У���⣬��ȷ��o_verify_flg���ߣ��������led��⣬�����˸���ʾ�д������ݷ���
                                    if(r_parity_check  == PARITY_TYPE+sync_uart_rx) //+ sync_uart_rx
                                        o_verify_flg <= 1'b1;
                                    else
                                        o_verify_flg <= 1'b0;
                                end
                            else
                                        o_verify_flg <=o_verify_flg;// o_ld_parity;
                        end
                    STATE_END:begin
                            if(baud_pulse)
                                begin
                                //û��У��λ����У��λ��ȷʱ��������ݣ�����ֱ�Ӷ�������
                                    if(PARITY_ON == 0 || o_verify_flg)
                                        begin
                                            o_uart_data <= r_data_rcv;
                                            o_rx_done <= 1'b1;
                                        end
                                end
                            else
                                begin
                                    o_rx_done <= 1'b0;
                                end
                            
                            if(baud_cnt == 16'h0000)
                                    baud_valid <= 1'b0;
                        end
                    default:;
                endcase
        end
    
    
endmodule


