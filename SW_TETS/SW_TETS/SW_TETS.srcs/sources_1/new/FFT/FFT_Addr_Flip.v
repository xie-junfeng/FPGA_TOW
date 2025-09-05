`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:54:44
// Design Name: 
// Module Name: FFT_Addr_Flip
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

module FFT_Addr_Flip
#(
	parameter	LOG2_FFT_LEN	= 11
)
(
	input							Clk,
	input							Reset,
	input		[LOG2_FFT_LEN-1:0]	Addr_xin,

	output	reg	[LOG2_FFT_LEN-1:0]	Addr_xout
);

wire[LOG2_FFT_LEN-1:0]	Addr_reversal;

// ------------------------------------------------------------------------
genvar	i;
generate 
	for(i=0;i<LOG2_FFT_LEN;i=i+1)
		begin : ADDR_r
			assign Addr_reversal[i] = Addr_xin[LOG2_FFT_LEN-1-i];
		end
endgenerate

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Addr_xout <= 0;
	else 
		Addr_xout <= Addr_reversal;
end

endmodule
