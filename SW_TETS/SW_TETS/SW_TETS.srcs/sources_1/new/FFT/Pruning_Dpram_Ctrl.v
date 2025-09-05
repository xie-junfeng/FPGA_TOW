`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:59:54
// Design Name: 
// Module Name: Pruning_Dpram_Ctrl
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


module  Pruning_Dpram_Ctrl
#(
	parameter DATA_INPUT_WITDH	= 12,
	parameter LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							mem_switch,
	input	wire [3:0]						Current_state,
	input	wire [LOG2_FFT_LEN:0]			Repeat_Cnt,
	input	wire							Repeat_Peak_en,
	
	input	wire							sink_valid,
	input	wire [LOG2_FFT_LEN-4:0]			sink_addr,
	input	wire [DATA_INPUT_WITDH*2+3:0]	sink_data,
	
	input	wire							Butfly_Wr,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_addr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_addr_b,
	input	wire [DATA_INPUT_WITDH*2+3:0]	Butfly_data_a,
	input	wire [DATA_INPUT_WITDH*2+3:0]	Butfly_data_b,
	
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_b,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr0_q_a,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr0_q_b,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr1_q_a,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr1_q_b,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr2_q_a,
	output	wire [DATA_INPUT_WITDH*2+3:0]	dpr2_q_b
);

// -----------------------------------------------------------------
//* FSM
localparam	FFT_STATE_RESET		= 4'b0000;
localparam	FFT_STATE_READ		= 4'b0001;
localparam	FFT_STATE_WAIT		= 4'b0010;
localparam	FFT_STATE_WN_PRE	= 4'b0011;
localparam	FFT_STATE_FIRST		= 4'b0100;
localparam	FFT_STATE_SECOND	= 4'b0101;
localparam	FFT_STATE_THIRD		= 4'b0110;
localparam	FFT_STATE_FOURTH	= 4'b0111;
localparam	FFT_STATE_FIFTH		= 4'b1000;
localparam	FFT_STATE_REPEAT	= 4'b1001;

// -----------------------------------------------------------------
//* REG
reg								dpr0_wr_a;
reg								dpr0_wr_b;
reg [LOG2_FFT_LEN-4:0]			dpr0_addr_a;
reg [LOG2_FFT_LEN-4:0]			dpr0_addr_b;
reg [DATA_INPUT_WITDH*2+3:0]	dpr0_data_a;
reg [DATA_INPUT_WITDH*2+3:0]	dpr0_data_b;
reg								dpr1_wr_a;
reg								dpr1_wr_b;
reg [LOG2_FFT_LEN-4:0]			dpr1_addr_a;
reg [LOG2_FFT_LEN-4:0]			dpr1_addr_b;
reg [DATA_INPUT_WITDH*2+3:0]	dpr1_data_a;
reg [DATA_INPUT_WITDH*2+3:0]	dpr1_data_b;
reg								dpr2_wr_a;
reg								dpr2_wr_b;
reg [LOG2_FFT_LEN-4:0]			dpr2_addr_a;
reg [LOG2_FFT_LEN-4:0]			dpr2_addr_b;
reg [DATA_INPUT_WITDH*2+3:0]	dpr2_data_a;
reg [DATA_INPUT_WITDH*2+3:0]	dpr2_data_b;

// -----------------------------------------------------------------
//* WIRE
// wire[DATA_INPUT_WITDH*2+1:0]	dpr0_q_a;
// wire[DATA_INPUT_WITDH*2+1:0]	dpr0_q_b;
// wire[DATA_INPUT_WITDH*2+1:0]	dpr1_q_a;
// wire[DATA_INPUT_WITDH*2+1:0]	dpr1_q_b;

// -----------------------------------------------------------------
//* DPRAM0
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr0_wr_a <= 0;
			dpr0_wr_b <= 0;
			dpr0_addr_a <= 0;
			dpr0_addr_b <= 0;
			dpr0_data_a <= 0;
			dpr0_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_READ && mem_switch == 0)
		begin
			dpr0_wr_a <= sink_valid;
			dpr0_wr_b <= 0;
			dpr0_addr_a <= sink_addr;
			dpr0_addr_b <= 0;
			dpr0_data_a <= sink_data;
			dpr0_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(mem_switch == 0)
				begin
					dpr0_wr_a <= Butfly_Wr;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= Butfly_addr_a;
					dpr0_addr_b <= 0;
					dpr0_data_a <= Butfly_data_a;
					dpr0_data_b <= 0;
				end
			else if(Repeat_Cnt == 0)
				begin
					dpr0_wr_a <= 0;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= Butfly_raddr_a;
					dpr0_addr_b <= Butfly_raddr_b;
					dpr0_data_a <= 0;
					dpr0_data_b <= 0;
				end
			else
				begin
					dpr0_wr_a <= 0;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= 0;
					dpr0_addr_b <= 0;
					dpr0_data_a <= 0;
					dpr0_data_b <= 0;
				end
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(mem_switch == 0)
				begin
					dpr0_wr_a <= Butfly_Wr;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= Butfly_addr_a;
					dpr0_addr_b <= 0;
					dpr0_data_a <= Butfly_data_a;
					dpr0_data_b <= 0;
				end
			else
				begin
					dpr0_wr_a <= 0;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= Butfly_raddr_a;
					dpr0_addr_b <= Butfly_raddr_b;
					dpr0_data_a <= 0;
					dpr0_data_b <= 0;
				end
		end
	else if(Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(mem_switch == 0)
				begin
					dpr0_wr_a <= Butfly_Wr;
					dpr0_wr_b <= Butfly_Wr;
					dpr0_addr_a <= Butfly_addr_a;
					dpr0_addr_b <= Butfly_addr_b;
					dpr0_data_a <= Butfly_data_a;
					dpr0_data_b <= Butfly_data_b;
				end
			else
				begin
					dpr0_wr_a <= 0;
					dpr0_wr_b <= 0;
					dpr0_addr_a <= Butfly_raddr_a;
					dpr0_addr_b <= Butfly_raddr_b;
					dpr0_data_a <= 0;
					dpr0_data_b <= 0;
				end
		end
	else
		begin
			dpr0_wr_a <= 0;
			dpr0_wr_b <= 0;
			dpr0_addr_a <= 0;
			dpr0_addr_b <= 0;
			dpr0_data_a <= 0;
			dpr0_data_b <= 0;
		end
end

SYN_DPRAM  
#(
	.DATA_WIDTH		( DATA_INPUT_WITDH*2+4 ),
	.ADDR_WIDTH		( LOG2_FFT_LEN-3 )
)
dp_ram_0
(
	.clk			( clk ),
	//Port A
	.we_a			( dpr0_wr_a ),
    .addr_a			( dpr0_addr_a ),
    .data_a			( dpr0_data_a ),
    .q_a			( dpr0_q_a ),
	//Port B
	.we_b			( dpr0_wr_b ),
    .addr_b			( dpr0_addr_b ),
    .data_b			( dpr0_data_b ),
    .q_b			( dpr0_q_b )
);

// -----------------------------------------------------------------
//* DPRAM1
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr1_wr_a <= 0;
			dpr1_wr_b <= 0;
			dpr1_addr_a <= 0;
			dpr1_addr_b <= 0;
			dpr1_data_a <= 0;
			dpr1_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_READ && mem_switch == 1)
		begin
			dpr1_wr_a <= sink_valid;
			dpr1_wr_b <= 0;
			dpr1_addr_a <= sink_addr;
			dpr1_addr_b <= 0;
			dpr1_data_a <= sink_data;
			dpr1_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(mem_switch == 1)
				begin
					dpr1_wr_a <= Butfly_Wr;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= Butfly_addr_a;
					dpr1_addr_b <= 0;
					dpr1_data_a <= Butfly_data_a;
					dpr1_data_b <= 0;
				end
			else if(Repeat_Cnt == 0)
				begin
					dpr1_wr_a <= 0;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= Butfly_raddr_a;
					dpr1_addr_b <= Butfly_raddr_b;
					dpr1_data_a <= 0;
					dpr1_data_b <= 0;
				end
			else
				begin
					dpr1_wr_a <= 0;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= 0;
					dpr1_addr_b <= 0;
					dpr1_data_a <= 0;
					dpr1_data_b <= 0;
				end
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(mem_switch == 1)
				begin
					dpr1_wr_a <= Butfly_Wr;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= Butfly_addr_a;
					dpr1_addr_b <= 0;
					dpr1_data_a <= Butfly_data_a;
					dpr1_data_b <= 0;
				end
			else
				begin
					dpr1_wr_a <= 0;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= Butfly_raddr_a;
					dpr1_addr_b <= Butfly_raddr_b;
					dpr1_data_a <= 0;
					dpr1_data_b <= 0;
				end
		end
	else if(Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(mem_switch == 1)
				begin
					dpr1_wr_a <= Butfly_Wr;
					dpr1_wr_b <= Butfly_Wr;
					dpr1_addr_a <= Butfly_addr_a;
					dpr1_addr_b <= Butfly_addr_b;
					dpr1_data_a <= Butfly_data_a;
					dpr1_data_b <= Butfly_data_b;
				end
			else
				begin
					dpr1_wr_a <= 0;
					dpr1_wr_b <= 0;
					dpr1_addr_a <= Butfly_raddr_a;
					dpr1_addr_b <= Butfly_raddr_b;
					dpr1_data_a <= 0;
					dpr1_data_b <= 0;
				end
		end
	else
		begin
			dpr1_wr_a <= 0;
			dpr1_wr_b <= 0;
			dpr1_addr_a <= 0;
			dpr1_addr_b <= 0;
			dpr1_data_a <= 0;
			dpr1_data_b <= 0;
		end
end

SYN_DPRAM  
#(
	.DATA_WIDTH		( DATA_INPUT_WITDH*2+4 ),
	.ADDR_WIDTH		( LOG2_FFT_LEN-3 )
)
dp_ram_1
(
	.clk			( clk ),
	//Port A
	.we_a			( dpr1_wr_a ),
    .addr_a			( dpr1_addr_a ),
    .data_a			( dpr1_data_a ),
    .q_a			( dpr1_q_a ),
	//Port B
	.we_b			( dpr1_wr_b ),
    .addr_b			( dpr1_addr_b ),
    .data_b			( dpr1_data_b ),
    .q_b			( dpr1_q_b )
);

// -----------------------------------------------------------------
//* DPRAM2
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr2_wr_a <= 0;
			dpr2_wr_b <= 0;
			dpr2_addr_a <= 0;
			dpr2_addr_b <= 0;
			dpr2_data_a <= 0;
			dpr2_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_READ)
		begin
			dpr2_wr_a <= sink_valid;
			dpr2_wr_b <= 0;
			dpr2_addr_a <= sink_addr;
			dpr2_addr_b <= 0;
			dpr2_data_a <= sink_data;
			dpr2_data_b <= 0;
		end
	else if(Current_state == FFT_STATE_FIRST && (Repeat_Cnt != 0 || Repeat_Peak_en == 1))
		begin
			dpr2_wr_a <= 0;
			dpr2_wr_b <= 0;
			dpr2_addr_a <= Butfly_raddr_a;
			dpr2_addr_b <= Butfly_raddr_b;
			dpr2_data_a <= 0;
			dpr2_data_b <= 0;
		end
	else
		begin
			dpr2_wr_a <= 0;
			dpr2_wr_b <= 0;
			dpr2_addr_a <= 0;
			dpr2_addr_b <= 0;
			dpr2_data_a <= 0;
			dpr2_data_b <= 0;
		end
end

SYN_DPRAM  
#(
	.DATA_WIDTH		( DATA_INPUT_WITDH*2+4 ),
	.ADDR_WIDTH		( LOG2_FFT_LEN-3 )
)
FFT_Cache
(
	.clk			( clk ),
	//Port A
	.we_a			( dpr2_wr_a ),
    .addr_a			( dpr2_addr_a ),
    .data_a			( dpr2_data_a ),
    .q_a			( dpr2_q_a ),
	//Port B
	.we_b			( dpr2_wr_b ),
    .addr_b			( dpr2_addr_b ),
    .data_b			( dpr2_data_b ),
    .q_b			( dpr2_q_b )
);

endmodule

