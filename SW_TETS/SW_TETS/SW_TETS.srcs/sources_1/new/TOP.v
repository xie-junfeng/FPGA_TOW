`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/18 13:42:36
// Design Name: 
// Module Name: TOP
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


module TOP(
//时钟
input                   FPGA_clk_25mhz,             
//UART 
output					HGX3232EIMT_UART0_TXD_U23,
input					HGX3232EIMT_UART0_RXD_U23,

output					HGX3232EIMT_UART1_TXD_U23,
input					HGX3232EIMT_UART1_RXD_U23,

output					HT3490EARZ_UART2_TXD_U22,
input					HT3490EARZ_UART2_RXD_U22,

 //ADS5400
 output 				ADS_RESET_P,
 output 				ADS_RESET_N,
 
 (*mark_debug="true"*)output 				ADS_SDENB,					
 (*mark_debug="true"*)output 				ADS_SCLK,							
 (*mark_debug="true"*)output 				ADS_SDIO,	
 (*mark_debug="true"*)input 				ADS_SO,
 
 output 				ADS_ENPWD,							
 input 					ADS_CKOUTA_n,		
 input 					ADS_CKOUTA_p,	
 input 					ADS_OVRA_P,	
 input 					ADS_OVRA_N,	  		
 input		[11:0]		ADS_DA_n,	
 input		[11:0]		ADS_DA_p,  
 
 input 					ADS_CKOUTB_n,	
 input 					ADS_CKOUTB_p,
 input					ADS_OVRB_P,
 input					ADS_OVRB_N,		
 input		[11:0] 		ADS_DB_p,
 input		[11:0] 		ADS_DB_n,
 
//DA
 input                  DAS_DCKOP_I,//DAS_clk_p
 input                  DAS_DCKON_I,//DAS_clk_n  DAS_DCKON_I
 
 output                 DAS_DCKIP_O,
 output                 DAS_DCKIN_O,   
 
 output    [10:0]       DAS_a_out_p,
 output    [10:0]       DAS_a_out_n,
 output    [10:0]       DAS_b_out_p,
 output    [10:0]       DAS_b_out_n,
 
 (*mark_debug="true"*)output                 DAS_SPI_CSB  ,
 (*mark_debug="true"*)output                 DAS_SPI_SCLK ,
 (*mark_debug="true"*)output                 DAS_SPI_SDIO ,
 (*mark_debug="true"*)input                  DAS_SPI_SDO  ,
 
 output                 DAS_PD,

//AD4356 Ctrl
output                 XND4351CQL_XND4351CQL_CLK1_U28, 
output                 XND4351CQL_XND4351CQL_DATA1_U28,
output                 XND4351CQL_XND4351CQL_LE1_U28,
output                 XND4351CQL_XND4351CQL_CE1_U28,
input                 XND4351CQL_OUTMUX1_U28,
input                 XND4351CQL_LD1_U28, 

output                 XND4351CQL_XND4351CQL_CLK2_U32, 
output                 XND4351CQL_XND4351CQL_DATA2_U32,
output                 XND4351CQL_XND4351CQL_LE2_U32,
output                 XND4351CQL_XND4351CQL_CE2_U32,
input                 XND4351CQL_OUTMUX2_U32,
input                 XND4351CQL_LD2_U32, 

 //GX122 Temperature Sensor 
inout					GX122_WD_SOI_U138,
output					GX122_WD_CS_U138,
output					GX122_WD_SCLK_U138,

 //LED
 output                 LED1,
 output                 LED2,
// output                 FPGA_INIT_LED3,
// output                 FPGA_DONE_LED4,   

 
  //单刀双致开关控制
  output               ARW3271_ARW3271_CTRL12_U76, 
  output               ARW3271_ARW3271_CTRL11_U74,   
  output               ARW3271_ARW3271_CTRL10_U73,  
  output               ARW3271_ARW3271_CTRL9_U71,    
  output               ARW3271_ARW3271_CTRL8_U70,     
  output               ARW3271_ARW3271_CTRL7_U66,    
  output               ARW3271_IFIN_SPDT_CTRL4_U59, 
  output               ARW3271_IFIN_SPDT_CTRL5_U60, 
  output               ARW3271_ARW3271_CTRL6_U65, 
  output               ARW3271_IFIN_SPDT_CTRL1_U48, 
  output               ARW3271_IFIN_SPDT_CTRL2_U53, 
  output               ARW3271_IFIN_SPDT_CTRL3_U54,
  
  output              ARW3271_RFOUT_SPDT_CTRL2_U86,
  output              ARW3271_RFOUT_SPDT_CTRL1_U85,
  output              ARW3271_RFIN_SPDT_CTRL1_U40,
  output              ARW3271_RFIN_SPDT_CTRL2_U46,
 
  output			    X122A_RFIN_SPDT_1_U34,  
  output			    X122A_RFIN_SPDT_2_U35 , 
   //----------上位机控制---------
 output               ARW3271_RFOUT_SPDT_CTRL3_U104,
 //////////////////////////////////
 
 
 //四路开关器控制
  output               ARW3433_RFIN_ARW3433_V1_U39,    
  output               ARW3433_RFIN_ARW3433_V2_U39,  
  output               ARW3433_RFIN_ARW3433_V3_U39,

  output               ARW3433_IFIN_ARW3433_V3_U47, 
  output               ARW3433_IFIN_ARW3433_V2_U47,  
  output               ARW3433_IFIN_ARW3433_V1_U47,
  
  output               ARW3433_IFOUT_ARW3433_V3_U77, 
  output               ARW3433_IFOUT_ARW3433_V2_U77,  
  output               ARW3433_IFOUT_ARW3433_V1_U77,
 
  output               ARW3433_RFOUT_ARW3433_V1_1_U90, 
  output               ARW3433_RFOUT_ARW3433_V2_1_U90,  
  output               ARW3433_RFOUT_ARW3433_V3_1_U90, 
  
 //----------上位机控制四路开关---------
  output              ARW3433_RFOUT_ARW3433_V1_2_U97, 
  output              ARW3433_RFOUT_ARW3433_V2_2_U97,  
  output              ARW3433_RFOUT_ARW3433_V3_2_U97,
 
  output              ARW3433_RFOUT_ARW3433_V1_3_U98, 
  output              ARW3433_RFOUT_ARW3433_V2_2_U98,  
  output              ARW3433_RFOUT_ARW3433_V3_2_U98,
  //////////////////////////////
 
 //衰减器控制
  output               ARW637_IFIN_DSA_LE_BUF_U43,
  output               ARW637_IFIN_DSA_SCK_BUF_U43,
  output               ARW637_IFIN_DSA_SDI_BUF_U43,
 
  output                ARW637_IFOUT_DSA_LE_BUF_U81,
  output                ARW637_IFOUT_DSA_SCK_BUF_U81,
  output                ARW637_IFOUT_DSA_SDI_BUF_U81,

  output               ARW637_RFIN_DSA_SDI_BUF_U37,
  output               ARW637_RFIN_DSA_SCK_BUF_U37 ,
  output			   ARW637_RFIN_DSA_LE_BUF_U37,    
  
  //----------上位机控制衰减器---------
  output               ARW637_RFOUT_DSA_LE1_U91,    
  output               ARW637_RFOUT_DSA_SCK1_U91,   
  output               ARW637_RFOUT_DSA_SDI1_U91,  
  
  output               ARW637_RFOUT_DSA_LE2_U92, 
  output               ARW637_RFOUT_DSA_SCK2_U92, 
  output               ARW637_RFOUT_DSA_SDI2_U92, 
 
  output               ARW637_RFOUT_DSA_LE3_U94, 
  output               ARW637_RFOUT_DSA_SCK3_U94, 
  output               ARW637_RFOUT_DSA_SDI3_U94, 
 ///////////////////////////////// 
  
//增益放大器控制

  output                X114_RFIN_X114_EN_U38,
  output                X114_RFIN_X114_BYP_U38,

  output                GMB2314_IFIN_250MHz_GMB2314_V2_U89, 
  output                GMB2314_IFIN_250MHz_GMB2314_V1_U89, 
 
  output                GMB2314_IFIN_GMB2314_V2_2_U55,
  output                GMB2314_IFIN_GMB2314_V1_2_U55,

  output                GMB2314_IFIN_GMB2314_V1_1_U44,
  output                GMB2314_IFIN_GMB2314_V2_1_U44,
 
  output                GMB2314_IFOUT_GMB2314_V2_4_U82,
  output                GMB2314_IFOUT_GMB2314_V1_4_U82,
 
  output                GMB2314_IFIN_GMB2314_V1_3_U67,
  output                GMB2314_IFIN_GMB2314_V2_3_U67,

//----------上位机控制放大器---------
  output                X144_RFOUT_X114_BYPASS_U93, 
  output                X144_RFOUT_X114_EN_U93, 
  output                X145_RFOUT_X145_EN_U99,
  
//////////////////////////////


//电源使能控制
    output              GM12051ACPZ_R7_CLK_3V3_2_EN_U10,
    output              GM12051ACPZ_R7_DA_P1V8_EN_U4,
    output              GM12051ACPZ_R7_AD_P3V3_EN_U7, 
    output              GM12051ACPZ_R7_CLK_3V3_1_EN_U8,
    output              CLP3045_DD_DA_P3V3_EN_U6,
    output              CLP3045_DD_VCC_P5V3_EN_U3,
    output              CLP3045_DD_RFOUT_P5V_EN_U11, 
    output              CLP3045_DD_RFIN_P5V_EN_U9, 
    output              LMX4644SZ_VCC_P3V8_EN_U3,  

//预留的8个IO口         
    output              FPGA_IO1,
    output              FPGA_IO2,
    output              FPGA_IO3,
    output              FPGA_IO4,
    output              FPGA_IO5,
    output              FPGA_IO6,
    output              FPGA_IO7,       
    output              FPGA_IO8

    );
    
wire PLL2_CLK_100MHz;  
wire PLL2_CLK_25MHz;   
wire soft_rest;  
wire locked;   
 
 wire [7:0]Work_mode_reg;
 
wire [6:0] ALT_RRF_Gain_U37_reg; 
wire [6:0] ALT_TIF_Gain_U81_reg; 
wire [6:0] ALT_RIF_Gain_U43_reg;  
    
 wire [7:0] ARW637_RFOUT_DSA_SDI1_U91_reg;
 wire [7:0]ARW637_RFOUT_DSA_SDI2_U92_reg;
 wire [7:0]ARW637_RFOUT_DSA_SDI3_U94_reg; 
 
 wire [31:0]     ALT_Value_reg;
 wire[15:0]     Tempe_data;
 wire            ALT_State;
 
wire    DA_Work_Flag;
wire    AD_Work_Flag;
//wire    ADS_OVRA;
//wire    ADS_OVRB;
 
wire AD_Locked; 
wire [31:0] Freq_out; 
wire FFT_En;
wire [7:0] change;

//上电
assign GM12051ACPZ_R7_CLK_3V3_2_EN_U10  =1'D1;
assign GM12051ACPZ_R7_DA_P1V8_EN_U4     =1'D1;   
assign GM12051ACPZ_R7_AD_P3V3_EN_U7     =1'D1;   
assign GM12051ACPZ_R7_CLK_3V3_1_EN_U8   =1'D1; 
assign CLP3045_DD_DA_P3V3_EN_U6         =1'D1;       
assign CLP3045_DD_VCC_P5V3_EN_U3        =1'D1;      
assign CLP3045_DD_RFOUT_P5V_EN_U11      =1'D1;    
assign CLP3045_DD_RFIN_P5V_EN_U9        =1'D1;      
assign LMX4644SZ_VCC_P3V8_EN_U3         =1'D1;   
//状态锁定标志

assign ALT_State = locked & DA_Work_Flag & AD_Work_Flag   ;
/////////////////////////////////测试区域///////////////////////////



////////////////////////////////////////////////////////////////////


 ///////////////////////////////软复位产生/////////////////////////

REST_GEN U_REST_GEN(
    .clk_25mhz  (FPGA_clk_25mhz), 
    .Reset      (soft_rest) 
 ); 
////////////////////////////////////////////////////////////////////

 ///////////////////////////////时钟信号生成/////////////////////////
  CLK_GEN U_CLK_GEN
   (
    // Clock out ports
    .clk_out1(PLL2_CLK_100MHz),     // output clk_out1
    .clk_out2(PLL2_CLK_25MHz),     // output clk_out1
    // Status and control signals
    .resetn(soft_rest), // input resetn
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(FPGA_clk_25mhz));      // input clk_in1
////////////////////////////////////////////////////////////////////////    
  
  
///////////////////////////////工作状态呼吸灯/////////////////////////    
 BREATHING_LIGHT U_BREATHING_LIGHT
   (
    .CLK(PLL2_CLK_100MHz), 
    .Reset(soft_rest),      
    .LED2(LED2)
    ); 
////////////////////////////////////////////////////////////////////////  


 ////////////////////////////上位机串口通讯/////////////////////////////
UART_TOP U_UART_TOP(
	.Clk_100MHz				( PLL2_CLK_100MHz ),  
	.Reset_n				( locked  ),
	
	.UART_Rx				( HT3490EARZ_UART2_RXD_U22 ),
	.UART_Tx				( HT3490EARZ_UART2_TXD_U22 ),
	
	.ALT_Value				(  ALT_Value_reg ),
	.Work_mode				( Work_mode_reg ),
	.ALT_TRF_Gain1_U91	    ( ARW637_RFOUT_DSA_SDI1_U91_reg ),
	.ALT_TRF_Gain2_U92		( ARW637_RFOUT_DSA_SDI2_U92_reg  ),
	.ALT_TRF_Gain3_U94		( ARW637_RFOUT_DSA_SDI3_U94_reg ),
	
	.ALT_PA_U93			    ({X144_RFOUT_X114_EN_U93,X144_RFOUT_X114_BYPASS_U93}),
	.ALT_PA1_U99			(X145_RFOUT_X145_EN_U99),
	
	.SW_U97                 ({ARW3433_RFOUT_ARW3433_V3_2_U97,ARW3433_RFOUT_ARW3433_V2_2_U97,ARW3433_RFOUT_ARW3433_V1_2_U97}),
    .SW_U98                 ({ARW3433_RFOUT_ARW3433_V3_2_U98,ARW3433_RFOUT_ARW3433_V2_2_U98,ARW3433_RFOUT_ARW3433_V1_3_U98}),
    .SW_U104                ( ARW3271_RFOUT_SPDT_CTRL3_U104),
    .X122A_SW_U35           (X122A_RFIN_SPDT_2_U35),
	.X122A_SW_U34           (X122A_RFIN_SPDT_1_U34),
    
    
    .Tempe_data             ( Tempe_data ),                   
    .ALT_State              ( ALT_State ),                     
    .FFT_En                 ( FFT_En ),  
    .change                 ( change ),          
             
    .Clk_16xBps             (  ),
    
    .UART_Rx_State          (  ),
	.UART_Pout              (  ),
    
	.Feed_back              (  ),
    .UART_Tx_State          (  ),
    .rs232_flag             (  ),
    .data_rs232_tx          (  ),

    .Freq_out               (Freq_out)
 );
 //////////////////////////////////////////////////////////////////


 ////////////////////////////ad配置////////////////////////////////
MWD1000L_CONFIG_INIT  MWD1000L_CONFIG_INIT
(
	.clk             ( PLL2_CLK_25MHz ),
	.rst_n           (  locked ),

	.SPI_CSB         (ADS_SDENB  ),
	.SPI_SCLK        ( ADS_SCLK ),
	.SPI_SDIO        ( ADS_SDIO ),
	.SPI_SDO         ( ADS_SO ),

    .Work_Flag_DA    (1'd1 ),
	.Current_State   (  ),//Current_State_AD
    .Chip_Gain_SPI   (  ),//Chip_Gain_SPI_AD
	.Chip_ID         (  ),//Chip_ID_AD
	.Chip_Revision   (  ),//Chip_Revision_AD
	.Power_State     (1'd1  ),//locked
	.Work_Flag       (AD_Work_Flag  )//
	
);
 //////////////////////////////////////////////////////////////////


 ////////////////////////////DA配置////////////////////////////////
LTC2000_CONFIG_INIT1  LTC2000_Config_Init
(
	.sys_clk_100mhz       ( PLL2_CLK_25MHz ),
	.sys_rst              ( locked ),

    .DA_SPI_CSB         (DAS_SPI_CSB  ),   
    .DA_SPI_SCLK        (DAS_SPI_SCLK  ),  
    .DA_SPI_SDIO        (DAS_SPI_SDIO  ), 
    .DA_SPI_SDO         (DAS_SPI_SDO  ),   

	.AD_Locked          ( AD_Locked  ),	
	.Current_State_DA   (  ),	//Current_State_DA
	.DA_Work_Flag       ( DA_Work_Flag     ),	
    .DA_PD		        ( DAS_PD           )
);
///////////////////////////////////////////////////////////////////


//////////////////////链路上开关控制，PA，DSA控制/////////////////
wire [7:0] mode_chose;
SW_TOP U_SW_TOP
( 	
	.Clk                 ( PLL2_CLK_25MHz ),
	.Reset               ( locked ),

	.Work_mode           ( Work_mode_reg ),
    .Freq_set            (  mode_chose    ),//
	.PA_U38              ({X114_RFIN_X114_EN_U38               ,  X114_RFIN_X114_BYP_U38} ),  
	.PA_U44              ({GMB2314_IFIN_GMB2314_V1_1_U44       ,  GMB2314_IFIN_GMB2314_V2_1_U44} ),     
    .PA_U55              ({GMB2314_IFIN_GMB2314_V1_2_U55       ,  GMB2314_IFIN_GMB2314_V2_2_U55} ),                                                          
	.PA_U67              ({GMB2314_IFIN_GMB2314_V1_3_U67       ,  GMB2314_IFIN_GMB2314_V2_3_U67} ),    
	.PA_U82              ({GMB2314_IFOUT_GMB2314_V1_4_U82      ,  GMB2314_IFOUT_GMB2314_V2_4_U82}),      
	.PA_U89              ({GMB2314_IFIN_250MHz_GMB2314_V1_U89  ,  GMB2314_IFIN_250MHz_GMB2314_V2_U89}),                                                            
	.ALT_RRF_Gain_U37    ( ALT_RRF_Gain_U37_reg ),          
	.ALT_TIF_Gain_U81    ( ALT_TIF_Gain_U81_reg ),      
	.ALT_RIF_Gain_U43    ( ALT_RIF_Gain_U43_reg ),    
	.ARW3433_SW_U77      ({ARW3433_IFOUT_ARW3433_V3_U77,ARW3433_IFOUT_ARW3433_V2_U77,ARW3433_IFOUT_ARW3433_V1_U77}),
	.ARW3271_SW_U76      (ARW3271_ARW3271_CTRL12_U76   ),                                       
	.ARW3271_SW_U74      (ARW3271_ARW3271_CTRL11_U74   ),                                           
	.ARW3271_SW_U73      (ARW3271_ARW3271_CTRL10_U73   ),                
	.ARW3271_SW_U71      (ARW3271_ARW3271_CTRL9_U71    ),                                            
	.ARW3271_SW_U70      (ARW3271_ARW3271_CTRL8_U70    ),       
	.ARW3271_SW_U66      (ARW3271_ARW3271_CTRL7_U66    ),     
	.ARW3271_SW_U65      (ARW3271_ARW3271_CTRL6_U65    ),       
	.ARW3271_SW_U60      (ARW3271_IFIN_SPDT_CTRL5_U60  ),      
	.ARW3271_SW_U59      (ARW3271_IFIN_SPDT_CTRL4_U59  ),      
	.ARW3271_SW_U54      (ARW3271_IFIN_SPDT_CTRL3_U54  ),       
	.ARW3271_SW_U53      (ARW3271_IFIN_SPDT_CTRL2_U53  ),       
	.ARW3271_SW_U48      (ARW3271_IFIN_SPDT_CTRL1_U48  ), 
	.ARW3433_SW_U47      ({ARW3433_IFIN_ARW3433_V3_U47,ARW3433_IFIN_ARW3433_V2_U47,ARW3433_IFIN_ARW3433_V1_U47}),         
	.ARW3433_SW_U39      ({ARW3433_RFIN_ARW3433_V3_U39,ARW3433_RFIN_ARW3433_V2_U39,ARW3433_RFIN_ARW3433_V1_U39}  ),         
	.ARW3271_SW_U46      (ARW3271_RFIN_SPDT_CTRL2_U46  ),         
	.ARW3433_SW_U90      ({ARW3433_RFOUT_ARW3433_V3_1_U90,ARW3433_RFOUT_ARW3433_V2_1_U90,ARW3433_RFOUT_ARW3433_V1_1_U90}),           
	.ARW3271_SW_U86      (ARW3271_RFOUT_SPDT_CTRL2_U86 ),
	.ARW3271_SW_U85      (ARW3271_RFOUT_SPDT_CTRL1_U85),
    .ARW3271_SW_U40      (ARW3271_RFIN_SPDT_CTRL1_U40  )
//	.X122A_SW_U35        (X122A_RFIN_SPDT_2_U35),
//	.X122A_SW_U34        (X122A_RFIN_SPDT_1_U34)
);   
///////////////////////////////////////////////////////////////////


//////////////////////DSA控制数据并转串输出////////////////////////
DSA_Top  DSA_Top_Init
(
	.Clk_25MHz			       (PLL2_CLK_25MHz ),
	.Reset				       (locked),
	
  	.ALT_TIF_Gain_U91	       (ARW637_RFOUT_DSA_SDI1_U91_reg), //       ARW637_RFOUT_DSA_SDI1_U91_reg
	.ALT_TRF_Gain_U92	       (ARW637_RFOUT_DSA_SDI2_U92_reg ),    //   ARW637_RFOUT_DSA_SDI2_U92_reg
	.ALT_TRF_Gain_U94	       (ARW637_RFOUT_DSA_SDI3_U94_reg ),        //ARW637_RFOUT_DSA_SDI3_U94_reg
	.ALT_TRF_Gain_U37	       ( {1'b0,ALT_RRF_Gain_U37_reg}),
	.ALT_TIF_Gain_U81	       ( {1'b0,ALT_TIF_Gain_U81_reg} ),
	.ALT_RIF_Gain_U43	       ( {1'b0,ALT_RIF_Gain_U43_reg}),     
	
	.ALT_TIF_Gain_U91_LE       ( ARW637_RFOUT_DSA_LE1_U91 ),          // ALT_TIF_Gain
	.ALT_TIF_Gain_U91_CLK      ( ARW637_RFOUT_DSA_SCK1_U91 ),
	.ALT_TIF_Gain_U91_SERNIN   ( ARW637_RFOUT_DSA_SDI1_U91),
	
	.ALT_TIF_Gain_U92_LE       ( ARW637_RFOUT_DSA_LE2_U92 ),            // ALT_TRF_Gain1  U104
	.ALT_TIF_Gain_U92_CLK      ( ARW637_RFOUT_DSA_SCK2_U92),
	.ALT_TIF_Gain_U92_SERNIN   ( ARW637_RFOUT_DSA_SDI2_U92),            //     
		
	.ALT_TIF_Gain_U94_LE        ( ARW637_RFOUT_DSA_LE3_U94 ),          // ALT_TRF_Gain2  U105 join
	.ALT_TIF_Gain_U94_CLK       ( ARW637_RFOUT_DSA_SCK3_U94),         // ALT_RIF_Gain   U50  join   
	.ALT_TIF_Gain_U94_SERNIN    ( ARW637_RFOUT_DSA_SDI3_U94 ),

	.ALT_TIF_Gain_U37_LE       ( ARW637_RFIN_DSA_LE_BUF_U37 ),          // ALT_TRF_Gain3 U107
	.ALT_TIF_Gain_U37_CLK      ( ARW637_RFIN_DSA_SCK_BUF_U37 ),
	.ALT_TIF_Gain_U37_SERNIN   (ARW637_RFIN_DSA_SDI_BUF_U37 ),
	
	.ALT_TIF_Gain_U81_LE       ( ARW637_IFOUT_DSA_LE_BUF_U81 ),          // ALT_RRF_Gain  U43 
    .ALT_TIF_Gain_U81_CLK      ( ARW637_IFOUT_DSA_SCK_BUF_U81 ),
	.ALT_TIF_Gain_U81_SERNIN   ( ARW637_IFOUT_DSA_SDI_BUF_U81),
	
	.ALT_TIF_Gain_U43_LE       ( ARW637_IFIN_DSA_LE_BUF_U43  ),          // ALT_RRF_Gain  U43 
    .ALT_TIF_Gain_U43_CLK      ( ARW637_IFIN_DSA_SCK_BUF_U43 ),
	.ALT_TIF_Gain_U43_SERNIN   ( ARW637_IFIN_DSA_SDI_BUF_U43 )
	
);
///////////////////////////////////////////////////////////////////


//////////////////////////////ADDA时钟配置////////////////////////
XND4351_TOP_ADDA U_XND4351_ADDA(
    //
	.clk_i				       ( PLL2_CLK_25MHz    ),
	.rst_i				       ( locked            ),
	//配置输入信号
	.mode_chose				   ( 8'D0            ),	
                  
	.spi_mosi_o		           ( XND4351CQL_XND4351CQL_DATA2_U32  ),                  
	.spi_sclk_o		           ( XND4351CQL_XND4351CQL_CLK2_U32   ),                  
	.spi_cs_o		           ( XND4351CQL_XND4351CQL_CE2_U32    ),                  
	.spi_miso_i		           ( 1'd0                               ),
	.LE		      	           ( XND4351CQL_XND4351CQL_LE2_U32    ),	
	 
    .PLL_LOCK		           ( XND4351CQL_LD2_U32               ) ,
    .OUTMUX		               ( XND4351CQL_OUTMUX2_U32           )	                  
 ); 
///////////////////////////////////////////////////////////////////


//////////////////////////////混频时钟配置////////////////////////
XND4351_TOP_LOOP U_XND4351_LOOP(
    //
	.clk_i				       ( PLL2_CLK_25MHz    ),
	.rst_i				       ( locked            ),
	//配置输入信号
	.mode_chose				   ( mode_chose            ),	
                  
	.spi_mosi_o		           ( XND4351CQL_XND4351CQL_DATA1_U28  ),                  
	.spi_sclk_o		           ( XND4351CQL_XND4351CQL_CLK1_U28   ),                  
	.spi_cs_o		           ( XND4351CQL_XND4351CQL_CE1_U28    ),                  
	.spi_miso_i		           ( 1'd0                         ),
	.LE		      	           ( XND4351CQL_XND4351CQL_LE1_U28    ),	
	 
    .PLL_LOCK		           ( XND4351CQL_LD1_U28               ) ,
    .OUTMUX		               ( XND4351CQL_OUTMUX1_U28           )	                  
 ); 
///////////////////////////////////////////////////////////////////


//////////////////////////////混频时钟配置////////////////////////
GX122_TEMPERATURE U_GX122_TEMPERATURE(
    //时钟及复位
	.clk_i				       ( PLL2_CLK_25MHz    ),
	.rst_i				       ( locked            ),
	//模式配置
	.mode_chose				   ( change        ),	
     //物理接口             
	.spi_mosi_o		           (),                  
	.spi_sclk_o		           ( GX122_WD_SCLK_U138 ),                  
	.spi_cs_o		           ( GX122_WD_CS_U138   ),                  
	.spi_miso_i		           ( GX122_WD_SOI_U138 ),
	.LE		      	           (),	
	 //硬件反馈输入状态监控
    .monitor0_i		           (),
    .monitor1_i		           (),	    
    //输入配置
    .send_data_reg0_i		   (),
    //数据输出
	.recive_data_reg0_o		   (Tempe_data)	                 
 ); 
///////////////////////////////////////////////////////////////////


//////////////////////////////ADDA数据链路及////////////////////////
ADDA AD_DA_FUNCTION(
	.sys_clk_100mhz		    (PLL2_CLK_100MHz),
	.sys_rst		        ( locked  ),
	
	.ALT_Value		        (ALT_Value_reg ),
	.data_AD_A_clk_n		(ADS_CKOUTA_n  ),
	.data_AD_A_clk_p        (ADS_CKOUTA_p  ),
	
	.data_AD_a_in_p		    (ADS_DA_p  ),
	.data_AD_a_in_n		    (ADS_DA_n  ),
	
	.data_AD_B_clk_p		(ADS_CKOUTB_p),
	.data_AD_B_clk_n		(ADS_CKOUTB_n),
	.data_AD_b_in_p		    (ADS_DB_p  ),
	.data_AD_b_in_n		    (ADS_DB_n  ),	

	.ADS_OVRA_P		        ( ADS_OVRA_P ),		
	.ADS_OVRA_N		        ( ADS_OVRA_N ),
	.ADS_OVRB_P		        ( ADS_OVRB_P ),		
	.ADS_OVRB_N		        ( ADS_OVRB_N ),
	
	.ADS_RESET_P		    (ADS_RESET_P),
	.ADS_RESET_N		    (ADS_RESET_N),
			
	.AD_Locked		        (AD_Locked  ),
    
    //DA
    .DA_Work_Flag	        (DA_Work_Flag ),    
 
    .data_DA_clk_p          (DAS_DCKOP_I  ),     
    .data_DA_clk_n          (DAS_DCKON_I  ), 
    
    .DAS_DCKIN              (DAS_DCKIP_O  ),
    .DAS_DCKIP              (DAS_DCKIN_O  ), 
    
    .data_DA_a_out_p        (DAS_a_out_p  ),
    .data_DA_a_out_n        (DAS_a_out_n  ),
    .data_DA_b_out_p        (DAS_b_out_p  ),
    .data_DA_b_out_n        (DAS_b_out_n  ),
   
	//FFT所需数据
	.Freq_update            (),
	.Freq_out		        (Freq_out     ),
	.FFT_En		            (FFT_En       )
	
 );    
///////////////////////////////////////////////////////////////////

endmodule
