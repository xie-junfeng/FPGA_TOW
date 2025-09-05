module ADDA_DATA(
input                sys_clk_100mhz            ,
input                sys_rst                   ,

input    [31:0]      ALT_Value,
//MWD1000L
input                data_AD_A_clk_p           ,
input                data_AD_A_clk_n           ,
input       [11:0]   data_AD_a_in_p            ,
input       [11:0]   data_AD_a_in_n            ,

input                data_AD_B_clk_p           ,
input                data_AD_B_clk_n           ,
input       [11:0]   data_AD_b_in_p            ,
input       [11:0]   data_AD_b_in_n            ,

input                AD_ovr_a                  ,
input                AD_ovr_b                  ,

output               AD_Locked                 ,

output               ADS_RESET_P               ,
output               ADS_RESET_N               ,

output               PLL_Locked                ,


//output               AD_PD,
//output wire         AD_SW_Work,
//output reg          AD_SW_view                     ,        

//DA
input wire          DA_Work_Flag, 

input                data_DA_clk_p                  ,
input                data_DA_clk_n                  ,

output               DAS_DCKIN ,
output               DAS_DCKIP ,


output      [10:0]   data_DA_a_out_p                ,
output      [10:0]   data_DA_a_out_n                ,
output      [10:0]   data_DA_b_out_p                ,
output      [10:0]   data_DA_b_out_n                ,

//(*mark_debug="true"*)input wire [13:0]	    Dpram1_rd_base_addr,
//(*mark_debug="true"*)input wire [13:0]	    Dpram2_rd_base_addr,
//(*mark_debug="true"*)input wire [13:0]	    Dpram3_rd_base_addr,
//(*mark_debug="true"*)input wire [13:0]	    Dpram4_rd_base_addr,

//output     wire [11:0]	FFT_Data1,
//output     wire [11:0]	FFT_Data2,
//output     wire [11:0]	FFT_Data3,
//output     wire [11:0]	FFT_Data4,
//output     wire        Clk_250MHz,

output     wire     	Freq_update, 
output     wire[31:0]  	Freq_out,      

output     wire     	data_AD_B_clk, 
output     wire     	data_DA_clk, 
                        
input wire FFT_En
      
    );
 wire [11:0]	FFT_Data1;
 wire [11:0]	FFT_Data2;  
 wire [11:0]	FFT_Data3;  
 wire [11:0]	FFT_Data4;
       
wire          Clk_250MHz;
wire  [11:0]  data_AD_a_out0 ;
wire  [11:0]  data_AD_a_out1 ;
wire  [11:0]  data_AD_b_out0 ;
wire  [11:0]  data_AD_b_out1 ; 
 
     
reg [21:0]	din_A;
reg [21:0]	din_B;   
 

    
(*mark_debug="true"*)reg [11:0]	rx_data_a_h;
(*mark_debug="true"*)reg [11:0]	rx_data_a_l;
(*mark_debug="true"*)reg [11:0]	rx_data_b_h;
(*mark_debug="true"*)reg [11:0]	rx_data_b_l;
  
//wire data_AD_B_clk;    

//wire data_DA_clk;
wire data_DA_clk_90;
wire DA_Locked;

wire  sys_clk; 
//wire  data_AD_clk; 

reg [1:0]	Dpram_rd_order_sel;


reg [14:0]	Wraddr;
reg [14:0]	Rdaddr1;
reg [14:0]	Rdaddr2;
reg [14:0]	Rdaddr3;
reg [14:0]	Rdaddr4;


reg			ADS_Change1;
reg			ADS_Change2;
reg			ADS_Change3;
reg			ADS_Change4;
reg			DAC_Change1;
reg			DAC_Change2;



(*mark_debug="true"*)reg [14:0]	Dpram1_rd_base_addr;
(*mark_debug="true"*)reg [14:0]	Dpram2_rd_base_addr;
(*mark_debug="true"*)reg [14:0]	Dpram3_rd_base_addr;
(*mark_debug="true"*)reg [14:0]	Dpram4_rd_base_addr;

(*mark_debug="true"*)wire[11:0]	Dpram1_data_out;
(*mark_debug="true"*)wire[11:0]	Dpram2_data_out;
(*mark_debug="true"*)wire[11:0]	Dpram3_data_out;
(*mark_debug="true"*)wire[11:0]	Dpram4_data_out;

//reg [13:0]	tx_data_1;
//reg [13:0]	tx_data_2;
//reg [13:0]	tx_data_3;
//reg [13:0]	tx_data_4;

localparam	DPRAM_WR_BASE_ADDR = 15'h7FFF;
//assign AD_PD = 1'b0;


reg [31:0]	ALT_Value_tmp;
reg [31:0]	ALT_Value_tmp1;
reg          ALT_Value_Change;
reg			ALT_Value_Change_tmp;
///////////////////////////////////////////////
always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		ALT_Value_tmp <= 32'd0;
	else if(ALT_Value < 32'd4)
		ALT_Value_tmp <= 32'd4;
	else if(ALT_Value > 32'd131068)
		ALT_Value_tmp <= 32'd131068;
	else
		ALT_Value_tmp <= ALT_Value;
end

 always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		begin
			ALT_Value_tmp1 <= 32'd0;
			ALT_Value_Change<= 1'b0;
		end
	else
		begin
			ALT_Value_tmp1 <= ALT_Value_tmp;
			ALT_Value_Change <= ALT_Value_Change_tmp;
		end
end   

always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		ALT_Value_Change_tmp <= 1'd0;
	else if(ALT_Value_tmp == ALT_Value_tmp1)
		ALT_Value_Change_tmp <= 1'b0;
//	else if(ALT_Value_tmp[31:1] != ALT_Value_tmp1[31:1])
//		ALT_Value_Change_tmp <= 1'b1;
	else
		ALT_Value_Change_tmp <= 1'd1;
end    


always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		begin
			Dpram1_rd_base_addr <= 15'd0;
			Dpram2_rd_base_addr <= 15'd0;
			Dpram3_rd_base_addr <= 15'd0;
			Dpram4_rd_base_addr <= 15'd0;
		end
	else
		case(ALT_Value_tmp[1:0])
			2'd0: begin
					Dpram1_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
				end
			2'd1: begin
					Dpram1_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			2'd2: begin
					Dpram1_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram4_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			2'd3: begin
					Dpram1_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram3_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram4_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			default: begin
					Dpram1_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
				end
		endcase
end







     OBUFDS
   #(.IOSTANDARD ("LVDS_25"))
  obufds_inst10
    (.O          (DAS_DCKIN ),
     .OB         (DAS_DCKIP ),
     .I          (data_DA_clk_90));


reg FFT_En_reg0;
reg FFT_En_reg1;
  always@( posedge data_AD_B_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			FFT_En_reg0      <= 1'd0;
			FFT_En_reg1     <= 1'd0;	
		end
	else
		begin
			FFT_En_reg0     <= FFT_En;			
			FFT_En_reg1     <= FFT_En_reg0;
			
		end
end 




////////////////////////////////////////////////////////
ADS5400_Sync  ADS5400_Sync_Init
(
	.Clk		    ( data_AD_B_clk ),
	.Resetn			( PLL_Locked ),
	.ADS5400_ovr	( AD_ovr_b ),
	
	.ADS_RESET_N	( ADS_RESET_N )	,
	.ADS_RESET_P	( ADS_RESET_P )
);




//IDDR_TOP IDDR_A(
//  .data_clk          (data_AD_B_clk),  
//  .data_rx_out0       (data_AD_a_out0),   
//  .data_rx_out1       (data_AD_a_out1), 
//  .data_in_p          (data_AD_a_in_p)  ,
//  .data_in_n          (data_AD_a_in_n)        
  
// );

//IDDR_TOP IDDR_B(
//  .data_clk          (data_AD_B_clk),  
//  .data_rx_out0      (data_AD_b_out0), 
//  .data_rx_out1      (data_AD_b_out1), 
//  .data_in_p          (data_AD_b_in_p)  ,
//  .data_in_n          (data_AD_b_in_n)  
      
// );
 
 wire clk_200m;
wire [4:0] adc_idelay;
wire adc_idelay_load;

VIO_AD_DELY VIO_AD_DELY (
  .clk(data_AD_B_clk),                // input wire clk
  .probe_out0(adc_idelay_load),  // output wire [0 : 0] probe_out0
  .probe_out1(adc_idelay)  // output wire [4 : 0] probe_out1
);


ms12dl3200_intf_v1p0 U0_AdInterface(   
    .clk1_io                                   (  data_AD_B_clk                      ), // Input from LVDS clock receiver pin
    .tap_clk                                   (  clk_200m                          ),
    .tap_rst                                   (  ~AD_Locked                      ),
    .serdes_rst                                (  1'd0                   ),
    .adc_idelay_load                           (  adc_idelay_load                   ), // active high,from VIO; 
   
    .adc_idelay_a_tap                          (  adc_idelay                  ), // from VIO; 
    .adc_idelay_b_tap                          (  adc_idelay                  ), // from VIO; 

   
    .datain1_p                                 (  data_AD_a_in_p                            ), // A channel
    .datain1_n                                 (  data_AD_a_in_n                            ), 
    .datain2_p                                 (  data_AD_b_in_p                            ), // B channel
    .datain2_n                                 (  data_AD_b_in_n                            ), 

    .oAData0                                   (       data_AD_a_out0                ), // A channel
    .oAData1                                   (       data_AD_a_out1                ),
   
    .oBData0                                   (       data_AD_b_out0                ), // B channel
    .oBData1                                   (       data_AD_b_out1                 )
);



///////////////////////////////////////////////
 
 
 
 
 assign PLL_Locked = AD_Locked & DA_Locked;

  clk_wiz_0 clk_DA
   (
    // Clock out ports
    .clk_out1(data_DA_clk),     // output clk_out1
    .clk_out2(data_DA_clk_90),     // output clk_out2
    // Status and control signals
    .resetn(sys_rst), // input reset
    .locked(DA_Locked),       // output locked
   // Clock in ports
    .clk_in1_p(data_DA_clk_p),    // input clk_in1_p
    .clk_in1_n(data_DA_clk_n));    // input clk_in1_n

  clk_wiz_AD clk_AD_A
   (
    // Clock out ports
    .clk_out1(),     // output clk_out1
        .clk_out2(),     // output clk_out1
    // Status and control signals
    .resetn(sys_rst), // input reset
    .locked(),       // output locked
   // Clock in ports
    .clk_in1_p(data_AD_A_clk_p),  // input clk_in1_p
    .clk_in1_n(data_AD_A_clk_n));    // input clk_in1_n
   
   clk_wiz_AD clk_AD_b
   (
    // Clock out ports
    .clk_out1(data_AD_B_clk),     // output clk_out1
            .clk_out2(clk_200m),     // output clk_out1
    // Status and control signals
    .resetn(sys_rst), // input reset
    .locked(AD_Locked),       // output locked
   // Clock in ports
    .clk_in1_p(data_AD_B_clk_p),    // input clk_in1_p
    .clk_in1_n(data_AD_B_clk_n)
    );    // input clk_in1_n
   

    IDELAYCTRL IDELAYCTRL_inst (
      .RDY( ),       // 1-bit output: Ready output
      .REFCLK(clk_200m), // 1-bit input: Reference clock input
      .RST(~AD_Locked)        // 1-bit input: Active high reset input
   );
 
 
 always@( posedge data_AD_B_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			rx_data_a_h <= 12'd0;
			rx_data_a_l <= 12'd0;
			rx_data_b_h <= 12'd0;
			rx_data_b_l <= 12'd0;
		end
	else		 
		begin
			rx_data_a_h <= data_AD_a_out1;
			rx_data_a_l <= data_AD_a_out0;
			rx_data_b_h <= data_AD_b_out1;
			rx_data_b_l <= data_AD_b_out0;
		end
end






blk_mem_gen_0 RAM0 (
  .clka(data_AD_B_clk),    // input wire clka
  .wea(1'D1),      // input wire [0 : 0] wea
  .addra(Wraddr),  // input wire [13 : 0] addra
  .dina(rx_data_b_l),    // input wire [11 : 0] dina
  .clkb(data_DA_clk),    // input wire clkb
  .addrb(Rdaddr1),  // input wire [13 : 0] addrb
  .doutb(Dpram1_data_out)  // output wire [11 : 0] doutb
);


blk_mem_gen_0 RAM1 (
  .clka(data_AD_B_clk),    // input wire clka
  .wea(1'D1),      // input wire [0 : 0] wea
  .addra(Wraddr),  // input wire [13 : 0] addra
  .dina(rx_data_a_l),    // input wire [11 : 0] dina
  .clkb(data_DA_clk),    // input wire clkb
  .addrb(Rdaddr2),  // input wire [13 : 0] addrb
  .doutb(Dpram2_data_out)  // output wire [11 : 0] doutb
);


blk_mem_gen_0 RAM2 (
  .clka(data_AD_B_clk),    // input wire clka
  .wea(1'D1),      // input wire [0 : 0] wea
  .addra(Wraddr),  // input wire [13 : 0] addra
  .dina(rx_data_b_h),    // input wire [11 : 0] dina
  .clkb(data_DA_clk),    // input wire clkb
  .addrb(Rdaddr3),  // input wire [13 : 0] addrb
  .doutb(Dpram3_data_out)  // output wire [11 : 0] doutb
);

blk_mem_gen_0 RAM3 (
  .clka(data_AD_B_clk),    // input wire clka
  .wea(1'D1),      // input wire [0 : 0] wea
  .addra(Wraddr),  // input wire [13 : 0] addra
  .dina(rx_data_a_h),    // input wire [11 : 0] dina
  .clkb(data_DA_clk),    // input wire clkb
  .addrb(Rdaddr4),  // input wire [13 : 0] addrb
  .doutb(Dpram4_data_out)  // output wire [11 : 0] doutb
);

always@( posedge data_AD_B_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			ADS_Change1 <= 1'b0;
			ADS_Change2 <= 1'b0;
			ADS_Change3 <= 1'b0;
			ADS_Change4 <= 1'b0;
		end
	else
		begin
			ADS_Change1 <= ALT_Value_Change;
			ADS_Change2 <= ADS_Change1;
			ADS_Change3 <= ADS_Change2;
			ADS_Change4 <= ADS_Change3;
		end
end

always@( posedge data_AD_B_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Wraddr <= 'd50;
	else if(ADS_Change4 == 1'b1)
		Wraddr <= DPRAM_WR_BASE_ADDR;
	else if(Wraddr < DPRAM_WR_BASE_ADDR)
		Wraddr <= Wraddr + 'd1;
	else
		Wraddr <= 'd0;
end


always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			DAC_Change1 <= 1'b0;
			DAC_Change2 <= 1'b0;
		end
	else
		begin
			DAC_Change1 <= ADS_Change2;
			DAC_Change2 <= DAC_Change1;
		end
end

always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Rdaddr1 <= 15'd0;
	else if(DAC_Change2 == 1'b1)
		Rdaddr1 <= Dpram1_rd_base_addr;
	else if(Rdaddr1 < DPRAM_WR_BASE_ADDR)
		Rdaddr1 <= Rdaddr1 + 15'd1;
	else
		Rdaddr1 <= 15'd0;
end

always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Rdaddr2 <= 15'd0;
	else if(DAC_Change2 == 1'b1)
		Rdaddr2 <= Dpram2_rd_base_addr;
	else if(Rdaddr2 < DPRAM_WR_BASE_ADDR)
		Rdaddr2 <= Rdaddr2 + 15'd1;
	else
		Rdaddr2 <= 15'd0;
end

always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Rdaddr3 <= 15'd0;
	else if(DAC_Change2 == 1'b1)
		Rdaddr3 <= Dpram3_rd_base_addr;
	else if(Rdaddr3 < DPRAM_WR_BASE_ADDR)
		Rdaddr3 <= Rdaddr3 + 15'd1;
	else
		Rdaddr3 <= 15'd0;
end

always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Rdaddr4 <= 15'd0;
	else if(DAC_Change2 == 1'b1)
		Rdaddr4 <= Dpram4_rd_base_addr;
	else if(Rdaddr4 < DPRAM_WR_BASE_ADDR)
		Rdaddr4 <= Rdaddr4 + 15'd1;
	else
		Rdaddr4 <= 15'd0;
end

always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		Dpram_rd_order_sel <= 2'd0;
	else if(DAC_Change2 == 1'b1)
		Dpram_rd_order_sel <= ALT_Value_tmp[1:0];
	else
		Dpram_rd_order_sel <= Dpram_rd_order_sel;
end


wire AD_SW_Work;

wire [10:0] DATA1;
wire [10:0] DATA2;
wire [10:0] DATA3;
wire [10:0] DATA4;

wire [15:0] delta_phase_vio;

vio_ADDA your_instance_name (
  .clk(data_DA_clk),                // input wire clk
  .probe_out0(AD_SW_Work) , // output wire [0 : 0] probe_out4
  .probe_out1(delta_phase_vio)  // output wire [0 : 0] probe_out4
);

wire [43:0] dout;

DDS U_DDS (
  .clk(data_DA_clk),                // input wire clk
  .rstn(PLL_Locked),                // input wire clk  
  .delta_phase(delta_phase_vio),                // input wire clk
  .dout(dout)               // input wire clk
);

(*mark_debug="true"*)reg  [10:0]   data4;
(*mark_debug="true"*)reg  [10:0]   data3;
(*mark_debug="true"*)reg  [10:0]   data2;
(*mark_debug="true"*)reg  [10:0]   data1;

 always @(posedge data_DA_clk)
begin

data4<= dout[43:33];
data3<= dout[32:22];
data2<= dout[21:11];
data1<= dout[10:0];
 end
 
 always @(posedge data_DA_clk or negedge PLL_Locked)
begin
	if(!PLL_Locked)
	    begin
          din_A <= 22'd0;
		  din_B <= 22'd0;
	    end
    else if ( DA_Work_Flag && ~AD_SW_Work )
		 begin
		 		case(Dpram_rd_order_sel)
			2'd0: begin
					din_A <= {Dpram3_data_out[11:1],Dpram1_data_out[11:1]};
			        din_B <= {Dpram4_data_out[11:1],Dpram2_data_out[11:1]};
			     end
			2'd1: begin
					din_A <= {Dpram2_data_out[11:1],Dpram4_data_out[11:1]};
			        din_B <= {Dpram3_data_out[11:1],Dpram1_data_out[11:1]};
			     end
			2'd2: begin
					din_A <= {Dpram1_data_out[11:1],Dpram3_data_out[11:1]};
			        din_B <= {Dpram2_data_out[11:1],Dpram4_data_out[11:1]};
			     end
			2'd3: begin
				    din_A <= {Dpram4_data_out[11:1],Dpram2_data_out[11:1]};
			        din_B <= {Dpram1_data_out[11:1],Dpram3_data_out[11:1]};
			    end
			default: begin
					din_A <= {Dpram3_data_out[11:1],Dpram1_data_out[11:1]};
			        din_B <= {Dpram4_data_out[11:1],Dpram2_data_out[11:1]};
				end
		 endcase
		 end
	 else if ( DA_Work_Flag && AD_SW_Work  )//&& AD_SW_view
		 begin
   		    din_A <= {data2,data4};
            din_B <= {data1,data3};
		 end
	 else  //&& AD_SW_view
		 begin
          din_A <= 22'd0;
		  din_B <= 22'd0;
		 end
end

//reg [21:0] din_A_reg0;
//reg [21:0] din_B_reg0;
//reg [21:0] din_A_reg1;
//reg [21:0] din_B_reg1;

// always @(posedge data_DA_clk)
//begin
//          din_A_reg0 <= din_A;
//		  din_A_reg1 <= din_A_reg0;
//end


// always @(posedge data_DA_clk)
//begin
//          din_B_reg0 <= din_B;
//		  din_B_reg1 <= din_B_reg0;
//end

ODDR_TOP ODDR_A(
  .data_clk              (data_DA_clk),   
  .data_tx_in            (din_A ),  
  .data_tx_out_p         (data_DA_a_out_p),
  .data_tx_out_n         (data_DA_a_out_n)
);

ODDR_TOP ODDR_B(
   .data_clk           (data_DA_clk),   
  
  .data_tx_in          (din_B),  
  .data_tx_out_p       (data_DA_b_out_p),
  .data_tx_out_n       (data_DA_b_out_n)
);

ALT_FFT_Cache  ALT_FFT_Cache_Init
(
	.ADS_Clkin		( data_AD_B_clk ),
	.Resetn			( PLL_Locked ),
	.AD_data1		( rx_data_b_l ),
	.AD_data2		( rx_data_a_l ),
	.AD_data3		( rx_data_b_h ),
	.AD_data4		( rx_data_a_h ),

	.FFT_Data1		( FFT_Data1 ),
	.FFT_Data2		( FFT_Data2 ),
	.FFT_Data3		( FFT_Data3 ),
	.FFT_Data4		( FFT_Data4 ),
	.Clk_250MHz		( Clk_250MHz )
);


FFT_TOP 
#(
	.FFT_DATA_WITDH         ( 32'd24 ),
	.LOG2_FFT_LEN	        ( 32'd12 ),
	.AD_WIDTH		        ( 32'd12 ),
	.PEAK_NUM		        ( 32'd3 ),
	.SAMPLE_FREQ	        ( 32'd1_000_000_000 )
)
U_FFT_TOP(
	.Clk				     (Clk_250MHz ),
	.Clk_100M			     ( sys_clk_100mhz ),
	.Reset				     ( PLL_Locked ),
	.FFT_valid			     ( 1'd1 ),
	.measure_RX_En           ( FFT_En_reg1 ),
	.Trigger_flag		     ( 1'd1 ),
//	.Trigger_flag		     ( Probe_o[31] == 1 ? FFT_trigger : Trigger_upload ),
	.Work_mode			     ( 1'd1 ),
	.sink_rel			     ( 24'd0 ),
	.sink_img			     ( 24'd0 ),
	.FFT_Data1			     ( FFT_Data1  ),
	.FFT_Data2			     ( FFT_Data2  ),
	.FFT_Data3			     ( FFT_Data3  ),
	.FFT_Data4			     ( FFT_Data4  ),
	.MAX_Square_data	     ( 'd0   ),
	.Probe_o			     ( 30'd0 ),
	
	.Freq_update		     ( Freq_update ),
	.Freq_out			     (Freq_out)
 ); 

endmodule