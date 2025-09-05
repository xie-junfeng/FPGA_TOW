`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:06:43
// Design Name: 
// Module Name: Dual_pram_Pre
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


module Dual_pram_Pre
#(
	parameter DATA_WIDTH	= 8,
	parameter ADDR_WIDTH	= 9,
	parameter OUTPUT_REG	= "TRUE",
	parameter RAM_INIT_FILE	= ""
)
(
	input [(DATA_WIDTH-1):0] wdata,
	input [(ADDR_WIDTH-1):0] waddr, raddr,
	input we, wclk, re, rclk,
	output [(DATA_WIDTH-1):0] rdata
);

localparam MEMORY_DEPTH = 2**ADDR_WIDTH;
(* syn_ramstyle = "block_ram" *) reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
reg [DATA_WIDTH-1:0] r_rdata_1P;
reg [DATA_WIDTH-1:0] r_rdata_2P;
	
//	integer i;
//	initial
//	begin
//	// By default the Efinix memory will initialize to 0
//		if (RAM_INIT_FILE != "")
//		begin
//			$readmemh(RAM_INIT_FILE, ram);
//		end
//	end
	
always@ (posedge wclk)
begin
	if (we)
		ram[waddr] <= wdata;
end
	
always @ (posedge rclk)
begin
	r_rdata_2P <= r_rdata_1P;
	if (re)
		r_rdata_1P <= ram[raddr];
	else
		r_rdata_1P <= r_rdata_1P;
end
	
generate
	if (OUTPUT_REG == "TRUE")
		assign	rdata = r_rdata_2P;
	else
		assign	rdata = r_rdata_1P;
endgenerate

endmodule


