`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/21 14:34:07
// Design Name: 
// Module Name: XND4351_SPI_MASTER_LOOP
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


module XND4351_SPI_MASTER_LOOP#(
    parameter                       SPI_SEND_NUM    = 32    , //SPI total bit length 
    parameter                       SPI_RECE_NUM    = 32    , //SPI data length
    parameter                       CS_BEFOR_DELY   = 128   , // CS_BEFOR_DELY
    parameter                       CS_END_DELY     = 64    , //CS_END_DELY 
    parameter                       CPOL            = 0     , //CPOL=0:serial clock low when idle; CPOL=1:serial clock high when idle
    parameter                       CPHA            = 0     , //CPHA=0 capture serial data at 1st edge; CPHA=1: capture serial data at 2nd edge
    parameter                       MOSI_IDLE       = 0       //idle state of spi mosi
    )(
    input                           clk                     , // module clock
    input                           reset                   , // active high module reset
    input       [7:0]               spi_baud                , // spi baud rate control(spi rate = clk rate/2*())
    input                           spi_start               , // spi send pulse
    input       [SPI_SEND_NUM-1:0]  spi_send_data_i         , // spi send data
    output reg                      spi_trans_end_o=1'd0            , // spi transaction end
    output reg  [SPI_RECE_NUM-1:0]  spi_rece_data_o=32'd0           , // spi receive data
    output reg                      spi_busy_o=1'd0                 , // active high spi run busy indication
    output reg                      spi_csn_o =1'd0                 , // device configuration 4-wire spi bus: active low chip selec
    output                          spi_sclk                , // device configuration 4-wire spi bus: serial clock
    output reg                      spi_mosi  =1'd0               , // device configuration 4-wire spi bus: slave serial data in
    input                           spi_miso,
    output reg                      LE  =1'd0 
    );

 ///////////////////////////////LE驱动信号线生成//////////////////////////
wire cs_raise;
wire cs_flow;
 reg cs_reg0=1'd0;
 reg cs_reg1=1'd0;
      always@(posedge clk) begin
        if (reset == 1'b1) begin
            cs_reg0    <=  1'b0    ;
            cs_reg1    <=  1'b0    ;
        end else begin
            cs_reg0    <=  spi_csn_o;
            cs_reg1    <=  cs_reg0    ;
        end
    end  
  
  assign   cs_raise =(~cs_reg1 & cs_reg0 );
  assign   cs_flow  =( cs_reg1 & ~cs_reg0);
 reg [15:0] cnt;
 
       always@(posedge clk) begin
        if (reset == 1'b1) begin
           cnt <= 16'b0    ; 
        end else begin
            if(cnt==spi_baud+1'd1)begin
                cnt <= 16'b0    ;
            end
            else if(LE) begin
                cnt <= cnt+16'd1    ;
            end
        end
    end  
 
       always@(posedge clk) begin
        if (reset == 1'b1) begin
            LE <= 1'b0    ;
        end else begin
            if(cs_raise) begin
                LE <= 1'b1    ;
            end
            if(cnt==spi_baud)begin
                LE <= 1'b0;
            end
        end
    end  
 /////////////////////////////////////////////////////////////////////////////
 

 ///////////////////////////////CS拉低后的信号延时//////////////////////////
    reg [15:0]befor_dely_cnt;
    reg befor_cs_flga;
        always@(posedge clk) begin
        if (reset == 1'b1) begin
            befor_cs_flga    <=  1'b0    ;
        end else if(spi_start) begin
            befor_cs_flga             <=  1'd1; 
        end
            else if(befor_dely_cnt==CS_BEFOR_DELY+1'd1)begin
                  befor_cs_flga         <=  1'd0;  
            end
    end
   
     always@(posedge clk) begin
        if (reset == 1'b1) begin
           befor_dely_cnt <= 16'b0    ; 
        end else begin
            if(befor_dely_cnt==CS_BEFOR_DELY+2'd2)begin
                befor_dely_cnt <= 16'b0    ;
            end
            else if(befor_cs_flga) begin
                befor_dely_cnt <= befor_dely_cnt+16'd1    ;
            end
        end
    end  
reg    befor_cs_flga0;
reg    befor_cs_flga1;
reg   befor_cs_flga_flow=1'd0;    

      always@(posedge clk) begin
        if (reset == 1'b1) begin
            befor_cs_flga0    <=  1'b0    ;
            befor_cs_flga1    <=  1'b0    ;
        end else begin
            befor_cs_flga0    <=  befor_cs_flga ;
            befor_cs_flga1    <=  befor_cs_flga0;
        end
    end  
//assign befor_cs_flga_flow=( befor_cs_flga1 & ~befor_cs_flga0);

      always@(posedge clk) begin
        if (reset == 1'b1) begin
            befor_cs_flga_flow    <=  1'b0    ;
        end else begin
            befor_cs_flga_flow  <=( befor_cs_flga1 & ~befor_cs_flga0);
        end
    end  

//////////////////////////////////////////////////////

    // capture the rising edge
    reg         reg1,reg2       ;
    wire        reg_en          ;
    always@(posedge clk) begin
        if (reset == 1'b1) begin
            reg1    <=  1'b0    ;
            reg2    <=  1'b0    ;
        end else begin
            reg1    <=  spi_start;
            reg2    <=  reg1    ;
        end
    end
    
    assign reg_en = ~befor_cs_flga1 & befor_cs_flga0;
    
    // generate spi busy indicator
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_busy_o    <=  1'b0;
        else if (spi_start)
            spi_busy_o    <=  1'b1;
        else if (spi_trans_end_o)
            spi_busy_o    <=  1'b0;
    end
    
    // generate spi run signal
    reg     spi_run;
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_run     <=  1'b0;
        else if (befor_cs_flga_flow)
            spi_run     <=  1'b1;
        else if (spi_trans_end_o)
            spi_run     <=  1'b0;
    end
    
    // genrate spi clock according the baudrate setting
    reg             spi_bit_clk_en=1'd0   ; // spi bit send enable
    reg             spi_send_clk_en=1'd0  ; // spi bit clock enable
    reg     [7:0]   spi_baud_cnt=8'd0     ; // spi baudrate conter
    always@(posedge clk) begin
        if (reset == 1'b1) begin
            spi_baud_cnt        <=  8'd0            ;
            spi_send_clk_en     <=  1'b0            ;
            spi_bit_clk_en      <=  1'b0            ;
        end else if (spi_run) begin
            if (spi_baud_cnt == (spi_baud - 1'b1)) begin
                spi_baud_cnt    <=  8'd0            ;
                spi_send_clk_en <=  1'b1            ;
            end else if ((spi_baud_cnt == spi_baud[7:1]) && (spi_baud !={spi_baud[7:1],1'b0})) begin
                spi_baud_cnt    <= spi_baud_cnt+1'b1;
                spi_send_clk_en <=  1'b1            ;
                spi_bit_clk_en  <=  1'b1            ;
            end else if ((spi_baud_cnt == (spi_baud[7:1] - 1'b1)) && (spi_baud == {spi_baud[7:1],1'b0})) begin
                spi_baud_cnt    <= spi_baud_cnt+1'b1;
                spi_send_clk_en <=  1'b1            ;
                spi_bit_clk_en  <=  1'b1            ;
            end else begin
                spi_baud_cnt    <= spi_baud_cnt+1'b1;
                spi_send_clk_en <=  1'b0            ;
                spi_bit_clk_en  <=  1'b0            ;
            end
        end else begin
            spi_baud_cnt        <=  8'd0            ;
            spi_bit_clk_en      <=  1'b0            ;
            spi_send_clk_en     <=  1'b0            ;
        end
    end
    
    // spi send bits counter
    reg     [7:0]       count=8'd0       ;
    always@(posedge clk) begin
        if (reset == 1'b1)
            count   <=  8'd0        ;
        else if ((count < SPI_SEND_NUM) && (spi_bit_clk_en == 1))
            count   <=  count + 1'b1;
        else if ((count == SPI_SEND_NUM) && (spi_bit_clk_en == 1))
            count   <=  8'd0        ;
    end
    
    // generate spi bit clock
    reg                 spi_sclk_en=1'd0 ;
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_sclk_en <=  1'b0    ;
        else if (befor_cs_flga_flow)
            spi_sclk_en <=  1'b1    ;
        else if (spi_send_clk_en && (count == SPI_SEND_NUM))
            spi_sclk_en <=  1'b0    ;
    end
    
    reg                 spi_sclk_among1=1'd0         ;
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_sclk_among1 <=  1'b0            ;
        else if (spi_sclk_en & spi_send_clk_en)
            spi_sclk_among1 <=  !spi_sclk_among1;
        else if (spi_sclk_en == 1'b0)
            spi_sclk_among1 <=  1'b0            ;
        else
            spi_sclk_among1 <=  spi_sclk_among1 ;
    end
    
    reg                     spi_sclk_among2=1'd0     ;
    always@(negedge clk) begin
        if (reset == 1'b1)
            spi_sclk_among2 <=  1'b0            ;
        else if ((spi_sclk_en & spi_send_clk_en) && (spi_baud != {spi_baud[7:1], 1'b0}))
            spi_sclk_among2 <=  !spi_sclk_among2;
        else if (spi_sclk_en == 1'b0)
            spi_sclk_among2 <=  1'b0            ;
        else
            spi_sclk_among2 <=  spi_sclk_among2 ;
    end
    
    wire spi_sclk_among = spi_sclk_among1 | spi_sclk_among2;
    
    // spi data send and receive
    ///////////////////////////////CS拉高前的信号延时//////////////////////////
    reg [15:0]dely_cnt;
    reg cs_flga;
        always@(posedge clk) begin
        if (reset == 1'b1) begin
            cs_flga    <=  1'b0    ;
        end else if(spi_trans_end_o) begin
            cs_flga             <=  1'd1; 
        end
            else if(dely_cnt==CS_END_DELY+1'd1)begin
                  cs_flga         <=  1'd0;  
            end
    end
   
     always@(posedge clk) begin
        if (reset == 1'b1) begin
           dely_cnt <= 16'b0    ; 
        end else begin
            if(dely_cnt==CS_END_DELY+2'd2)begin
                dely_cnt <= 16'b0    ;
            end
            else if(cs_flga) begin
                dely_cnt <= dely_cnt+16'd1    ;
            end
        end
    end  
reg    cs_flga0;
reg    cs_flga1;
reg   cs_flga_flow=1'd0;    

      always@(posedge clk) begin
        if (reset == 1'b1) begin
            cs_flga0    <=  1'b0    ;
            cs_flga1    <=  1'b0    ;
        end else begin
            cs_flga0    <=  cs_flga;
            cs_flga1    <=  cs_flga0    ;
        end
    end  
  

      always@(posedge clk) begin
        if (reset == 1'b1) begin
            cs_flga_flow    <=  1'b0    ;
        end else begin
            cs_flga_flow  <=( cs_flga1 & ~cs_flga0);
        end
    end  
///////////////////////////////////////////////////////
    
     
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_csn_o <=  1'b1;
        else if (reg_en)
            spi_csn_o <=  1'b0;
        else if (cs_flga_flow)
            spi_csn_o <=  1'b1;
    end
    
    reg     [SPI_SEND_NUM-1:0]  spi_send_buff=24'd0   ;
    always@(posedge clk) begin
        if (reset == 1'b1) begin
            spi_mosi        <=  MOSI_IDLE       ;
            spi_send_buff   <=  'd0             ;
        end else if (befor_cs_flga_flow)
            spi_send_buff   <= spi_send_data_i    ;
        else if ((count < SPI_SEND_NUM) && (spi_bit_clk_en == 1)) begin
            spi_mosi        <=  spi_send_buff[SPI_SEND_NUM-1];
            spi_send_buff   <=  {
                                    spi_send_buff[SPI_SEND_NUM-2:0], 
                                    spi_send_buff[SPI_SEND_NUM-1]    
                                }               ;
        end else if ((count == SPI_SEND_NUM) && (spi_bit_clk_en == 1)) begin
            spi_mosi        <=  MOSI_IDLE       ;
            spi_send_buff   <=  spi_send_buff             ;
            
 //           spi_send_buff   <=  'd0             ;
        end
    end
    
    reg     [SPI_RECE_NUM-1:0]  spi_rec_buff=32'd0    ;
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_rec_buff    <=  'd0             ;
        else if ((spi_bit_clk_en == 0) && (spi_send_clk_en == 1)) begin
            spi_rec_buff[0] <=  spi_miso        ;
            spi_rec_buff[SPI_RECE_NUM-1:1]  <= spi_rec_buff[SPI_RECE_NUM-2:0];
        end
    end
    
    always@(posedge clk) begin
        if (reset == 1'b1) begin
            spi_trans_end_o   <=  1'b0            ;
            spi_rece_data_o   <=  'd0             ;
        end else if ((count == SPI_SEND_NUM) && (spi_bit_clk_en == 1)) begin
            spi_trans_end_o   <=  1'b1            ;
            spi_rece_data_o   <=  spi_rec_buff    ;
        end else        
            spi_trans_end_o   <=  1'b0            ;
    end
    
    // CPHA/CPOL conttrol
    (* keep="true" *)   reg     spi_sclk_reg1=1'd0   ;
    (* keep="true" *)   reg     spi_sclk_reg2=1'd0   ;
    always@(posedge clk) begin
        if (reset == 1'b1)
            spi_sclk_reg1            <= 0                ;
        else if (spi_send_clk_en==1) 
            spi_sclk_reg1            <= spi_sclk_among1  ;
    end
    
    always@(negedge clk ) begin
        if (reset == 1'b1)
            spi_sclk_reg2            <= 0                ;
        else if (spi_send_clk_en==1) 
            spi_sclk_reg2            <= spi_sclk_among2  ;
    end
    
    wire spi_sclk_reg_buf = (spi_baud[0]) ? (spi_sclk_reg1 & spi_sclk_reg2) : spi_sclk_reg1;
    
    wire                spi_sclk_reg    ;
    generate
        if (CPHA == 1)
            assign spi_sclk_reg = spi_sclk_among	;
        else
            assign spi_sclk_reg = spi_sclk_reg_buf  ;
    endgenerate
   
    generate
        if (CPOL == 1)
            assign spi_sclk = !spi_sclk_reg         ;
        else
            assign spi_sclk = spi_sclk_reg          ;
        endgenerate
    
endmodule
