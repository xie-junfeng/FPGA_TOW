
//////////////////////////////////////////////////////////////////////////////////
// Company: SAU
// Engineer: XIE JUNBO
// 
// Create Date: 2022/05/07 10:11:18
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

module ETH(
    input             clk_200mHz                          , 
    input             rst_n                               ,  
    //Ethernet relevant signal for recive                         
    input             eth_read_clk                        ,  //Ethernet reciving clock singnal 
    input             eth_read_valid                      ,  //Ethernet reciving valid singnal 
    input    [3:0]    eth_read_data_4                     ,  //Ethernet reciving data singnal 
    //Ethernet relevant signal for send       
    output            eth_write_clk                       ,  //Ethernet writing clock singnal 
    output            eth_write_valid                     ,  //Ethernet writing valid singnal 
    output   [3:0]    eth_write_data_4                    ,  //Ethernet writing data singnal 
    output            eth_rst_n                           ,  //Ethernet reset singnal 
    //Related signals for input data type1
    input             types_write_clock                  ,  //out_Common Clockticks for Types 1 and 2
    output            types_write_ready                  ,  //ready for write types1  data  
    input             types_write_valid                  ,  //valid for write types1 data 
    input    [7:0]    types_write_data_8                 ,  //types1 data for write
    //Output relevant signals
    input             types_read_clock                   ,  // out_clock for read types1  
    input             types_read_ready                   ,  //ready for read types1 data
    output            types_read_valid                   ,  //valid for read types1 data
    output   [7:0]    types_read_data_8                  ,   //types1 data for read    
    //Clock stable signal
    input             locked                             
    );
    
  
wire ETHTOP_FSC_eth_tx_clk;    
wire ETHTOP_FRC_eth_rx_clk;  

wire types_read_clock_1x4;
wire udp_tx_req;
wire udp_rec_pkt_done;
wire udp_tx_done;
wire udp_tx_start_en;



wire valid_in_32_recive;
wire [31:0] data_in_32_recive;
wire wr_rst_busy;
wire udp_rec_en;

wire [31:0]   data_out_32  ;
wire [31:0]   udp_rec_data  ;
wire [31:0]   udp_tx_data  ;
//wire transfer_flag;
wire empty;
wire erro_recive;

wire valid_out_32_8;
wire [7:0]data_out_32_8;

wire       types_write_valid_r;
wire [7:0]  types1_write_data_8_r;  
wire       FRC_fifo_write_ready;
//parameter define
//������MAC��ַ 00-11-22-33-44-55
parameter  BOARD_MAC = 48'h00_11_22_33_44_55;     
//������IP��ַ 192.168.1.10
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  
//Ŀ��MAC��ַ ff_ff_ff_ff_ff_ff
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;    
//Ŀ��IP��ַ 192.168.1.102     
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd102};    
//���ܵ���8λָ�����?????   
parameter   HEARDS_NUMBER_8    = 10'd64; 
//���ܵ���10λ���ݸ���   
parameter   DATA_NUMBER_8    = 10'd960; 
//���ܵ���10λ���ݸ���   
//parameter   DATA_AND_HEARDS_NUMBER_32    = 15'd976; 
//���ܵ���10λ���ݸ���   
parameter   DATA_NUMBER_32    = 8'd18; 
//���ܵ���10λ���ݸ���   
parameter   DATA_SEND_NUMBER_8    = 15'd976; 


//1bit data Two level deposit
TLD_TWO TLD_TWO(
    .clk                        (types_write_clock),   
    .rst_n                      (rst_n),   
    .a                          (types_write_valid),
    .b                          (types_write_valid_r)
    );   


//8bit data Two level deposit
TLD_TWO_8 U_TLD_TWO_8(
    .clk                        (types_write_clock),   
    .rst_n                      (rst_n),   
    .a                          (types_write_data_8),
    .b                          (types1_write_data_8_r)
    );  

//FIFO data recive control module
FRC#(          
    .DATA_NUMBER_32             (DATA_NUMBER_32   )          
    )   
U_FRC(
    .rst_n                      (rst_n),
    
    .fifo_read_clk              (types_read_clock_1x4 & locked),
    .fifo_read_ready            (1),
    .fifo_read_valid          (valid_in_32_recive),
    .fifo_read_data           (data_in_32_recive) ,
    
    .fifo_write_clk             (ETHTOP_FRC_eth_rx_clk),
    .fifo_write_ready           (FRC_fifo_write_ready),    
    .fifo_write_valid           (udp_rec_en      ),
    .fifo_write_data            (udp_rec_data    )
    );  
    
//FIFO data transmission control module
FSC#(          
    .DATA_SEND_NUMBER_8          (DATA_SEND_NUMBER_8   )          
    )    
U_FSC(    
    .rst_n                        (rst_n),   
         
    .fifo_write_clk              (types_write_clock), 
    .fifo_write_valid            (types_write_valid),
    .fifo_write_ready            (types_write_ready),
    .fifo_write_data             (types_write_data_8),
   
    .fifo_read_clk              (ETHTOP_FSC_eth_tx_clk),
    .fifo_read_valid            (),
    .fifo_read_ready            (udp_tx_req),
    .fifo_read_data             (udp_tx_data    ),
    .start                      (udp_tx_start_en    )    
    );  
    
    
//Ethernet communication top
ETHTOP  #(
    .DATA_SEND_NUMBER_8         (DATA_SEND_NUMBER_8), 
    .BOARD_MAC                  (BOARD_MAC),             
    .BOARD_IP                   (BOARD_IP ),          
    .DES_MAC                    (DES_MAC  ),       
    .DES_IP                     (DES_IP   )          
    )          
    U_ETHTOP(          
    .clk_200mHz                 (clk_200mHz), 
    .sys_rst_n                  (rst_n     ),  
    //��̫��RGMII�ӿ�             
    .eth_rxc                    (eth_read_clk),          
    .eth_rx_ctl                 (eth_read_valid ),    
    .eth_rxd                    (eth_read_data_4 ),   
    .eth_txc                    (eth_write_clk   ),   
    .eth_tx_ctl                 (eth_write_valid ),   
    .eth_txd                    (eth_write_data_4),      
    .eth_rst_n                  (eth_rst_n ),         

    .gmii_rx_clk                (ETHTOP_FRC_eth_rx_clk),
    .gmii_tx_clk                (ETHTOP_FSC_eth_tx_clk),       
    .udp_tx_start_en            (udp_tx_start_en),
    .tx_data                    (udp_tx_data),
    .udp_tx_done                (udp_tx_done),
    .tx_req                     (udp_tx_req ),

    .erro_recive                (erro_recive),    
    .rec_pkt_done               (udp_rec_pkt_done),
    .rec_data_ready             (FRC_fifo_write_ready),
    .rec_en                     (udp_rec_en      ),
    .rec_data                   (udp_rec_data    ),
    .rec_byte_num               ()
    );
    
//recive data from 32bit to 8bit

W32T8 U_W32T8(
    .clk                       (types_read_clock)   ,
    .rst_n                     (rst_n)              ,
    
    .valid_in                  (valid_in_32_recive) ,
    .data_in                   (data_in_32_recive)  ,
    
    .clk_out_fifo              (types_read_clock_1x4) ,
    .valid_out                 (types_read_valid)      ,
    .data_out                  (types_read_data_8)
);

endmodule
