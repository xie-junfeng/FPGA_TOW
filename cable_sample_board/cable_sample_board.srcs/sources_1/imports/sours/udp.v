
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
    input                rst_n       , //复位信号，低电平有效
    //GMII接口
    input                gmii_rx_clk , //GMII接收数据时钟

    input                gmii_rx_dv  , //GMII输入数据有效信号
    input        [7:0]   gmii_rxd    , //GMII输入数据
    input                gmii_tx_clk , //GMII发送数据时钟    
    output               gmii_tx_en  , //GMII输出数据有效信号
    output       [7:0]   gmii_txd    , //GMII输出数据 
    //用户接口
    output               erro_recive, //以太网单包数据接收完成信号
    output               rec_pkt_done, //以太网单包数据接收完成信号
    output               rec_en      , //以太网接收的数据使能信号
     input               rec_data_ready,
    output       [31:0]  rec_data    , //以太网接收的数据
    output       [15:0]  rec_byte_num, //以太网接收的有效字节数 单位:byte  
       
    input                tx_start_en , //以太网开始发送信号
    input        [31:0]  tx_data     , //以太网待发送数据  
//    input        [15:0]  tx_byte_num , //以太网发送的有效字节数 单位:byte  
    input        [47:0]  des_mac     , //发送的目标MAC地址
    input        [31:0]  des_ip      , //发送的目标IP地址    
    output               tx_done     , //以太网发送完成信号
    output               tx_req        //读数据请求信号    
    );

//parameter define
//开发板MAC地址 00-11-22-33-44-55
parameter BOARD_MAC = 48'h00_11_22_33_44_55;    
//开发板IP地址 192.168.1.10     
parameter BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};
//目的MAC地址 ff_ff_ff_ff_ff_ff
parameter  DES_MAC  = 48'hff_ff_ff_ff_ff_ff;
//目的IP地址 192.168.1.102     
parameter  DES_IP   = {8'd192,8'd168,8'd1,8'd102};

parameter   DATA_SEND_NUMBER_8    = 16'd1024; 

wire  [7:0]  rec_data_cccrc; //CRC下次校验完成数据
//wire define
wire          crc_en  ; //CRC开始校验使能
wire          crc_clr ; //CRC数据复位信号 
wire  [7:0]   crc_d8_send  ; //输入待校验8位数据
wire  [31:0]  crc_data; //CRC校验数据
wire  [31:0]  crc_next; //CRC下次校验完成数据

wire          crc_clr1 ; //CRC数据复位信号 
wire          crc_en1  ; //CRC开始校验使能
wire  [7:0]   crc_d8_recive  ; //输入待校验8位数据
wire  [31:0]  crc_data1; //CRC校验数据
wire  [31:0]  crc_next1; //CRC下次校验完成数据

//*****************************************************
//**                    main code
//*****************************************************

assign  crc_d8_send = gmii_txd;
assign  crc_d8_recive = rec_data_cccrc;
//以太网接收模块    
udp_rx 
   #(
    .BOARD_MAC       (BOARD_MAC),         //参数例化gmii_rxd_ready
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

//以太网发送模块
udp_tx
   #(
    .DATA_SEND_NUMBER_8        (DATA_SEND_NUMBER_8  ), 
    .BOARD_MAC       (BOARD_MAC),         //参数例化
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

//以太网发送CRC校验模块
crc32_d8   u_crc32_d8_send(
    .clk             (gmii_tx_clk),                      
    .rst_n           (rst_n      ),                          
    .data            (crc_d8_send     ),            
    .crc_en          (crc_en     ),                          
    .crc_clr         (crc_clr    ),                         
    .crc_data        (crc_data   ),                        
    .crc_next        (crc_next   )                         
    );
//以太网发送CRC校验模块
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