
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

module udp(
    input                rst_n       , //��λ�źţ��͵�ƽ��Ч
    //GMII�ӿ�
    input                gmii_rx_clk , //GMII��������ʱ��

    input                gmii_rx_dv  , //GMII����������Ч�ź�
    input        [7:0]   gmii_rxd    , //GMII��������
    input                gmii_tx_clk , //GMII��������ʱ��    
    output               gmii_tx_en  , //GMII���������Ч�ź�
    output       [7:0]   gmii_txd    , //GMII������� 
    //�û��ӿ�
    output               erro_recive, //��̫���������ݽ�������ź�
    output               rec_pkt_done, //��̫���������ݽ�������ź�
    output               rec_en      , //��̫�����յ�����ʹ���ź�
     input               rec_data_ready,
    output       [31:0]  rec_data    , //��̫�����յ�����
    output       [15:0]  rec_byte_num, //��̫�����յ���Ч�ֽ��� ��λ:byte  
       
    input                tx_start_en , //��̫����ʼ�����ź�
    input        [31:0]  tx_data     , //��̫������������  
//    input        [15:0]  tx_byte_num , //��̫�����͵���Ч�ֽ��� ��λ:byte  
    input        [47:0]  des_mac     , //���͵�Ŀ��MAC��ַ
    input        [31:0]  des_ip      , //���͵�Ŀ��IP��ַ    
    output               tx_done     , //��̫����������ź�
    output               tx_req        //�����������ź�    
    );

//parameter define
//������MAC��ַ 00-11-22-33-44-55
parameter BOARD_MAC = 48'h00_11_22_33_44_55;    
//������IP��ַ 192.168.1.10     
parameter BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};
//Ŀ��MAC��ַ ff_ff_ff_ff_ff_ff
parameter  DES_MAC  = 48'hff_ff_ff_ff_ff_ff;
//Ŀ��IP��ַ 192.168.1.102     
parameter  DES_IP   = {8'd192,8'd168,8'd1,8'd102};

parameter   DATA_SEND_NUMBER_8    = 16'd1024; 

wire  [7:0]  rec_data_cccrc; //CRC�´�У���������
//wire define
wire          crc_en  ; //CRC��ʼУ��ʹ��
wire          crc_clr ; //CRC���ݸ�λ�ź� 
wire  [7:0]   crc_d8_send  ; //�����У��8λ����
wire  [31:0]  crc_data; //CRCУ������
wire  [31:0]  crc_next; //CRC�´�У���������

wire          crc_clr1 ; //CRC���ݸ�λ�ź� 
wire          crc_en1  ; //CRC��ʼУ��ʹ��
wire  [7:0]   crc_d8_recive  ; //�����У��8λ����
wire  [31:0]  crc_data1; //CRCУ������
wire  [31:0]  crc_next1; //CRC�´�У���������

//*****************************************************
//**                    main code
//*****************************************************

assign  crc_d8_send = gmii_txd;
assign  crc_d8_recive = rec_data_cccrc;
//��̫������ģ��    
udp_rx 
   #(
    .BOARD_MAC       (BOARD_MAC),         //��������gmii_rxd_ready
    .BOARD_IP        (BOARD_IP )
    )
   u_udp_rx(
    .clk             (gmii_rx_clk ),        
    .rst_n           (rst_n       ),
    
    .crc_en          (crc_en1   ), 
    .crc_clr         (crc_clr1   ),  
      
    .crc_data        (crc_data1   ),          
    .crc_next        (crc_next1[31:24]),
    .erron           (erro_recive   ),  
    .rec_data_cccrc           (rec_data_cccrc   ),  

             
    .gmii_rx_dv      (gmii_rx_dv  ),                                 
    .gmii_rxd        (gmii_rxd    ),       
    .rec_pkt_done    (rec_pkt_done),      
    .rec_en          (rec_en      ), 
    .rec_data_ready  (rec_data_ready  ),               
    .rec_data        (rec_data    ),          
    .rec_byte_num    (rec_byte_num)       
    );                                    

//��̫������ģ��
udp_tx
   #(
    .DATA_SEND_NUMBER_8        (DATA_SEND_NUMBER_8  ), 
    .BOARD_MAC       (BOARD_MAC),         //��������
    .BOARD_IP        (BOARD_IP ),
    .DES_MAC         (DES_MAC  ),
    .DES_IP          (DES_IP   )
    )
   u_udp_tx(
    .clk             (gmii_tx_clk),        
    .rst_n           (rst_n      ),             
    .tx_start_en     (tx_start_en),                   
    .tx_data         (tx_data    ),           
//    .tx_byte_num     (tx_byte_num),    
    .des_mac         (des_mac    ),
    .des_ip          (des_ip     ),    
    .crc_data        (crc_data   ),          
    .crc_next        (crc_next[31:24]),
    .tx_done         (tx_done    ),           
    .tx_req          (tx_req     ),            
    .gmii_tx_en      (gmii_tx_en ),         
    .gmii_txd        (gmii_txd   ),       
    .crc_en          (crc_en     ),            
    .crc_clr         (crc_clr    )            
    );                                      

//��̫������CRCУ��ģ��
crc32_d8   u_crc32_d8_send(
    .clk             (gmii_tx_clk),                      
    .rst_n           (rst_n      ),                          
    .data            (crc_d8_send     ),            
    .crc_en          (crc_en     ),                          
    .crc_clr         (crc_clr    ),                         
    .crc_data        (crc_data   ),                        
    .crc_next        (crc_next   )                         
    );
//��̫������CRCУ��ģ��
crc32_d8   u_crc32_d8_recive(
    .clk             (gmii_rx_clk),                      
    .rst_n           (rst_n      ),                          
    .data            (crc_d8_recive),            
    .crc_en          (crc_en1     ),                          
    .crc_clr         (crc_clr1    ),                         
    .crc_data        (crc_data1   ),                        
    .crc_next        (crc_next1   )                         
    );
    
endmodule