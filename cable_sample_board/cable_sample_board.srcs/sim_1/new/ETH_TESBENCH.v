//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2023/09/19 11:03:03
//// Design Name: 
//// Module Name: ETH_TESBENCH
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
///////////////////////////////////////////////////////////////////////////////////

//module CS_TESBENCH(
//    );
//reg            rst_n                    ;

//wire           eth_read_clk             ;
//wire           eth_read_valid           ;
//wire   [3:0]   eth_read_data_4          ;

//wire           eth_write_clk            ;
//wire           eth_write_valid          ;
//wire   [3:0]   eth_write_data_4         ;
//wire           eth_rst_n                ;

//// Ouput DA relevant signal 
//wire            da_write_clk            ;
//wire     [7:0]  da_write_data           ;
// //AD0
//wire            ad0_write_clk            ;
//wire     [9:0]  ad0_write_data           ;
//wire            ad0_write_oe            ;
// //AD1
//wire            ad1_write_clk            ;
//wire     [9:0]  ad1_write_data           ;
//wire            ad1_write_oe            ;
 

//reg   [10:0]  cnt;
//reg   [10:0]  cnt1;
//reg  [7:0]   eth_rxd_gmii;
//reg     eth_rx_ctl_gmii;
//reg     eth_rxc_gmii=0;
//reg     sys_clk=0;

//reg eth_ready_ready;
//reg   flg;

//wire         gmii_rx_clk  ;
//wire         gmii_rx_dv   ;
//wire  [7:0]  gmii_rxd     ;

//CS_TOP U_CS_TOP(
//     .sys_clk              (sys_clk)                              ,                                           
//     .rst_n                   (rst_n)                             ,                                           
// //Ethernet relevant signal for recive                                                             
//      .eth_read_clk           (eth_read_clk)                        ,  //Ethernet reciving clock singnal        
//      .eth_read_valid         (eth_read_valid)                      ,  //Ethernet reciving valid singnal        
//      .eth_read_data_4        (eth_read_data_4)                     ,  //Ethernet reciving data singnal      
// //Ethernet relevant signal for send                                                               
//      .eth_write_clk          (eth_write_clk)                       ,  //Ethernet writing clock singnal         
//      .eth_write_valid        (eth_write_valid)                     ,  //Ethernet writing valid singnal         
//      .eth_write_data_4       (eth_write_data_4)                    ,  //Ethernet writing data singnal          
//      .eth_rst_n              (eth_rst_n)                           ,  //Ethernet reset singnal         
       
// //Ouput DA relevant signal      
//      .da_write_clk            (da_write_clk)                       , 
//      .da_write_data           (da_write_data)                      ,
//  //AD0     
//      .ad0_write_clk            (ad0_write_clk)                     ,    
//      .ad0_write_data           (ad0_write_data)                    ,     
//      .ad0_write_oe             (ad0_write_oe)                     ,                  
//  //AD1
//      .ad1_write_clk            (ad1_write_clk)                     ,    
//      .ad1_write_data           (ad1_write_data)                    ,     
//      .ad1_write_oe             (ad1_write_oe)                              
//); 

// gmii_to_rgmii_up u_gmii_to_rgmii_up(
//    .gmii_tx_clk              (eth_rxc_gmii),
//    .gmii_tx_en               (eth_rx_ctl_gmii),
//    .gmii_txd                 (eth_rxd_gmii   ),
//    .rgmii_txc                (eth_read_clk),
//    .rgmii_tx_ctl             (eth_read_valid),
//    .rgmii_txd                (eth_read_data_4)         
    
//    ); 
//     rgmii_rx_tesbench u_rgmii_rx_tesbench(
//    .idelay_clk              (eth_rxc_gmii),
//    .rgmii_rxc               (eth_rxc_gmii),
//    .rgmii_rx_ctl             (eth_write_valid   ),
//    .rgmii_rxd                (eth_write_data_4),
    
//    .gmii_rx_clk              (gmii_rx_clk),
//    .gmii_rx_dv               (gmii_rx_dv) ,
//    .gmii_rxd                 (gmii_rxd)       
    
//    ); 

//parameter WIDTH=8;
//parameter DEPTH=122;
//parameter SEND_DEPTH=960;
//parameter SEND_DEPTH_commd=64;
//parameter FILE_PATH_A = "C:/Users/xie/Desktop/data3.txt";
////parameter FILE_PATH_B = "C:/Users/xie/Desktop/test.txt";
////parameter FILE_PATH_C = "C:/Users/xie/Desktop/data1.txt"; 

//integer i,j,k;
//integer file_r;
 
//reg[WIDTH-1:0]data0[DEPTH-1:0];
//reg[WIDTH-1:0]data1[DEPTH-1:0];
//reg[WIDTH-1:0]data2[DEPTH-1:0]; 
 
 
// reg  [7:0]da1;
// reg  [7:0]da2; 
 
// assign  ad0_write_data=da1;
// assign  ad1_write_data=da2;
 
//initial begin 
//    rst_n = 1'b1;
//    #(20);
//    rst_n = 1'b0;
//    #(40);
//    rst_n = 1'b1;
//end


//initial begin
//    forever begin
//        #(10) sys_clk = ~sys_clk;
//    end
//end
    
//initial begin
//    forever begin
//        #(2.5) eth_rxc_gmii = ~eth_rxc_gmii;
//    end
//end   
    
////初始化以太网所需的数据。
//initial begin
//    file_r = $fopen(FILE_PATH_A,"r");//上位机以太网发送的数据
//    for(i=0;i<DEPTH;i=i+1)
//        $fscanf(file_r,"%d",data0[i]);
//        $fclose(file_r);
//end    

////初始化以太网所需的数据。
//initial begin
//    for(j=0;j<SEND_DEPTH_commd;j=j+1)
//        data1[j]<=j;
//end 


//initial begin
//    for(k=0;k<SEND_DEPTH;k=k+1)
//        data1[k]<=k;
//end 


//initial begin
//        eth_ready_ready = 0;
//        flg = 0;
//        #(20000)eth_ready_ready = 1;
//        #(30000)flg = 1;
//        #(20)flg = 0;
//         #(30000)flg = 1;
//        #(20)flg = 0;       


//end  


//always @(posedge da_write_clk or negedge rst_n) begin
//    if(!rst_n) begin
//         da1<=0;
//         da2<=0;

//    end
//    else begin 
//    da1<=da_write_data;
//    da2<=da_write_data;
//    end
//end
////以太网給入仿真数据 eth_tx_ctl
//always @(posedge eth_rxc_gmii or negedge rst_n) begin
//    if(!rst_n) begin
//        cnt<=11'd0;
//        cnt1<=11'd1074;
//        eth_rx_ctl_gmii<= 1'd0;
//        eth_rxd_gmii   <= 1'd0;
//    end
//    else begin 
       
//        eth_rx_ctl_gmii<= 1'd0;
//        eth_rxd_gmii<=8'd0;
//        if(cnt<DEPTH & eth_ready_ready)begin
//            eth_rxd_gmii<=data0[cnt];
//            eth_rx_ctl_gmii<= 1'd1;
//            cnt<=cnt+1'd1;
//        end
//        else begin
//        if(flg)
//         cnt<=0;
//        else
//        cnt<=cnt;  
////                    eth_rxd_gmii<=1'd0;
////            eth_rx_ctl_gmii<= 1'd0;
////       if(cnt1<11'd1074 )begin
////            eth_rxd_gmii<=data2[cnt1];
////            eth_rx_ctl_gmii<= 1'd1;
////            cnt1<=cnt1+1'd1;
////        end
////        else begin
////            eth_rxd_gmii<=0;
////            eth_rx_ctl_gmii<= 1'd0;
//////            if(flg_done)
//////            cnt1<=0;   
//////            else
////            cnt1<=cnt1; 
////            end
//            end
//    end
//end
    
    
//endmodule
