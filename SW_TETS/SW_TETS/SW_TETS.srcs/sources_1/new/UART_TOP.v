`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/18 09:41:02
// Design Name: 
// Module Name: UART_TOP
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

module UART_TOP(
	input					Clk_100MHz,
	input					Reset_n   ,	
	
	(*mark_debug="true"*)input				UART_Rx,
	(*mark_debug="true"*)output				UART_Tx,
	
	output reg [31:0]	    ALT_Value,
	output reg[7:0]	        Work_mode,
	
	output reg[7:0]	       ALT_TRF_Gain1_U91,
	output reg[7:0]	       ALT_TRF_Gain2_U92,
	output reg[7:0]	       ALT_TRF_Gain3_U94,
	
	output reg[1:0]	       ALT_PA_U93,
	output reg      	   ALT_PA1_U99,

	output reg[2:0]	        SW_U97,
	output reg[2:0]      	SW_U98,
	output reg      	    SW_U104,
	
    output reg              X122A_SW_U35,
    output reg              X122A_SW_U34 ,	
	
    output  reg             FFT_En, 
    output reg     [7:0]        change,

    input [15:0]            Tempe_data,
    input 	                ALT_State,   
    input [31:0] 	        Freq_out ,
    output wire            Clk_16xBps,
    

//  Just for scop 
    output wire[8:0]       UART_Rx_State,
	output wire[7:0]	    UART_Pout,
    
	output		reg		    Feed_back,
    (*mark_debug="true"*)output wire[6:0]       UART_Tx_State,
    
    (*mark_debug="true"*)output wire		        rs232_flag,
    (*mark_debug="true"*)output wire [7:0]      data_rs232_tx
    
);

localparam    T_Constant = 21'd2000000;   // 20ms
localparam    T_Pulse    = 20'd700000;    // 7ms
reg [20:0]   T_Cnt; 

wire Frame_End;
reg [1:0] Work_mode_SW_A40i;
reg       SW_20DB_INPUT;
/////////////////////////////////////////////////////////////////////////
wire       SW_20DB_INPUT_VIO;
wire    SW_20DB_INPUT_src;
wire[7:0]	Work_mode_src;
wire [31:0]ALT_Value_src;

wire [7:0]ALT_TRF_Gain1_U91_src;
wire [7:0]ALT_TRF_Gain2_U92_src;
wire [7:0]ALT_TRF_Gain3_U94_src;

wire      ALT_PA_U93_src;
wire      ALT_PA1_U99_src;
wire [2:0]SW_U97_src;    
wire [2:0]SW_U98_src;   
wire      SW_U104_src;
reg [7:0]     change_src;
wire FFT_En_src;

wire [7:0]	Work_mode_VIO;
wire [31:0]ALT_Value_VIO;

wire [7:0]DSA_U91_VIO;
wire [7:0]DSA_U92_VIO;
wire [7:0]DSA_U94_VIO;

wire      PA_U93_VIO;
wire      PA_U99_VIO;
//wire [2:0]SW_U97_VIO;    
//wire [2:0]SW_U98_VIO;   
//wire      SW_U104_VIO;


wire [1:0] Work_mode_SW_A40i_VIO;
wire [1:0] Work_mode_SW_A40i_src;
wire       FFT_EN_VIO;
wire       SW_VIO;
wire [7:0]     change_VIO;

VIO_UART VIO_UART (
  .clk(Clk_100MHz),                // input wire clk
  .probe_in0(ALT_TRF_Gain1_U91_src),    // input wire [7 : 0] probe_in0
  .probe_in1(ALT_PA_U93_src),    // input wire [0 : 0] probe_in1
  .probe_in2(ALT_TRF_Gain2_U92_src),    // input wire [7 : 0] probe_in2
  .probe_in3(ALT_TRF_Gain3_U94_src),    // input wire [7 : 0] probe_in3
  .probe_in4(ALT_Value_src),    // input wire [2 : 0] probe_in4
  .probe_in5(SW_20DB_INPUT_src),    // input wire [0 : 0] probe_in5
  .probe_in6(Work_mode_SW_A40i_src),    // input wire [2 : 0] probe_in6
  .probe_in7(ALT_PA1_U99_src),    // input wire [0 : 0] probe_in7
  .probe_in8(SW_VIO),      // input wire [0 : 0] probe_in8
  .probe_in9(Tempe_data),      // input wire [30 : 0] probe_in9
  .probe_in10(Work_mode_src),    // input wire [7 : 0] probe_in10
  .probe_in11(ALT_State),    // input wire [7 : 0] probe_in10 
  .probe_in12(Freq_out),    // input wire [7 : 0] probe_in10  
  
  .probe_out0(DSA_U91_VIO),  // output wire [6 : 0] probe_out0
  .probe_out2(DSA_U92_VIO),  // output wire [6 : 0] probe_out2
  .probe_out3(DSA_U94_VIO),  // output wire [6 : 0] probe_out3
  .probe_out1(PA_U93_VIO),  // output wire [0 : 0] probe_out1
  .probe_out4(PA_U99_VIO),  // output wire [2 : 0] probe_out4
  .probe_out5(SW_VIO),  // output wire [0 : 0] probe_out5
  .probe_out6(ALT_Value_VIO),  // output wire [2 : 0] probe_out6
  .probe_out7(Work_mode_VIO) , // output wire [0 : 0] probe_out7
  .probe_out8(Work_mode_SW_A40i_VIO),
  .probe_out9(SW_20DB_INPUT_VIO),
  .probe_out10(change_VIO),
  .probe_out11(FFT_EN_VIO)
);

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)begin
		ALT_Value <= 32'd0;
		Work_mode <= 8'd0;
		ALT_TRF_Gain1_U91<= 8'd0;
		ALT_TRF_Gain2_U92<= 8'd0;
		ALT_PA_U93<= 2'b01;
		ALT_PA1_U99<= 1'd0;
        Work_mode_SW_A40i<=2'D0;
        SW_20DB_INPUT<= 1'd0;
        FFT_En<= 1'd0;
		end
	else if( SW_VIO )begin
		ALT_Value <= ALT_Value_VIO;
		Work_mode <= Work_mode_VIO;
		ALT_TRF_Gain1_U91<= DSA_U91_VIO;
		ALT_TRF_Gain2_U92<= DSA_U92_VIO;
		ALT_PA_U93<= {1'B0 ,~PA_U93_VIO}; 
		ALT_PA1_U99<= ~PA_U99_VIO;
		ALT_TRF_Gain3_U94<=DSA_U94_VIO;
		Work_mode_SW_A40i<=Work_mode_SW_A40i_VIO;
		SW_20DB_INPUT<=~SW_20DB_INPUT_VIO;
		change<=change_VIO;
		FFT_En<= FFT_EN_VIO;
	end        
    else begin
		ALT_Value <= ALT_Value_src;
		Work_mode <= Work_mode_src;
		ALT_TRF_Gain1_U91<= ALT_TRF_Gain1_U91_src;
		ALT_TRF_Gain2_U92<= ALT_TRF_Gain2_U92_src;
		ALT_PA_U93<= {1'B0 ,~ALT_PA_U93_src}; 
		ALT_PA1_U99<=~ ALT_PA1_U99_src;
		ALT_TRF_Gain3_U94<=ALT_TRF_Gain3_U94_src;
		Work_mode_SW_A40i<=Work_mode_SW_A40i_src;
		SW_20DB_INPUT<=~SW_20DB_INPUT_src;
		change<=change_src;
		FFT_En<= FFT_En_src;
        end
end

////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------- 


always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n) begin
			SW_U97<= 3'b011;
		    SW_U98<= 3'b010;
		    SW_U104<= 1'd1;                 
		end
	else begin
		case (Work_mode_SW_A40i)
			 2'd0:begin
		            SW_U97<= 3'b001;
		            SW_U98<= 3'b011;
		            SW_U104<= 1'd1; 
			     end
 			 2'd1:begin
		            SW_U97<= 3'b001;
		            SW_U98<= 3'b000;
		            SW_U104<= 1'd0; 
			     end
 			 2'd2:begin
			 		SW_U97<= 3'b011;
		            SW_U98<= 3'b010;
		            SW_U104<= 1'd0;  
			     end
 			 2'd3:begin
			 		SW_U97<= 3'b000;
		            SW_U98<= 3'b001;
		            SW_U104<= 1'd0;  
			     end			     
		   default:begin
			 		SW_U97<= 3'b011;
		            SW_U98<= 3'b010;
		            SW_U104<= 1'd0;  
			     end     
		endcase 
    end  
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n) begin
			X122A_SW_U35<= 1'b0;
		    X122A_SW_U34<= 1'b1;
		end
	else begin
        if(SW_20DB_INPUT)begin
        	X122A_SW_U35<= 1'b0;
		    X122A_SW_U34<= 1'b1;
        end
        else begin
            X122A_SW_U35<= 1'b1;
		    X122A_SW_U34<= 1'b0;
        end
    end  
end


//UART_Receiver 	UART_Receiver_Init
//(
//	.Clk_100MHz			( Clk_100MHz ),
//	.Reset_n			( Reset_n ),
//	.Uart_rx1			( UART_Rx ),  // input
//    .POWER_OFF_ON       (), 
////   output
//    .ALT_State	        ( ALT_State ),
//	.ALT_Value			( ALT_Value_src ),
//    .Work_mode          ( Work_mode_src ),
//	.ALT_TRF_Gain1		( ALT_TRF_Gain1_U91_src ),
//	.ALT_TRF_Gain2		( ALT_TRF_Gain2_U92_src ),
//	.ALT_TRF_Gain3		( ALT_TRF_Gain3_U94_src ),
//	.ALT_RRF_Gain		({Work_mode_SW_A40i_src,SW_20DB_INPUT_src,} ),
//	.ALT_PA				(  ),
//	.ALT_PA1			( ALT_PA1_U99_src),
	
	
//    .measure_RX_En      ( FFT_En ),
//    .Frame_End			( Frame_End ),	
//    .Clk_16xBps         ( Clk_16xBps ),
      
//    .State              ( UART_Rx_State ),
//	.UART_Pout          ( UART_Pout )
//);

UART_Receiver 	UART_Receiver_Init
(
	.Clk_100MHz			( Clk_100MHz ),
	.Reset_n			( Reset_n ),
	.Uart_rx1			( UART_Rx ),  // input

//   output
    .ALT_State	        ( ALT_State ),
	.ALT_Value			( ALT_Value_src ),
    .Work_mode          ( Work_mode_src ),
	.ALT_TRF_Gain1		( ALT_TRF_Gain1_U91_src ),
	.ALT_TRF_Gain2		( ALT_TRF_Gain2_U92_src ),
	.ALT_TRF_Gain3		( ALT_TRF_Gain3_U94_src ),
	.ALT_RRF_Gain		({Work_mode_SW_A40i_src, ALT_PA_U93_src,SW_20DB_INPUT_src,
	                      ALT_PA1_U99_src,FFT_En_src}  ),
	.ALT_PA				(  ),
    .Frame_End          ( Frame_End ),
    .Clk_16xBps         ( Clk_16xBps ),
      
    .State              ( UART_Rx_State ),
	.UART_Pout          ( UART_Pout )
);



//UART_Transmitter   UART_Transmitter_Init
//(
//	.Clk_100MHz     	( Clk_100MHz ),
//	.Reset_n			( Reset_n ),
//	.Feed_back          ( Feed_back ),

//	.ALT_Value			( ALT_Value_src  ),
//    .Work_mode          ( Work_mode_src  ),    
//	.ALT_TRF_Gain1		( ALT_TRF_Gain1_U91_src  ),
//	.ALT_TRF_Gain2		( ALT_TRF_Gain2_U92_src  ),
//	.ALT_TRF_Gain3		( ALT_TRF_Gain3_U94_src  ),
//	.ALT_RRF_Gain		(),
//	.ALT_PA				( ALT_PA_U93_src  ),
//	.ALT_PA1			( ALT_PA1_U99_src),	
	
//    .Tempe_data         ( Tempe_data ),
//    .Freq_out           ( Freq_out ),
//    .ALT_State          ( ALT_State),
////   output	
//	.UART_Tx            ( UART_Tx       ),
//	.Current_State      ( UART_Tx_State ),
//	.rs232_flag         ( rs232_flag    ),
//	.data_rs232_tx      ( data_rs232_tx )   
//);

UART_Transmitter   UART_Transmitter_Init
(
	.Clk_100MHz     	( Clk_100MHz ),
	.Reset_n			( Reset_n ),
	.Feed_back          ( Feed_back ),
   
	.ALT_Value			( ALT_Value_src ),
    .Work_mode          ( Work_mode_src ),    
	.ALT_TRF_Gain1		( ALT_TRF_Gain1_U91_src ),
	.ALT_TRF_Gain2		( ALT_TRF_Gain2_U92_src ),
	.ALT_TRF_Gain3		( ALT_TRF_Gain3_U94_src ),
	.ALT_RRF_Gain		({Work_mode_SW_A40i_src, ALT_PA_U93_src,SW_20DB_INPUT_src,
	                      ALT_PA1_U99_src,FFT_En_src}  ),
	
	.ALT_PA				( 8'd0 ),
    .Tempe_data         ( Tempe_data ),
    .ALT_State          ( ALT_State ),
//   output	
	.UART_Tx            ( UART_Tx ),
    
	.Current_State      ( UART_Tx_State ),
	.rs232_flag         ( rs232_flag ),
	.data_rs232_tx      ( data_rs232_tx )   
);



always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)begin
		T_Cnt <= 21'd0;
		change_src<= 8'd0;
		end
	else if( Frame_End )begin
		T_Cnt <= 21'd1;
		change_src<= 8'd7;
		end
    else if ( T_Cnt >= T_Constant )begin
		T_Cnt <= T_Cnt;
		change_src<= 8'd0;
		end
	else if ( T_Cnt >=1 )begin
		T_Cnt <= T_Cnt + 1;
		change_src<= change_src;
		end
    else begin
        T_Cnt <= T_Cnt;
        change_src<= change_src;
        end
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Feed_back <= 1'b0;
	else if( T_Cnt >= 50000 && T_Cnt <= T_Pulse )
		Feed_back <= 1'b1; 
	else
		Feed_back <= 1'b0;
end

endmodule
