`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:06:11
// Design Name: 
// Module Name: Single_mean
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


// *******************************************************************
// ------------------------------------------------------------------
module Single_mean
#(
	parameter	FFT_DATA_WITDH	= 32'd12,
	parameter	LOG2_FFT_LEN	= 32'd11,
	parameter	AD_WIDTH			= 32'd16
)
(
	input					Clk,
	input					Clk_100M,
	input					Reset,
	input                   measure_RX_En,
	input					P_C_flag,//1-Continuous Wave or 0-Pulse flag
	input					sink_eop,
	input					sink_sop,
	input		  [AD_WIDTH-1:0]	Data_in1,
	input		  [AD_WIDTH-1:0]	Data_in2,
	input		  [AD_WIDTH-1:0]	Data_in3,
	input		  [AD_WIDTH-1:0]	Data_in4,
	input		  [AD_WIDTH-1:0] 	Data_in_Avg,
	
	output reg			FFT_Start,
	output reg [11:0] Sngle_test,
	output [2*FFT_DATA_WITDH-1:0]FFT_Data_Out
);

// -----------------------------------------------------------------
//* PARAMETER
localparam	CACHE_NUM		= 2**(LOG2_FFT_LEN-2);//2^11
localparam	CACHE_NUM_MAX	= 2**(LOG2_FFT_LEN-2)+100;//2^11

// -----------------------------------------------------------------
//* REG
reg [LOG2_FFT_LEN-2:0]				Interval_Cnt;
reg [2*AD_WIDTH+LOG2_FFT_LEN-3:0]	Data_Sum1;
reg [2*AD_WIDTH+LOG2_FFT_LEN-3:0]	Data_Sum2;
reg [2*AD_WIDTH+LOG2_FFT_LEN-3:0]	Data_Sum3;
reg [2*AD_WIDTH+LOG2_FFT_LEN-3:0]	Data_Sum4;
reg [2*AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_Sum5;
reg [2*AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_Sum6;
reg [2*AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_Sum;
reg [2*AD_WIDTH-1:0]					Data_mean;
reg signed[AD_WIDTH-1:0]			Data_1GHz;

reg [LOG2_FFT_LEN-2:0]				Rdaddress_Cnt;
reg [LOG2_FFT_LEN-3:0]				rdaddress;
reg [LOG2_FFT_LEN-3:0]				wraddress;
reg [3:0]	Data_Sel;
reg [2:0]	Rdaddr_Cnt;
reg			rden1_reg1,rden2_reg1,rden3_reg1,rden4_reg1;
reg			rden1_reg,rden2_reg,rden3_reg,rden4_reg;
reg			rden1,rden2,rden3,rden4;
reg			Wr_Addr_flag;
reg			Wr_Addr_flag1;
reg			Wr_Addr_flag2;
reg			Rd_Addr_flag;
reg			Rd_Cnt_en;
reg			wren;
reg			sink_sop1;
reg			sink_sop2;
reg			sink_eop1;
reg			sink_eop2;
reg			P_C_flag1;
reg			P_C_flag2;

// -----------------------------------------------------------------
//* WIRE
wire[AD_WIDTH-1:0]	First_Ram_out;
wire[AD_WIDTH-1:0]	Second_Ram_out;
wire[AD_WIDTH-1:0]	Third_Ram_out;
wire[AD_WIDTH-1:0]	Fourth_Ram_out;

// ------------------------------------------------------------------------
reg [AD_WIDTH-1:0] Data_in_Avg_reg = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_in_Avg_reg <= 'd0;
	else if(Interval_Cnt == 2 && Interval_Cnt <= CACHE_NUM+2)
		Data_in_Avg_reg <= Data_in_Avg;
	else
		Data_in_Avg_reg <= Data_in_Avg_reg;
end
reg [AD_WIDTH-1:0] Data_in1_dec = 0;
reg [AD_WIDTH-1:0] Data_in2_dec = 0;
reg [AD_WIDTH-1:0] Data_in3_dec = 0;
reg [AD_WIDTH-1:0] Data_in4_dec = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_in1_dec <= 'd0;
		Data_in2_dec <= 'd0;
		Data_in3_dec <= 'd0;
		Data_in4_dec <= 'd0;
	end
	else if(Interval_Cnt == 2)begin
		Data_in1_dec <= Data_in1 - Data_in_Avg;
		Data_in2_dec <= Data_in2 - Data_in_Avg;
		Data_in3_dec <= Data_in3 - Data_in_Avg;
		Data_in4_dec <= Data_in4 - Data_in_Avg;
	end
	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+2)begin
		Data_in1_dec <= Data_in1 - Data_in_Avg_reg;
		Data_in2_dec <= Data_in2 - Data_in_Avg_reg;
		Data_in3_dec <= Data_in3 - Data_in_Avg_reg;
		Data_in4_dec <= Data_in4 - Data_in_Avg_reg;
	end
	else begin
		Data_in1_dec <= 'd0;
		Data_in2_dec <= 'd0;
		Data_in3_dec <= 'd0;
		Data_in4_dec <= 'd0;
	end
end
wire[2*AD_WIDTH-1:0]	Data_in1_square;
wire[2*AD_WIDTH-1:0]	Data_in2_square;
wire[2*AD_WIDTH-1:0]	Data_in3_square;
wire[2*AD_WIDTH-1:0]	Data_in4_square;
 // square_12_12 square_12_12_1 (
 // 		.dataa  (Data_in1_dec),  //  mult_input.dataa
 // 		.clock  (Clk),  //            .clock
 // 		.result (Data_in1_square)  // mult_output.result
 // );
 // square_12_12 square_12_12_2 (
 // 		.dataa  (Data_in2_dec),  //  mult_input.dataa
 // 		.clock  (Clk),  //            .clock
 // 		.result (Data_in2_square)  // mult_output.result
 // );
 // square_12_12 square_12_12_3 (
 // 		.dataa  (Data_in3_dec),  //  mult_input.dataa
 // 		.clock  (Clk),  //            .clock
 // 		.result (Data_in3_square)  // mult_output.result
 // );
 // square_12_12 square_12_12_4 (
 // 		.dataa  (Data_in4_dec),  //  mult_input.dataa
 // 		.clock  (Clk),  //            .clock
 // 		.result (Data_in4_square)  // mult_output.result
 // );


square_12_12 square_12_12_1 (
  .CLK(Clk),  // input wire CLK
  .A(Data_in1_dec),      // input wire [11 : 0] A
  .B(Data_in1_dec),      // input wire [11 : 0] B
  .P(Data_in1_square)      // output wire [23 : 0] P
);

square_12_12 square_12_12_2 (
  .CLK(Clk),  // input wire CLK
  .A(Data_in2_dec),      // input wire [11 : 0] A
  .B(Data_in2_dec),      // input wire [11 : 0] B
  .P(Data_in2_square)      // output wire [23 : 0] P
);


square_12_12 square_12_12_3 (
  .CLK(Clk),  // input wire CLK
  .A(Data_in3_dec),      // input wire [11 : 0] A
  .B(Data_in3_dec),      // input wire [11 : 0] B
  .P(Data_in3_square)      // output wire [23 : 0] P
);

square_12_12 square_12_12_4 (
  .CLK(Clk),  // input wire CLK
  .A(Data_in4_dec),      // input wire [11 : 0] A
  .B(Data_in4_dec),      // input wire [11 : 0] B
  .P(Data_in4_square)      // output wire [23 : 0] P
);

// ------------------------------------------------------------------------
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		begin
			sink_sop1 <= 1'd0;
			sink_sop2 <= 1'd0;
			sink_eop1 <= 1'd0;
			sink_eop2 <= 1'd0;
			
			P_C_flag1 <= 1'd0;
			P_C_flag2 <= 1'd0;
		end
	else
		begin
			sink_sop1 <= sink_sop;
			sink_sop2 <= sink_sop1;
			sink_eop1 <= sink_eop;
			sink_eop2 <= sink_eop1;
			
			P_C_flag1 <= P_C_flag;
			P_C_flag2 <= P_C_flag1;
		end
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Interval_Cnt <= 'd1;
	else if(P_C_flag2 == 0)
		Interval_Cnt <= 'd1;
	else if(sink_eop2 == 1)
		Interval_Cnt <= 'd1;
	else if(Interval_Cnt >= 'd1 && Interval_Cnt < CACHE_NUM_MAX)
		Interval_Cnt <= Interval_Cnt + 1;
	else
		Interval_Cnt <= 'd0;
end



always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum1 <= 'd0;
	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+2)
//		Data_Sum1 <= Data_Sum1 + {{LOG2_FFT_LEN-2{Data_in1[AD_WIDTH-1]}},Data_in1};
		Data_Sum1 <= Data_Sum1 + {1'd0,Data_in1_square};
	else if(Interval_Cnt == 0)
		Data_Sum1 <= 'd0;
	else
		Data_Sum1 <= Data_Sum1;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum2 <= 'd0;
	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+2)
//		Data_Sum2 <= Data_Sum2 + {{LOG2_FFT_LEN-2{Data_in2[AD_WIDTH-1]}},Data_in2};
		Data_Sum2 <= Data_Sum2 + {1'd0,Data_in2_square};
	else if(Interval_Cnt == 0)
		Data_Sum2 <= 'd0;
	else
		Data_Sum2 <= Data_Sum2;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum3 <= 'd0;
	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+2)
//		Data_Sum3 <= Data_Sum3 + {{LOG2_FFT_LEN-2{Data_in3[AD_WIDTH-1]}},Data_in3};
		Data_Sum3 <= Data_Sum3 + {1'd0,Data_in3_square};
	else if(Interval_Cnt == 0)
		Data_Sum3 <= 'd0;
	else
		Data_Sum3 <= Data_Sum3;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum4 <= 'd0;
	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+2)
//		Data_Sum4 <= Data_Sum4 + {{LOG2_FFT_LEN-2{Data_in4[AD_WIDTH-1]}},Data_in4};
		Data_Sum4 <= Data_Sum4 + {1'd0,Data_in4_square};
	else if(Interval_Cnt == 0)
		Data_Sum4 <= 'd0;
	else
		Data_Sum4 <= Data_Sum4;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum5 <= 'd0;
	else if(Interval_Cnt == CACHE_NUM+4)
//		Data_Sum5 <= {{2{Data_Sum1[AD_WIDTH+LOG2_FFT_LEN-3]}},Data_Sum1} + {{2{Data_Sum2[AD_WIDTH+LOG2_FFT_LEN-3]}},Data_Sum2};
		Data_Sum5 <= {2'd0,Data_Sum1} + {2'd0,Data_Sum2};
	else if(Interval_Cnt == 0)
		Data_Sum5 <= 'd0;
	else
		Data_Sum5 <= Data_Sum5;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum6 <= 'd0;
	else if(Interval_Cnt == CACHE_NUM+4)
//		Data_Sum6 <= {{2{Data_Sum3[AD_WIDTH+LOG2_FFT_LEN-3]}},Data_Sum3} + {{2{Data_Sum4[AD_WIDTH+LOG2_FFT_LEN-3]}},Data_Sum4};
		Data_Sum6 <= {2'd0,Data_Sum3} + {2'd0,Data_Sum4};
	else if(Interval_Cnt == 0)
		Data_Sum6 <= 'd0;
	else
		Data_Sum6 <= Data_Sum6;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_Sum <= 'd0;
	else if(Interval_Cnt == CACHE_NUM+6)
		Data_Sum <= Data_Sum5 + Data_Sum6;
	else if(Interval_Cnt == 0)
		Data_Sum <= 'd0;
	else
		Data_Sum <= Data_Sum;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_mean <= 'd0;
	else if(Interval_Cnt == CACHE_NUM+8)
		Data_mean <= Data_Sum[2*AD_WIDTH+LOG2_FFT_LEN-1:LOG2_FFT_LEN];
	else
		Data_mean <= Data_mean;
end

// ------------------------------------------------------------------
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		wren <= 1'd0;
	else if(Interval_Cnt >= 2 && Interval_Cnt <= CACHE_NUM+1)
		wren <= 1'd1;
	else
		wren <= 1'd0;
end


always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		wraddress <= 10'd0;
//	else if(Interval_Cnt >= 3 && Interval_Cnt <= CACHE_NUM+1)
	else if(wren == 1'd1)
		wraddress <= wraddress + 1; 
	else
		wraddress <= 10'd0;
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Wr_Addr_flag <= 0;
	else if(Interval_Cnt == CACHE_NUM+2)
		Wr_Addr_flag <= ~Wr_Addr_flag;
	else
		Wr_Addr_flag <= Wr_Addr_flag; 
end


Dual_pram_Pre
#(
	.DATA_WIDTH			( AD_WIDTH ),
	.ADDR_WIDTH			( LOG2_FFT_LEN-1 ),
	.OUTPUT_REG			( "TRUE" ),
	.RAM_INIT_FILE		( "" )
)
First_Ram_Init
(
	.wclk					( Clk ),
	.we					( wren ),
	.waddr				( {Wr_Addr_flag,wraddress} ),
	.wdata				( measure_RX_En ? Data_in1 : Data_in1_dec ),
	
	.rclk					( Clk_100M ),
	.re					( rden1 ),
	.raddr				( {Rd_Addr_flag,rdaddress} ),
	.rdata				( First_Ram_out )
);

Dual_pram_Pre
#(
	.DATA_WIDTH			( AD_WIDTH ),
	.ADDR_WIDTH			( LOG2_FFT_LEN-1 ),
	.OUTPUT_REG			( "TRUE" ),
	.RAM_INIT_FILE		( "" )
)
Second_Ram_Init
(
	.wclk					( Clk ),
	.we					( wren ),
	.waddr				( {Wr_Addr_flag,wraddress} ),
	.wdata				( measure_RX_En ? Data_in2 : Data_in2_dec ),
	
	.rclk					( Clk_100M ),
	.re					( rden2 ),
	.raddr				( {Rd_Addr_flag,rdaddress} ),
	.rdata				( Second_Ram_out )
);

Dual_pram_Pre
#(
	.DATA_WIDTH			( AD_WIDTH ),
	.ADDR_WIDTH			( LOG2_FFT_LEN-1 ),
	.OUTPUT_REG			( "TRUE" ),
	.RAM_INIT_FILE		( "" )
)
Third_Ram_Init
(
	.wclk					( Clk ),
	.we					( wren ),
	.waddr				( {Wr_Addr_flag,wraddress} ),
	.wdata				( measure_RX_En ? Data_in3 : Data_in3_dec ),
	
	.rclk					( Clk_100M ),
	.re					( rden3 ),
	.raddr				( {Rd_Addr_flag,rdaddress} ),
	.rdata				( Third_Ram_out )
);

Dual_pram_Pre
#(
	.DATA_WIDTH			( AD_WIDTH ),
	.ADDR_WIDTH			( LOG2_FFT_LEN-1 ),
	.OUTPUT_REG			( "TRUE" ),
	.RAM_INIT_FILE		( "" )
)
Fourth_Ram_Init
(
	.wclk					( Clk ),
	.we					( wren ),
	.waddr				( {Wr_Addr_flag,wraddress} ),
	.wdata				(  measure_RX_En ? Data_in4 : Data_in4_dec ),
	
	.rclk					( Clk_100M ),
	.re					( rden4 ),
	.raddr				( {Rd_Addr_flag,rdaddress} ),
	.rdata				( Fourth_Ram_out )
);

reg [9:0] Rd_Cnt_en_p = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Rd_Cnt_en_p <= 'd0;
	else if(Interval_Cnt == CACHE_NUM+8)
		Rd_Cnt_en_p <= 10'b11111_11111;
	else
		Rd_Cnt_en_p <= {Rd_Cnt_en_p[8:0],1'b0};
end
reg Rd_Cnt_en_r = 0;
reg Rd_Cnt_en_rr = 0;
reg Rd_Cnt_en_rrr = 0;
wire Rd_Cnt_en_up;
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rd_Cnt_en_r <= 1'd0;
	else
		Rd_Cnt_en_r <= Rd_Cnt_en_p[9];
end
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rd_Cnt_en_rr <= 1'd0;
	else
		Rd_Cnt_en_rr <= Rd_Cnt_en_r;
end
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rd_Cnt_en_rrr <= 1'd0;
	else
		Rd_Cnt_en_rrr <= Rd_Cnt_en_rr;
end
assign Rd_Cnt_en_up = ~Rd_Cnt_en_rrr && Rd_Cnt_en_rr;


always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rd_Cnt_en <= 1'd0;
	else if(P_C_flag == 0)
		Rd_Cnt_en <= 1'd0;
	else if(Rd_Cnt_en_up)
		Rd_Cnt_en <= 1'd1;
	else if(sink_eop == 1)
		Rd_Cnt_en <= 1'd0;
	else
		Rd_Cnt_en <= Rd_Cnt_en;
end



always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		FFT_Start <= 0;
	else if(P_C_flag2 == 0 || Rdaddress_Cnt == CACHE_NUM)
		FFT_Start <= 0;
	else if(Rd_Cnt_en_up)
		FFT_Start <= 1;
	else
		FFT_Start <= FFT_Start;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rdaddr_Cnt <= 3'd0;
	else if(Rd_Cnt_en == 1)
		begin
			if(Rdaddr_Cnt < 4)
				Rdaddr_Cnt <= Rdaddr_Cnt + 3'd1;
			else
				Rdaddr_Cnt <= 3'd1;
		end
	else
		Rdaddr_Cnt <= 3'd0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rdaddress_Cnt <= 'd0;
	else if(Rdaddr_Cnt == 4 && Rdaddress_Cnt < CACHE_NUM)
		Rdaddress_Cnt <= Rdaddress_Cnt + 'd1;
	else if(Rd_Cnt_en == 0)
		Rdaddress_Cnt <= 'd0;
	else
		Rdaddress_Cnt <= Rdaddress_Cnt;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rdaddress <= 'd0;
	else
		rdaddress <= Rdaddress_Cnt[LOG2_FFT_LEN-3:0];
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		begin
			Wr_Addr_flag1 <= 0;
			Wr_Addr_flag2 <= 0;
		end
	else
		begin
			Wr_Addr_flag1 <= Wr_Addr_flag; 
			Wr_Addr_flag2 <= Wr_Addr_flag1;
		end
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Rd_Addr_flag <= 0;
	else
		Rd_Addr_flag <= ~Wr_Addr_flag2; 
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rden1 <= 0;
	else if(Rdaddr_Cnt == 1 && Rdaddress_Cnt < CACHE_NUM)
		rden1 <= 1;
	else
		rden1 <= 0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rden2 <= 0;
	else if(Rdaddr_Cnt == 2 && Rdaddress_Cnt < CACHE_NUM)
		rden2 <= 1;
	else
		rden2 <= 0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rden3 <= 0;
	else if(Rdaddr_Cnt == 3 && Rdaddress_Cnt < CACHE_NUM)
		rden3 <= 1;
	else
		rden3 <= 0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rden4 <= 0;
	else if(Rdaddr_Cnt == 4 && Rdaddress_Cnt < CACHE_NUM)
		rden4 <= 1;
	else
		rden4 <= 0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		begin
			rden1_reg <= 0;
			rden2_reg <= 0;
			rden3_reg <= 0;
			rden4_reg <= 0;
			rden1_reg1 <= 0;
			rden2_reg1 <= 0;
			rden3_reg1 <= 0;
			rden4_reg1 <= 0;
		end
	else
		begin
			rden1_reg1 <= rden1;
			rden1_reg <= rden1_reg1;
			rden2_reg1 <= rden2;
			rden2_reg <= rden2_reg1;
			rden3_reg1 <= rden3;
			rden3_reg <= rden3_reg1;
			rden4_reg1 <= rden4;
			rden4_reg <= rden4_reg1;
		end
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Data_Sel <= 4'd0;
	else
		Data_Sel <= {rden1_reg,rden2_reg,rden3_reg,rden4_reg};
end
///////////////////////xiejunbo/////////////////////
wire [2*AD_WIDTH-1:0] Data_mean_reg;
Cross_Clock_Domain_Fast_to_Slow Cross_Clock_Domain_Fast_to_Slow 
(
  .fast_clk     (Clk), 
  .slow_clk     (Clk_100M), 
  .reset        (Reset), 
  .data_i       (Data_mean), 
  .data_o       (Data_mean_reg)
    
);

reg measure_RX_En0;
reg measure_RX_En1;
always@(posedge Clk_100M)begin

measure_RX_En0 <= measure_RX_En;
measure_RX_En1 <= measure_RX_En0;
end






////////////////////////////////////////////////////
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Data_1GHz <= 'd0;
	else if ( measure_RX_En1 )
		case(Data_Sel)
			4'b1000 : Data_1GHz <= First_Ram_out;
			4'b0100 : Data_1GHz <= Second_Ram_out;
			4'b0010 : Data_1GHz <= Third_Ram_out;
			4'b0001 : Data_1GHz <= Fourth_Ram_out;
			default : Data_1GHz <= 'd0;
		endcase	
	else if( Data_mean_reg >= 30 )
		case(Data_Sel)
			4'b1000 : Data_1GHz <= First_Ram_out;
			4'b0100 : Data_1GHz <= Second_Ram_out;
			4'b0010 : Data_1GHz <= Third_Ram_out;
			4'b0001 : Data_1GHz <= Fourth_Ram_out;
			default : Data_1GHz <= 'd0;
		endcase
	else
		Data_1GHz <= 'd0;
end
//
//reg [11:0]   Data_1GHz_measure;
//always@(posedge Clk_100M or negedge Reset)
//begin
//	if(!Reset)
//		Data_1GHz_measure <= 'd0;
//	else 
//		case(Data_Sel)
//			4'b1000 : Data_1GHz_measure <= Data_in1;
//			4'b0100 : Data_1GHz_measure <= Data_in2;
//			4'b0010 : Data_1GHz_measure <= Data_in3;
//			4'b0001 : Data_1GHz_measure <= Data_in4;
//			default : Data_1GHz_measure <= 'd0;
//		endcase
//end

wire [11:0]  Data_1GHz_measure_sub;
assign  Data_1GHz_measure_sub = Data_1GHz - 12'd2048;


wire [2*AD_WIDTH-1:0] Data_1GHz_square;
reg [2*AD_WIDTH-1:0] Data_1GHz_square_dev = 0;


//square_12_12 square_12_12_1GHz (
//		.dataa  (Data_1GHz),  //  mult_input.dataa
//		.clock  (Clk),  //            .clock
//		.result (Data_1GHz_square)  // mult_output.result
//);

square_12_12 square_12_12_1GHz (
  .CLK(Clk_100M),  // input wire CLK
  .A(Data_1GHz),      // input wire [11 : 0] A
  .B(Data_1GHz),      // input wire [11 : 0] B
  .P(Data_1GHz_square)      // output wire [23 : 0] P
  
);always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Data_1GHz_square_dev <= 24'd0;
	else if ( measure_RX_En1 )	
	   Data_1GHz_square_dev <= { Data_1GHz_measure_sub,12'd0 };
	else 
		Data_1GHz_square_dev <= Data_1GHz_square - Data_mean_reg;
end
assign FFT_Data_Out = {Data_1GHz_square_dev,{FFT_DATA_WITDH{1'd0}}};

/*
// ------------------------------------------------------------------
reg			rdreq;
reg			wrreq;
reg [11:0]	FFT_Data;
reg [12:0]	Threshold_Cnt;
reg [13:0]	FIFO_Cnt;
wire[11:0]	FIFO_Out;
wire[23:0]	Data_square;
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		FIFO_Cnt <= 14'd0;
	else if(Rd_Cnt_en == 1 && FIFO_Cnt < 14'h3FFF)
		FIFO_Cnt <= FIFO_Cnt + 1;
	else if(Rd_Cnt_en == 0)
		FIFO_Cnt <= 14'd0;
	else
		FIFO_Cnt <= FIFO_Cnt;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		wrreq <= 1'd0;
	else if(FIFO_Cnt >= 5 && FIFO_Cnt < 4101)
		wrreq <= 1'd1;
	else
		wrreq <= 1'd0;
end

Mult_12_12  First_square_Init
(
	.clock				( Clk_100M ),
	.dataa				( Data_1GHz ),
	
	.result				( Data_square )
);

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Threshold_Cnt <= 13'd0;
	else if(FIFO_Cnt >= 1 && FIFO_Cnt < 14'd4110 && Data_square >= 900)
		Threshold_Cnt <= Threshold_Cnt + 1;
	else if(FIFO_Cnt == 0)
		Threshold_Cnt <= 13'd0;
	else
		Threshold_Cnt <= Threshold_Cnt;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		rdreq <= 1'd0;
	else if(FIFO_Cnt >= 4110 && FIFO_Cnt <= 8205)
		rdreq <= 1'd1;
	else
		rdreq <= 1'd0;
end

FIFO_Pre  FIFO_Pre_Init
(
	.clock				( Clk_100M ),
	.wrreq				( wrreq ),
	.data					( Data_1GHz ),
	.full					(  ),
	
	.rdreq				( rdreq ),
	.empty				(  ),
	.q						( FIFO_Out )
);

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		FFT_Data <= 12'd0;
	else if(FIFO_Cnt >= 4112 && FIFO_Cnt <= 8207 && Threshold_Cnt >= 900)
		FFT_Data <= FIFO_Out;
	else
		FFT_Data <= 12'd0;
end
assign FFT_Data_Out = FFT_Data;
*/
// ------------------------------------------------------------------
//always@(posedge Clk or negedge Reset)
//begin
//	if(!Reset)
//		Sngle_test <= 12'd0;
//	else
//		case(Data_Sel)
//			4'b1000 : Sngle_test <= First_Ram_out;
//			4'b0100 : Sngle_test <= Second_Ram_out;
//			4'b0010 : Sngle_test <= Third_Ram_out;
//			4'b0001 : Sngle_test <= Fourth_Ram_out;
//			default : Sngle_test <= 12'd0;
//		endcase
//end


endmodule
