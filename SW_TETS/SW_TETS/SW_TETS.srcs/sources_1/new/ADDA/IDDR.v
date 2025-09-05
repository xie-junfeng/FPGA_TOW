module IDDR_TOP
(

    input               data_clk       , //随路时钟
    
    input  signed     [11:0]   data_in_p        , //接收数据    
    input  signed     [11:0]   data_in_n        , //接收数据  
    
    output  signed    [11:0]  data_rx_out0  ,     //输出数据   
    output  signed    [11:0]  data_rx_out1       //输出数据  
    );
    
parameter   IDELAY_VALUE = 0;

wire         data_clk_bufio;    
//wire  [11:0]  data_in_delay;    
wire  [11:0]  data_in;
//1. Data Input LVDS Buffer
    IBUFDS #(
      .DIFF_TERM("TRUE"),    // Differential Termination
//      .IBUF_LOW_PWR("FALSE"),  // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("LVDS")  // Specify the input I/O standard
   )  Uibufds[11:0] (
        .I    (data_in_p  ),
        .IB   (data_in_n  ),
        .O    (data_in  )
    );


//全局时钟IO缓存
//BUFIO BUFIO_inst (
//  .I            (data_clk),       
//  .O            (data_clk_bufio)  
//);

genvar i;
generate for (i=0; i<12; i=i+1)
    (* IODELAY_GROUP = "rgmii_rx_delay" *) 
    begin : rxdata_bus
//        //输入延时           
//        (* IODELAY_GROUP = "rgmii_rx_delay" *) 
//        IDELAYE2 #(
//          .IDELAY_TYPE     ("FIXED"),          
//          .IDELAY_VALUE    (IDELAY_VALUE),     
//          .REFCLK_FREQUENCY(200.0)             
//        )
//        u_delay_rxd (
//          .CNTVALUEOUT     (),                
//          .DATAOUT         (data_in_delay[i]),
//          .C               (1'b0),            
//          .CE              (1'b0),            
//          .CINVCTRL        (1'b0),            
//          .CNTVALUEIN      (5'b0),            
//          .DATAIN          (1'b0),            
//          .IDATAIN         (data_in[i]),      
//          .INC             (1'b0),            
//          .LD              (1'b0),            
//          .LDPIPEEN        (1'b0),            
//          .REGRST          (1'b0)             
//        );
       
        IDDR #(
            .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),// "OPPOSITE_EDGE", "SAME_EDGE" 
            .INIT_Q1  (1'b0),                   // Initial value of Q1: 1'b0 or 1'b1
            .INIT_Q2  (1'b0),                   // Initial value of Q2: 1'b0 or 1'b1
            .SRTYPE   ("SYNC")                  // Set/Reset type: "SYNC" or "ASYNC" 
        )
        u_iddr_rxd (
            .Q1       (data_rx_out0[i])  ,       
            .Q2       (data_rx_out1[i]),     
            .C        (data_clk)  ,       
            .CE       (1'd1),                 
            .D        (data_in[i]),     
            .R        (1'b0),                 
            .S        (1'b0)                  
        );
    end
endgenerate

endmodule

