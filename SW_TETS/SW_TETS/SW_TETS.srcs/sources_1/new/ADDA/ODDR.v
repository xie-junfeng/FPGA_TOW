`timescale 1ns / 1ps


module ODDR_TOP(

    input              data_clk , //GMII发送时钟    
    input       [21:0]  data_tx_in   , //GMII输出数据        
    output signed     [10:0]  data_tx_out_p ,    //RGMII输出数据
    output signed     [10:0]  data_tx_out_n     //RGMII输出数据      
    );

//*****************************************************
//**                    main code
//*****************************************************
wire [10:0]data_tx_out;
        OBUFDS
      #(.IOSTANDARD ("LVDS_25"))
     obufds_inst[10:0]
       (.O          (data_tx_out_p  ),
        .OB         (data_tx_out_n  ),
        .I          (data_tx_out ));




genvar i;
generate for (i=0; i<11; i=i+1)
    begin : txdata_bus
        //输出双沿采样寄存器 (rgmii_txd)
        ODDR #(
            .DDR_CLK_EDGE  ("SAME_EDGE"),  // "OPPOSITE_EDGE" or "SAME_EDGE" 
            .INIT          (1'b0),         // Initial value of Q: 1'b0 or 1'b1
            .SRTYPE        ("SYNC")        // Set/Reset type: "SYNC" or "ASYNC" 
        ) ODDR_inst (
            .Q             (data_tx_out[i]), // 1-bit DDR output
            .C             (data_clk),  // 1-bit clock input
            .CE            (1'b1),         // 1-bit clock enable input
            .D1            (data_tx_in[i]),  // 1-bit data input (positive edge)
            .D2            (data_tx_in[11+i]),// 1-bit data input (negative edge)
            .R             (1'b0),         // 1-bit reset
            .S             (1'b0)          // 1-bit set
        );        
    end
    

    
endgenerate
endmodule
