`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/18 09:46:02
// Design Name: 
// Module Name: REST_GEN
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


module REST_GEN(
	input		   clk_25mhz,
	output	       Reset
);

reg [29:0]	Cnt_reset1 = 30'd0;

always @ ( posedge clk_25mhz )
begin
	if ( Cnt_reset1 <= 30'd10000000 )   // 1s
		Cnt_reset1 <= Cnt_reset1 + 10'd1;
	else
		Cnt_reset1 <= Cnt_reset1;
end


assign Reset = ( Cnt_reset1 > 30'd9999996 &&  Cnt_reset1 < 30'd10000000 ) ? 1'b0 : 1'b1;




endmodule
