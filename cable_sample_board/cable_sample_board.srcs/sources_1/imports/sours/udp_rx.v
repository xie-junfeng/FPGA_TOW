
//////////////////////////////////////////////////////////////////////////////////
// Company: SAU
// Engineer: XIE JUNBO
// 
// Create Date: 2023/05/07 10:11:18
// Design Name: 
// Module Name: ETH
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

module udp_rx(
    input                clk         ,    //ʱ���ź�
    input                rst_n       ,    //��λ�źţ��͵�ƽ��Ч
    
    output  reg          crc_en       , //CRC��ʼУ��ʹ��
    output  reg          crc_clr      , //CRC���ݸ�λ�ź� 
//    output  reg  [31:0]  rec_data_crc ,    
    input        [31:0]  crc_data   , //CRCУ������
    input         [7:0]  crc_next   , //CRC�´�У���������
    output  reg          erron     , //CRC��ʼУ��ʹ��
    output  reg  [7:0]  rec_data_cccrc    ,    //��̫�����յ�����
    input                gmii_rx_dv  ,    //GMII����������Ч�ź�&&( fifo_write_ready==1'b1)
    input        [7:0]   gmii_rxd    ,    //GMII��������
    output  reg          rec_pkt_done,    //��̫���������ݽ�������ź�
    output  reg          rec_en      ,    //��̫�����յ�����ʹ���ź�
    input                rec_data_ready    ,    //GMII��������
    output  reg  [31:0]  rec_data    ,    //��̫�����յ�����
    output  reg  [15:0]  rec_byte_num     //��̫�����յ���Ч���� ��λ:byte     
    );

//parameter define
//������MAC��ַ 00-11-22-33-44-55
parameter BOARD_MAC = 48'h00_11_22_33_44_55; 
//������IP��ַ 192.168.1.10 
parameter BOARD_IP = {8'd192,8'd168,8'd1,8'd123};

localparam  st_idle     = 7'b000_0001; //��ʼ״̬���ȴ�����ǰ����
localparam  st_preamble = 7'b000_0010; //����ǰ����״̬ 
localparam  st_eth_head = 7'b000_0100; //������̫��֡ͷ
localparam  st_ip_head  = 7'b000_1000; //����IP�ײ�
localparam  st_udp_head = 7'b001_0000; //����UDP�ײ�
localparam  st_rx_data  = 7'b010_0000; //������Ч����
localparam  st_rx_end   = 7'b100_0001; //���ս���
localparam  st_rx_crc   = 7'b100_0000; //���ս���

localparam  ETH_TYPE    = 16'h0800   ; //��̫��Э������ IPЭ��


wire [6:0]  next_state1;
//reg define
reg  [6:0]   cur_state       ;
reg  [6:0]   next_state      ;
                             
reg          skip_en         ; //����״̬��תʹ���ź�
reg          error_en        ; //��������ʹ���ź�
reg  [4:0]   cnt             ; //�������ݼ�����
reg  [47:0]  des_mac         ; //Ŀ��MAC��ַ
reg  [15:0]  eth_type        ; //��̫������
reg  [31:0]  des_ip          ; //Ŀ��IP��ַ
reg  [5:0]   ip_head_byte_num; //IP�ײ�����
reg  [15:0]  udp_byte_num    ; //UDP����
reg  [15:0]  data_byte_num   ; //���ݳ���
reg  [15:0]  data_cnt        ; //��Ч���ݼ���    
reg  [1:0]   rec_en_cnt      ; //8bitת32bit������
reg  [31:0]  crc_data_sum;
reg          rx_done_t         ; //����״̬��תʹ���ź�
reg  [31:0]  rec_data_crc ;
//*****************************************************
//**                    main code
//*****************************************************
assign next_state1=next_state;
//  ila_0 youe3 (
//	.clk(clk), // input wire clk
//	.probe0(rec_en), // input wire [0:0]  probe0  
//	.probe1(gmii_rx_dv), // input wire [0:0]  probe1 
//	.probe2(gmii_rxd), // input wire [7:0]  probe3 
//	.probe3(next_state1), // input wire [10:0]  probe4 
//	.probe4(0), // input wire [10:0]  probe5
//    .probe5(rec_data)  // input wire [15:0]  probe4 

//);
//(����ʽ״̬��)ͬ��ʱ������״̬ת��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= st_idle;  
    else
        cur_state <= next_state;
end

//����߼��ж�״̬ת������
always @(*) begin
    next_state = st_idle;
    case(cur_state)
        st_idle : begin                                     //�ȴ�����ǰ����
            if(skip_en) 
                next_state = st_preamble;
            else
                next_state = st_idle;    
        end
        st_preamble : begin                                 //����ǰ����
            if(skip_en) 
                next_state = st_eth_head;
            else if(error_en) 
                next_state = st_rx_end;    
            else
                next_state = st_preamble;    
        end
        st_eth_head : begin                                 //������̫��֡ͷ
            if(skip_en) 
                next_state = st_ip_head;
            else if(error_en) 
                next_state = st_rx_end;
            else
                next_state = st_eth_head;           
        end  
        st_ip_head : begin                                  //����IP�ײ�
            if(skip_en)
                next_state = st_udp_head;
            else if(error_en)
                next_state = st_rx_end;
            else
                next_state = st_ip_head;       
        end 
        st_udp_head : begin                                 //����UDP�ײ�
            if(skip_en)
                next_state = st_rx_data;
            else
                next_state = st_udp_head;    
        end                
        st_rx_data : begin                                  //������Ч����
            if(skip_en)
                next_state = st_rx_crc;
            else
                next_state = st_rx_data;    
        end
         st_rx_crc : begin                                  //������Ч����
            if(skip_en)
                next_state = st_rx_end;
            else
                next_state = st_rx_crc;    
        end       
                                   
        st_rx_end : begin                                   //���ս���
            if(skip_en)
                next_state = st_idle;
            else
                next_state = st_rx_end;          
        end
        default : next_state = st_idle;
    endcase                                          
end    

//ʱ���·����״̬���,������̫������
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        crc_en <= 1'b0;
        skip_en <= 1'b0;
        error_en <= 1'b0;
        cnt <= 5'd0;
        des_mac <= 48'd0;
        eth_type <= 16'd0;
        des_ip <= 32'd0;
        ip_head_byte_num <= 6'd0;
        udp_byte_num <= 16'd0;
        data_byte_num <= 16'd0;
        data_cnt <= 16'd0;
        rec_en_cnt <= 2'd0;
        rec_en <= 1'b0;
        rec_data <= 32'd0;
        rec_pkt_done <= 1'b0;
        rec_byte_num <= 16'd0;
        erron<= 1'd0;
        rx_done_t<= 1'b0; 
        rec_data_crc<= 32'd0;
        crc_data_sum<= 32'd0;
        rec_data_cccrc<= 7'd0;
    end
    else begin

        rx_done_t<= 1'b0; 
        crc_en <= 1'b0;
        skip_en <= 1'b0;
        error_en <= 1'b0;  
        rec_en <= 1'b0;
        rec_pkt_done <= 1'b0;
        case(next_state)
            st_idle : begin
                if((gmii_rx_dv == 1'b1) && (gmii_rxd == 8'h55)&&( rec_data_ready==1'b1)) 
                    skip_en <= 1'b1;
            end
            st_preamble : begin
                if(gmii_rx_dv) begin                         //����ǰ����
                    cnt <= cnt + 5'd1;
                    if((cnt < 5'd6) && (gmii_rxd != 8'h55))  //7��8'h55  
                        error_en <= 1'b1;
                    else if(cnt==5'd6) begin
                        cnt <= 5'd0;
                        if(gmii_rxd==8'hd5)                  //1��8'hd5
                            skip_en <= 1'b1;
                        else
                            error_en <= 1'b1;    
                    end  
                end  
            end
            st_eth_head : begin
                crc_en <= 1'b1;
                if(gmii_rx_dv) begin
                 rec_data_cccrc <= gmii_rxd;
                 
                    cnt <= cnt + 5'b1;
                    if(cnt < 5'd6) 
                        des_mac <= {des_mac[39:0],gmii_rxd}; //Ŀ��MAC��ַ
                    else if(cnt == 5'd12) 
                        eth_type[15:8] <= gmii_rxd;          //��̫��Э������
                    else if(cnt == 5'd13) begin
                        eth_type[7:0] <= gmii_rxd;
                        cnt <= 5'd0;
                        //�ж�MAC��ַ�Ƿ�Ϊ������MAC��ַ���߹�����ַ
                        if(((des_mac == BOARD_MAC) ||(des_mac == 48'hff_ff_ff_ff_ff_ff))
                       && eth_type[15:8] == ETH_TYPE[15:8] && gmii_rxd == ETH_TYPE[7:0])            
                            skip_en <= 1'b1;
                        else
                            error_en <= 1'b1;
                    end        
                end  
            end
            st_ip_head : begin
                crc_en <= 1'b1;

                if(gmii_rx_dv) begin
                     rec_data_cccrc <= gmii_rxd;                
                
                    cnt <= cnt + 5'd1;
                    if(cnt == 5'd0)
                        ip_head_byte_num <= {gmii_rxd[3:0],2'd0};
                    else if((cnt >= 5'd16) && (cnt <= 5'd18))
                        des_ip <= {des_ip[23:0],gmii_rxd};   //Ŀ��IP��ַ
                    else if(cnt == 5'd19) begin
                        des_ip <= {des_ip[23:0],gmii_rxd}; 
                        //�ж�IP��ַ�Ƿ�Ϊ������IP��ַ
                        if((des_ip[23:0] == BOARD_IP[31:8])
                            && (gmii_rxd == BOARD_IP[7:0])) begin  
                            if(cnt == ip_head_byte_num- 1'b1 ) begin
                                skip_en <=1'b1;                     
                                cnt <= 5'd0;
                            end                             
                        end    
                        else begin            
                        //IP����ֹͣ��������                        
                            error_en <= 1'b1;               
                            cnt <= 5'd0;
                        end                                                  
                    end                          
                    else if(cnt == ip_head_byte_num - 1'b1) begin 
                        skip_en <=1'b1;                      //IP�ײ��������
                        cnt <= 5'd0;                    
                    end    
                end                                
            end 
            st_udp_head : begin
                crc_en <= 1'b1;
                if(gmii_rx_dv) begin
                    rec_data_cccrc <= gmii_rxd;                 
                
                    cnt <= cnt + 5'd1;
                    if(cnt == 5'd4)
                        udp_byte_num[15:8] <= gmii_rxd;      //����UDP�ֽڳ��� 
                    else if(cnt == 5'd5)
                        udp_byte_num[7:0] <= gmii_rxd;
                    else if(cnt == 5'd7) begin
                        //��Ч�����ֽڳ��ȣ���UDP�ײ�8���ֽڣ����Լ�ȥ8��
                        data_byte_num <= udp_byte_num - 16'd8;    
                        skip_en <= 1'b1;
                        cnt <= 5'd0;
                    end  
                end                 
            end          
            st_rx_data : begin  
                crc_en <= 1'b1;       
                //�������ݣ�ת����32bit            
                if(gmii_rx_dv) begin
                    rec_data_cccrc <= gmii_rxd;  
                    data_cnt <= data_cnt + 16'd1;
                    rec_en_cnt <= rec_en_cnt + 2'd1;
                    if(data_cnt == data_byte_num - 16'd1) begin
                        skip_en <= 1'b1;                    //��Ч���ݽ������
                        data_cnt <= 16'd0;
                        rec_en_cnt <= 2'd0;
                        rec_pkt_done <= 1'b1;               
                        rec_en <= 1'b1;                     
                        rec_byte_num <= data_byte_num;
                    end    
                    //���յ������ݷ�����rec_data�ĸ�λ,���Ե����ݲ���4�ı���ʱ,
                    //��λ����Ϊ��Ч���ݣ��ɸ�����Ч�ֽ������ж�(rec_byte_num)
                    if(rec_en_cnt == 2'd0)
                        rec_data[31:24] <= gmii_rxd;
                    else if(rec_en_cnt == 2'd1)
                        rec_data[23:16] <= gmii_rxd;
                    else if(rec_en_cnt == 2'd2) 
                        rec_data[15:8] <= gmii_rxd;        
                    else if(rec_en_cnt==2'd3) begin
                        rec_en <= 1'b1;
                        rec_data[7:0] <= gmii_rxd;
                    end    
                end  
            end    
            st_rx_crc : begin                               //�������ݽ������   
               if(gmii_rx_dv) begin
                    cnt <= cnt + 5'd1;
                    if(cnt == 5'd0)begin
                        rec_data_crc[31:24] <= gmii_rxd;      //����UDP�ֽڳ���
                        crc_data_sum[31:24] <= {~crc_next[0], ~crc_next[1], ~crc_next[2],~crc_next[3],
                                     ~crc_next[4], ~crc_next[5], ~crc_next[6],~crc_next[7]}; 
                           end
                    else if(cnt == 5'd1)begin
                      rec_data_crc[23:16] <= gmii_rxd;
                      crc_data_sum[23:16] <= {~crc_data[16], ~crc_data[17], ~crc_data[18],~crc_data[19],
                                 ~crc_data[20], ~crc_data[21], ~crc_data[22],~crc_data[23]};    
                           end                  
                    else if(cnt == 5'd2)begin
                       rec_data_crc[15:8] <= gmii_rxd;
                       crc_data_sum[15:8] <= {~crc_data[8], ~crc_data[9], ~crc_data[10],~crc_data[11],
                                 ~crc_data[12], ~crc_data[13], ~crc_data[14],~crc_data[15]};                          
                        end
                    else if(cnt == 5'd3)begin
                        rec_data_crc[7:0] <= gmii_rxd;
                        crc_data_sum[7:0] <= {~crc_data[0], ~crc_data[1], ~crc_data[2],~crc_data[3],
                                 ~crc_data[4], ~crc_data[5], ~crc_data[6],~crc_data[7]};                                                                         
                        skip_en <= 1'b1;
                        cnt <= 5'd0;
                        rx_done_t<= 1'b1;
                        if(crc_data_sum!=rec_data_crc)
                            erron<= 1'd1;
                        end
                    end  
                   else if(gmii_rx_dv == 1'b0 && skip_en == 1'b0)
                        skip_en <= 1'b1;    
                end  
            st_rx_end : begin                               //�������ݽ������   
                if(gmii_rx_dv == 1'b0 && skip_en == 1'b0)
                    skip_en <= 1'b1; 
            end                            
            default : ;
        endcase                                                        
    end
end
//��������źż�crcֵ��λ�ź�
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        crc_clr <= 1'b0;
    end
    else begin
        crc_clr <= rx_done_t;
    end
end
endmodule