`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 11:50:59
// Design Name: 
// Module Name: ETH_TOP
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
/////////////////////////////////////////////////////////////////////////////////

module CS_TOP(
    input             sys_clk                             , 
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
    //Ouput DA relevant signal 
    output              da_write_clk                      ,  
    output    [7:0]     da_write_data                     ,  
     //AD0
    output             ad0_write_clk                      , 
    input      [9:0]   ad0_write_data                     ,   
    output             ad0_write_oe                       ,  
    //AD1
    output             ad1_write_clk                      ,  
    input     [9:0]    ad1_write_data                     ,   
    output             ad1_write_oe                   
     
                    
    );
 wire   clk_200mHz;
 wire   types_read_clock;
 wire   locked;    
 wire   signa_write_ready;
 
 wire   encode0_write_ready;
 wire   encode1_write_ready;
 wire   source_write_ready;
 
 wire        encode0_read_valid;
 wire [7:0]  encode0_read_data_8;
  
 wire        encode1_read_valid;
 wire [7:0]  encode1_read_data_8;
 
 wire        decode_read_valid;
 wire        decode_read_valid_r;    
 wire  [7:0] decode_read_data_8;
 wire  [7:0] decode_read_data_8_r;


 wire              count_read_valid;
 wire   [8:0]      count_read_data;
 
 
 wire             encode2_write_ready;
 wire             ad_read_valid;
 wire    [7:0]    ad_read_data;  
 
 wire             types_write_clock      ;
 wire             types_write_ready;
 wire             types_write_valid;
 wire [7:0]       types_write_data_8;
 

 wire             types_read_ready;
 wire             types_read_valid;
 wire             [7:0]    types_read_data_8;
 wire             [7:0]     da_write_data1;
assign da_write_data=da_write_data1^8'b1111_1111;
assign da_write_clk=types_write_clock;
 //Ethernet recive  
ETH U_ETH(
     .clk_200mHz              (clk_200mHz&locked)                        ,                                           
     .rst_n                   (rst_n)                             ,                                           
 //Ethernet relevant signal for recive                                                             
      .eth_read_clk           (eth_read_clk)                        ,  //Ethernet reciving clock singnal        
      .eth_read_valid         (eth_read_valid)                      ,  //Ethernet reciving valid singnal        
      .eth_read_data_4        (eth_read_data_4)                     ,  //Ethernet reciving data singnal         
 //Ethernet relevant signal for send                                                               
      .eth_write_clk          (eth_write_clk)                       ,  //Ethernet writing clock singnal         
      .eth_write_valid        (eth_write_valid)                     ,  //Ethernet writing valid singnal         
      .eth_write_data_4       (eth_write_data_4)                    ,  //Ethernet writing data singnal          
      .eth_rst_n              (eth_rst_n)                           ,  //Ethernet reset singnal                 
 //Related signals for input data type1                                                            
      .types_write_clock     (types_write_clock&locked)           ,  //out_Common Clockticks for Types 1 and 2
      .types_write_ready     (types_write_ready)                  ,  //ready for write types1  data           
      .types_write_valid     (types_write_valid)                  ,  //valid for write types1 data            
      .types_write_data_8    (types_write_data_8)                 ,  //types1 data for write                                 
 //Output relevant signals                                                                         
      .types_read_clock       (types_read_clock&locked)             ,  // out_clock for read types1              
      .types_read_ready       (types_read_ready)                    ,  //ready for read types1 data              
      .types_read_valid       (types_read_valid)                    , //valid for read types1 data                 [7:0]    types_read_data_8                     //types1 data for read      
      .types_read_data_8      (types_read_data_8)                   ,
      .locked                 (locked)                             

);  


 //decode zhe input data  to encode   
DECODE U_DECODE(
       .clk                   (types_read_clock&locked)             ,                                           
       .rst_n                 (rst_n)                               ,                                           
 //                                                            
      .decode_write_ready     (types_read_ready)                    ,   
      .decode_write_valid     (types_read_valid)                    ,        
      .decode_write_data      (types_read_data_8)                   ,        
 //                                                            
      .decode_read_ready      (encode0_write_ready),          //  meet with fifo write ready and             
      .decode_read_valid      (decode_read_valid)                   ,      
      .decode_read_data_8     (decode_read_data_8)                            
    );
       
//Observe the frequency of writing and reading clocks, and choose an appropriate method to cross clock domains
//////////////////////////////////////////////////////////////////////
      //1bit data Two level deposit
      TLD_TWO_8 U_TLD_TWO_8(
          .clk                        (types_write_clock&locked),   
          .rst_n                      (rst_n),   
          .a                          (decode_read_data_8),
          .b                          (decode_read_data_8_r)
          );  
      
      //8bit data Two level deposit
      TLD_TWO U_TLD_TWO(
          .clk                        (types_write_clock&locked),   
          .rst_n                      (rst_n),   
          .a                          (decode_read_valid),
          .b                          (decode_read_valid_r)
          ); 
///////////////////////////////////////////////////////////////////////

WC U_WC   (
     .clk                         (types_write_clock&locked) ,
     .rst_n                       (rst_n)                     ,
     //
     .signa_write_ready           ( signa_write_ready),       
     .signa_write_valid           (decode_read_data_8_r[0] )     ,          
     .signa_write_data            (encode0_read_valid)  ,
     //
     .count_read_ready            (encode1_write_ready)         ,
     .count_read_valid            (count_read_valid)         ,
     .count_read_data             (count_read_data[7:0])         
);   

SST U_SST   (
     .source_read_clk             (types_write_clock&locked)  ,
     .rst_n                       (rst_n)                      ,
     //
     .source_write_ready          (source_write_ready)         ,
     .source_write_valid          (encode1_read_valid)         , 
     .source_write_data           (encode1_read_data_8)        , 
     // 
     .source_read_ready           (encode2_write_ready)             ,
     .source_read_valid           ()          ,
     .source_read_data_8          (da_write_data1)
);  

ADDA U_ADDA   (
     .clk                        (types_write_clock&locked)  ,
     .rst_n                       (rst_n)                      ,
     //
     .ad_read_ready              (encode2_write_ready)          ,
     .ad_read_valid              (ad_read_valid)          , 
     .ad_read_data               (ad_read_data)         , 
      //AD0
     .ad0_write_clk               (ad0_write_clk)           ,
     .ad0_write_data              (ad0_write_data)          ,
     .ad0_write_oe                (ad0_write_oe)            ,
      //AD0
     .ad1_write_clk               (ad1_write_clk)           ,
     .ad1_write_data              (ad1_write_data)          ,
     .ad1_write_oe                (ad1_write_oe)
);  


 //encode zhe input data 
ENCODE U_ENCODE(
       .clk                    (types_write_clock&locked)         ,                                           
       .rst_n                  (rst_n)                             ,                                           
 //   Send type 0 data                                                        
      .encode0_write_ready     (encode0_write_ready)              ,  
      .encode0_write_valid     (decode_read_valid_r)              ,   
      .encode0_write_data_8    (decode_read_data_8_r)             ,  

      .encode0_read_ready     (signa_write_ready)                , 
      .encode0_read_valid     (encode0_read_valid)                , 
      .encode0_read_data_8    (encode0_read_data_8)               , 
      
     
      .encode1_write_ready     (encode1_write_ready)              ,        
      .encode1_write_valid     (count_read_valid)                 ,       
      .encode1_write_data_8    (count_read_data[7:0])              ,  
      
      .encode1_read_ready      (source_write_ready)               ,        
      .encode1_read_valid      (encode1_read_valid)               ,       
      .encode1_read_data_8     (encode1_read_data_8)              ,        

      .encode2_write_ready     (encode2_write_ready)              ,  
      .encode2_write_valid     (ad_read_valid)                    ,     
      .encode2_write_data_8    (ad_read_data)                     , 
 //                                                              
      .encode_read_ready      (types_write_ready)                 ,          
      .encode_read_valid      (types_write_valid)                 ,       
      .encode_read_data       (types_write_data_8)                            
    );      
    
    
clk_wiz_0 u_clk_wiz_0
   (
    // Clock out ports
    .clk_out1(clk_200mHz),     // output clk_out1
    .clk_out2(types_write_clock),     // output clk_out2
    .clk_out3(types_read_clock),     // output clk_out2
    // Status and control signals
    .resetn(rst_n), // input resetn
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------

endmodule
