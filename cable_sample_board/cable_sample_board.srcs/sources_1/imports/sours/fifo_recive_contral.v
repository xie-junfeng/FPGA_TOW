//连续发送读取
module FRC
    (
    input                 rst_n                   ,   
   //
    input                 fifo_read_clk            , 
    input                 fifo_read_ready        , 
    output                fifo_read_valid        ,
    output    [31:0]      fifo_read_data         ,  
    //
    input                 fifo_write_clk           ,       
    output                fifo_write_ready         , 
    input                 fifo_write_valid         ,   
    input        [31:0]   fifo_write_data                                                           
    );    
    
parameter   DATA_NUMBER_32    = 8'd18;    

wire                      rd_rst_busy;
wire                      wr_rst_busy;
wire      [4:0]           rd_data_count;
wire      [4:0]           wr_data_count;
wire                      fifo_read_valid_r;
wire      [31:0]          fifo_read_data_r;

wire                      fifo_write_valid_r;
wire      [31:0]          fifo_write_data_r;
wire                      fifo_rst_n;

F_W#(          
    .DATA_NUMBER_32              (DATA_NUMBER_32)          
    )   
 U_F_W (
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
F_R#(          
    .DATA_NUMBER_32              (DATA_NUMBER_32)          
    )  
 U_F_R (
  .rst_n(rst_n||fifo_rst_n), 
  .wr_data_count                 (wr_data_count),  
  .rd_data_count                 (rd_data_count),  
  
  .fifo_read_clk(fifo_read_clk),  
  .fifo_read_valid(fifo_read_valid_r),
  .fifo_read_ready(fifo_read_ready),  
  .fifo_read_data(fifo_read_data_r),
  
  
   .fifo_read_valid_r(fifo_read_valid),
   .fifo_read_data_r(fifo_read_data) 
);

fifo_generator_1 fifo_recive  (
  .rst                           (~rst_n||fifo_rst_n),
  .wr_clk                        (fifo_write_clk),
  .rd_clk                        (fifo_read_clk),      
  .din                           (fifo_write_data ),
  .wr_en                         (fifo_write_valid), 
  .rd_en                         (fifo_read_valid_r  ),
  .dout                          (fifo_read_data_r),                 
  .full                          (),
  .almost_full                   (),
  .empty                         (),
  .almost_empty                  (),
  .rd_data_count                 (rd_data_count),
  .wr_data_count                 (wr_data_count),
  .wr_rst_busy                   (wr_rst_busy),
  .rd_rst_busy                   (rd_rst_busy)
); 

F_C U_F_C  (
  .clk                           (fifo_read_clk),
  .rst_n                         (rst_n),                       
  .fifo_rst_n                    (fifo_rst_n)
); 

//  ila_0 youe0 (
//	.clk(fifo_write_clk), // input wire clk
//	.probe0(fifo_write_valid), // input wire [0:0]  probe0  
//	.probe1(0), // input wire [0:0]  probe1 
//	.probe2(rd_data_count), // input wire [7:0]  probe3 
//	.probe3(wr_data_count), // input wire [10:0]  probe4 
//	.probe4(fifo_write_data), // input wire [10:0]  probe5
//    .probe5(0)  // input wire [15:0]  probe4 

//);
//  ila_0 youe1 (
//	.clk(fifo_read_clk), // input wire clk
//	.probe0(0), // input wire [0:0]  probe0  
//	.probe1(fifo_read_valid), // input wire [0:0]  probe1 
//	.probe2(rd_data_count), // input wire [7:0]  probe3 
//	.probe3(wr_data_count), // input wire [10:0]  probe4 
//	.probe4(0), // input wire [10:0]  probe5
//    .probe5(fifo_read_data)  // input wire [15:0]  probe4 

//);

endmodule