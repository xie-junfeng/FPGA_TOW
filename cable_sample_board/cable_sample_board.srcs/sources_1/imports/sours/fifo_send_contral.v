//非连续发送读取
//////////////////////////////////////////////////////////////////////////////////
// Company: SAU
// Engineer: XIE JUNBO
// 
// Create Date: 2023/05/07 10:11:18
// Design Name: 
// Module Name: FSC
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

module FSC(
    input                 rst_n               ,   
    //图像相关信号
    input                 fifo_write_clk      ,   
    output                fifo_write_ready    ,   
    input                 fifo_write_valid    ,   
    input        [7:0]   fifo_write_data     ,   

    input                 fifo_read_clk       ,   
    input                 fifo_read_ready     ,   
    output                fifo_read_valid     ,    
    output       [31:0]   fifo_read_data      ,    
    output                start  
    );    
    
wire                 rd_rst_busy;
wire                 wr_rst_busy;
wire      [7:0]      rd_data_count;
wire      [9:0]      wr_data_count;

wire                 fifo_rst_n;

wire                      fifo_write_valid_r;
wire      [7:0]          fifo_write_data_r;

parameter   DATA_SEND_NUMBER_8    = 15'd976; 

F_S_W#(          
    .DATA_SEND_NUMBER_8        (DATA_SEND_NUMBER_8)          
    )   
 U_F_S_W (
  .rst_n(rst_n||fifo_rst_n), 
  .rd_data_count   (rd_data_count),  
  .wr_data_count   (wr_data_count), 
  .rd_rst_busy    (rd_rst_busy),  
  .wr_rst_busy    (wr_rst_busy  ), 
  
  .fifo_write_clk  (fifo_write_clk)  ,  
  .fifo_write_ready(fifo_write_ready),  
  .fifo_write_valid(fifo_write_valid),  
  .fifo_write_data(fifo_write_data  ),  
  
  .fifo_write_valid_r(fifo_write_valid_r  ), 
  .fifo_write_data_r (fifo_write_data_r  ) 
);

F_S_R#(          
    .DATA_SEND_NUMBER_8         (DATA_SEND_NUMBER_8)          
    )  
 U_F_S_R (
  .rst_n(rst_n||fifo_rst_n), 
  .wr_data_count                 (wr_data_count),  
  .rd_data_count                 (rd_data_count), 
  
  .start(start), 
  .fifo_read_clk(fifo_read_clk), 
  .fifo_read_ready    (fifo_read_ready) ,
  .fifo_read_valid    (fifo_read_valid)
);
fifo_generator_0 fifo_send_ (
  .rst                (~rst_n||fifo_rst_n),  
  .wr_clk             (fifo_write_clk),      
  .rd_clk             (fifo_read_clk),       
  .din                (fifo_write_data),     
  .wr_en              (fifo_write_valid),    
  .rd_en              (fifo_read_ready),     
  .dout               (fifo_read_data),      
  .full               (),                    
  .almost_full        (),                    
  .empty              (),                    
  .almost_empty       (),                    
  .rd_data_count      (rd_data_count),       
  .wr_data_count      (wr_data_count),  
  .wr_rst_busy        (wr_rst_busy),     
  .rd_rst_busy        (rd_rst_busy)      
);


F_C U_F_C  (
  .clk                (fifo_write_clk),
  .rst_n              (rst_n),                       
  .fifo_rst_n         (fifo_rst_n)
);

endmodule