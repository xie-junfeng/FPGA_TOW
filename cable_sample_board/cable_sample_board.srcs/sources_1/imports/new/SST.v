`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 17:11:56
// Design Name: 
// Module Name: SST
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


module SST(
     input                 rst_n  ,      
     // count signal
     output                source_write_ready,    
     input                 source_write_valid,   
     input      [7:0]      source_write_data,    
    // signal for rom
     input                 source_read_clk  , 
     input                 source_read_ready, 
     output                source_read_valid,      //¸øÐ´ÓÐÐ§
     output       [7:0]    source_read_data_8        
     
     
    );
    
 parameter  SOURCE_FREQUENCY0 = 8'd0;    
 parameter  SOURCE_FREQUENCY1 = 8'd1;    
 parameter  SOURCE_FREQUENCY2 = 8'd3;    
 parameter  SOURCE_FREQUENCY3 = 8'd7;    
 parameter  MOVE              = 9'd10;   
  wire      source_read_adress_valid;  
 wire [13:0]  source_read_adress;   
blk_mem_gen_0 your_instance_name (
     .clka           (source_read_clk),    // input wire clka
     .ena            (1'b1),      // input wire ena
     .addra          (source_read_adress),  // input wire [8 : 0] addra
     .douta          (source_read_data_8)  // output wire [7 : 0] douta
);  

//  ila_0 youe100 (
//	.clk(source_read_clk), // input wire clk
//	.probe0(0), // input wire [0:0]  probe0  
//	.probe1(0), // input wire [0:0]  probe1 
//	.probe2(0), // input wire [7:0]  probe3 
//	.probe3(0), // input wire [10:0]  probe4 
//	.probe4(source_read_data_8), // input wire [10:0]  probe5
//    .probe5(source_read_adress)  // input wire [15:0]  probe4 
//);  

//adjuest time for keep synchronized
TLD_TWO U_TLD_TWO  (
     .clk                       (source_read_clk)    ,
     .rst_n                     (rst_n)              ,
     
     .a                        (source_read_adress_valid)  ,
     .b                         (source_read_valid)           
);  



//rom address contral
RAC#( 
    .SOURCE_FREQUENCY0             (SOURCE_FREQUENCY0   ), 
    .SOURCE_FREQUENCY1             (SOURCE_FREQUENCY1   ),
    .SOURCE_FREQUENCY2             (SOURCE_FREQUENCY2   ),
    .SOURCE_FREQUENCY3             (SOURCE_FREQUENCY3   ),           
    .MOVE                          (MOVE   )  
    )
U_RAC (

     .clk                       (source_read_clk),
     .rst_n                     (rst_n),


     .count_write_ready         (source_write_ready),
     .wave_count_write_data     (source_write_data),     
         
     .rom_read_adress_ready     (source_read_ready),  //start  
     .rom_read_adress_valid     (source_read_adress_valid),     
     .rom_read_adress           (source_read_adress)
    
    
);  


    
    
endmodule
