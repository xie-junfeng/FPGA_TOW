`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:58:25
// Design Name: 
// Module Name: SYN_DPRAM
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

module SYN_DPRAM
#(
	parameter integer DATA_WIDTH	= 8,
	parameter integer ADDR_WIDTH	= 9
)
(
	input						clk,
	// Port A
	input						we_a,
    input [(ADDR_WIDTH-1):0]	addr_a,
    input [(DATA_WIDTH-1):0]	data_a,
    output reg[(DATA_WIDTH-1):0]	q_a,
	
	// Port B
	input						we_b,
    input [(ADDR_WIDTH-1):0]	addr_b,
    input [(DATA_WIDTH-1):0]	data_b,
    output reg[(DATA_WIDTH-1):0]	q_b
);

localparam MEMORY_DEPTH = 2**ADDR_WIDTH;

(* syn_ramstyle = "block_ram" *) reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];

// Port A
always@(posedge clk)
begin
	if(we_a == 1)
		ram[addr_a] <= data_a;
	else
		q_a <= ram[addr_a];
end

// Port B
always@(posedge clk)
begin
	if(we_b == 1)
		ram[addr_b] <= data_b;
	else
		q_b <= ram[addr_b];
end

endmodule
