`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 18:17:50
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
module ADDA(

input                sys_clk_100mhz            ,
input                sys_rst                   ,

//延时控
input    [31:0]      ALT_Value                 ,

//MWD1000L
input                data_AD_A_clk_p           ,
input                data_AD_A_clk_n           ,
input       [11:0]   data_AD_a_in_p            ,
input       [11:0]   data_AD_a_in_n            ,

input                data_AD_B_clk_p           ,
input                data_AD_B_clk_n           ,
input       [11:0]   data_AD_b_in_p            ,
input       [11:0]   data_AD_b_in_n            ,

input               ADS_OVRA_P                 ,
input               ADS_OVRA_N                  ,
input               ADS_OVRB_P                 ,
input               ADS_OVRB_N                 ,
                    
                    
output               ADS_RESET_P               ,
output               ADS_RESET_N               ,

//output               AD_PD,
//output               PLL_Locked                ,
output               AD_Locked                 ,
//output wire         AD_SW_Work,
//output reg          AD_SW_view,


//DA
input wire           DA_Work_Flag, 
input                data_DA_clk_p                  ,
input                data_DA_clk_n                  ,

output               DAS_DCKIN ,
output               DAS_DCKIP ,

output      [11:0]   data_DA_a_out_p                ,
output      [11:0]   data_DA_a_out_n                ,
output      [11:0]   data_DA_b_out_p                ,
output      [11:0]   data_DA_b_out_n                ,

//FFT所需数据
output                  Freq_update,
output wire  [31:0]     Freq_out,
input                    FFT_En

    );
    
 wire [11:0]	FFT_Data1;
 wire [11:0]	FFT_Data2;
 wire [11:0]	FFT_Data3;
 wire [11:0]	FFT_Data4;
 wire          Clk_250MHz;      
   
wire data_AD_B_clk;    
wire data_DA_clk;
wire PLL_Locked;
//wire			ALT_Value_Change;

//wire [13:0]	Dpram1_rd_base_addr;
//wire [13:0]	Dpram2_rd_base_addr;
//wire [13:0]	Dpram3_rd_base_addr;
//wire [13:0]	Dpram4_rd_base_addr;


//wire [1:0]ALT_Value_tmp_o;

//wire DA_Work_Flag_reg1;
//wire FFT_En_reg1;

wire  ADS_OVRB;
wire  ADS_OVRA;
 OVER U_OVER
   (
    .ADS_OVRB_P(ADS_OVRB_P),     
    .ADS_OVRB_N(ADS_OVRB_N),     
  
    .ADS_OVRA_P(ADS_OVRA_P), 
    .ADS_OVRA_N(ADS_OVRA_N),
    
    .ADS_OVRB(ADS_OVRB), 
    .ADS_OVRA(ADS_OVRA)    
           );     

//PARAMETER_PASS  PARAMETER_PASS
//(
//	.sys_clk_100mhz		            ( sys_clk_100mhz ),
//	.sys_rst			            ( sys_rst ),

	
//	.data_AD_B_clk	                ( data_AD_B_clk ),
//	.data_DA_clk	                ( data_DA_clk )	,
//	.PLL_Locked	                    ( PLL_Locked )	,
	
//    .DA_Work_Flag	                (DA_Work_Flag ), 	
//    .DA_Work_Flag_reg1	            (DA_Work_Flag_reg1 ),  
     
////    .FFT_En                         ( FFT_En ),  
////    .FFT_En_reg1                    ( FFT_En_reg1 ),        
    		
//	.ALT_Value	                    ( ALT_Value )   ,
//    .ALT_Value_tmp_o                ( ALT_Value_tmp_o )   ,
//	.Dpram1_rd_base_addr	        ( Dpram1_rd_base_addr )   ,
//	.Dpram2_rd_base_addr	        ( Dpram2_rd_base_addr )   ,	
//	.Dpram3_rd_base_addr	        ( Dpram3_rd_base_addr )   ,
//	.Dpram4_rd_base_addr	        ( Dpram4_rd_base_addr )   ,		
	
//	.ALT_Value_Change	            ( ALT_Value_Change )   	
//);

//ADDA_DATA_CHANNEL  u_ADDA_DATA_CHANNEL
//(
//	.sys_clk_100mhz		    ( sys_clk_100mhz ),
//	.sys_rst			    ( sys_rst ),
//	.ALT_Value_Change	    ( ALT_Value_Change )   ,

		
//	.data_AD_A_clk_n		(data_AD_A_clk_n  ),
//	.data_AD_A_clk_p        (data_AD_A_clk_p  ),
//	.data_AD_a_in_p		    (data_AD_a_in_p  ),
//	.data_AD_a_in_n		    (data_AD_a_in_n  ),
	
//	.data_AD_B_clk_p		(data_AD_B_clk_p),
//	.data_AD_B_clk_n		(data_AD_B_clk_n),
//	.data_AD_b_in_p		    (data_AD_b_in_p  ),
//	.data_AD_b_in_n		    (data_AD_b_in_n  ),	

//	.AD_ovr_a		        ( ADS_OVRA ),		
//	.AD_ovr_b		        ( ADS_OVRB ),
	
//	.AD_Locked		        (AD_Locked  ),  
	
//	.ADS_RESET_P		    (ADS_RESET_P  ),
//	.ADS_RESET_N		    (ADS_RESET_N  ),		

//	.PLL_Locked		        (PLL_Locked  ),  
////    .AD_PD                   (AD_PD),
//    //DA
//    .DA_Work_Flag	        (DA_Work_Flag_reg1 ),    
 
//    .data_DA_clk_p          (data_DA_clk_p    ),     
//    .data_DA_clk_n          (data_DA_clk_n    ), 
//    .DAS_DCKIN              (DAS_DCKIN        ),
//    .DAS_DCKIP              (DAS_DCKIP        ),
    
//    .data_DA_a_out_p        (data_DA_a_out_p  ),
//    .data_DA_a_out_n        (data_DA_a_out_n  ),
//    .data_DA_b_out_p        (data_DA_b_out_p  ),
//    .data_DA_b_out_n        (data_DA_b_out_n  ),
    	
	
//    .Dpram1_rd_base_addr	 ( Dpram1_rd_base_addr )   ,
//	.Dpram2_rd_base_addr	 ( Dpram2_rd_base_addr )   ,	
//	.Dpram3_rd_base_addr	 ( Dpram3_rd_base_addr )   ,
//	.Dpram4_rd_base_addr	 ( Dpram4_rd_base_addr )  ,  
	  
////	.FFT_Data1			     ( FFT_Data1  ),
////	.FFT_Data2			     ( FFT_Data2  ),
////	.FFT_Data3			     ( FFT_Data3  ),
////	.FFT_Data4			     ( FFT_Data4  ),  
////	.Clk_250MHz				 ( Clk_250MHz ),  
  
//	.Freq_update		     ( Freq_update ),
//	.Freq_out			     (Freq_out) , 
  
//  	.data_AD_B_clk			 (data_AD_B_clk) , 
//   	.data_DA_clk			 (data_DA_clk) ,  
  
// 	.FFT_En                   ( FFT_En ),   
//	.ALT_Value_tmp_o	      ( ALT_Value_tmp_o )      
	
	
    
//);



ADDA_DATA  u_ADDA_DATA
(
	.sys_clk_100mhz		    ( sys_clk_100mhz ),
	.sys_rst			    ( sys_rst ),
	.ALT_Value	            ( ALT_Value )   ,

		
	.data_AD_A_clk_n		(data_AD_A_clk_n  ),
	.data_AD_A_clk_p        (data_AD_A_clk_p  ),
	.data_AD_a_in_p		    (data_AD_a_in_p  ),
	.data_AD_a_in_n		    (data_AD_a_in_n  ),
	
	.data_AD_B_clk_p		(data_AD_B_clk_p),
	.data_AD_B_clk_n		(data_AD_B_clk_n),
	.data_AD_b_in_p		    (data_AD_b_in_p  ),
	.data_AD_b_in_n		    (data_AD_b_in_n  ),	

	.AD_ovr_a		        ( ADS_OVRA ),		
	.AD_ovr_b		        ( ADS_OVRB ),
	
	.AD_Locked		        (AD_Locked  ),  
	
	.ADS_RESET_P		    (ADS_RESET_P  ),
	.ADS_RESET_N		    (ADS_RESET_N  ),		

	.PLL_Locked		        (PLL_Locked  ),  

    .DA_Work_Flag	        (DA_Work_Flag ),    
 
    .data_DA_clk_p          (data_DA_clk_p    ),     
    .data_DA_clk_n          (data_DA_clk_n    ), 
    .DAS_DCKIN              (DAS_DCKIN        ),
    .DAS_DCKIP              (DAS_DCKIP        ),
    
    .data_DA_a_out_p        (data_DA_a_out_p  ),
    .data_DA_a_out_n        (data_DA_a_out_n  ),
    .data_DA_b_out_p        (data_DA_b_out_p  ),
    .data_DA_b_out_n        (data_DA_b_out_n  ),
    	
	   
  
	.Freq_update		     ( Freq_update ),
	.Freq_out			     (Freq_out) , 
  
  	.data_AD_B_clk			 (data_AD_B_clk) , 
   	.data_DA_clk			 (data_DA_clk) ,  
  
 	.FFT_En                   ( FFT_En )     
    
);








//FFT_TOP 
//#(
//	.FFT_DATA_WITDH         ( 32'd24 ),
//	.LOG2_FFT_LEN	        ( 32'd12 ),
//	.AD_WIDTH		        ( 32'd12 ),
//	.PEAK_NUM		        ( 32'd3 ),
//	.SAMPLE_FREQ	        ( 32'd1_000_000_000 )
//)


//U_FFT_TOP(
//	.Clk				     (Clk_250MHz ),
//	.Clk_100M			     ( sys_clk_100mhz ),
//	.Reset				     ( PLL_Locked ),
//	.FFT_valid			     ( 1'd1 ),
//	.measure_RX_En           ( FFT_En ),
//	.Trigger_flag		     ( 1'd1 ),
////	.Trigger_flag		     ( Probe_o[31] == 1 ? FFT_trigger : Trigger_upload ),
//	.Work_mode			     ( 1'd1 ),
//	.sink_rel			     ( 24'd0 ),
//	.sink_img			     ( 24'd0 ),
//	.FFT_Data1			     ( FFT_Data1  ),
//	.FFT_Data2			     ( FFT_Data2  ),
//	.FFT_Data3			     ( FFT_Data3  ),
//	.FFT_Data4			     ( FFT_Data4  ),
//	.MAX_Square_data	     ( 'd0   ),
//	.Probe_o			     ( 30'd0 ),
	
//	.Freq_update		     ( Freq_update ),
//	.Freq_out			     (Freq_out)
	
// ); 






 
endmodule
