`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 17:11:24
// Design Name: 
// Module Name: ALT_FFT_Cache
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


module ALT_FFT_Cache
(
	input				ADS_Clkin,
	input				Resetn,
	input [11:0]	AD_data1,
	input [11:0]	AD_data2,
	input [11:0]	AD_data3,
	input [11:0]	AD_data4,
	
	output[11:0]	FFT_Data1,
	output[11:0]	FFT_Data2,
	output[11:0]	FFT_Data3,
	output[11:0]	FFT_Data4,
	output			Clk_250MHz
);

reg [11:0]	Data1_Cache[9:0];
reg [11:0]	Data2_Cache[9:0];
reg [11:0]	Data3_Cache[9:0];
reg [11:0]	Data4_Cache[9:0];

// ------------------------------------------------------------------------
assign Clk_250MHz = ADS_Clkin;
assign FFT_Data1 = Data1_Cache[9];
assign FFT_Data2 = Data2_Cache[9];
assign FFT_Data3 = Data3_Cache[9];
assign FFT_Data4 = Data4_Cache[9];

always@(posedge ADS_Clkin or negedge Resetn)
begin
	if(!Resetn)
		begin
			Data1_Cache[0] <= 12'd0;
			Data2_Cache[0] <= 12'd0;
			Data3_Cache[0] <= 12'd0;
			Data4_Cache[0] <= 12'd0;
		end
	else
		begin
			Data1_Cache[0] <= AD_data1;
			Data2_Cache[0] <= AD_data2;
			Data3_Cache[0] <= AD_data3;
			Data4_Cache[0] <= AD_data4;
		end
end

genvar	i;
generate 
	for(i=1;i<10;i=i+1)
		begin : ALT_Cache
			always@(posedge ADS_Clkin or negedge Resetn)
				begin
					if(!Resetn)
						begin
							Data1_Cache[i] <= 12'd0;
							Data2_Cache[i] <= 12'd0;
							Data3_Cache[i] <= 12'd0;
							Data4_Cache[i] <= 12'd0;
						end
					else
						begin
							Data1_Cache[i] <= Data1_Cache[i-1];
							Data2_Cache[i] <= Data2_Cache[i-1];
							Data3_Cache[i] <= Data3_Cache[i-1];
							Data4_Cache[i] <= Data4_Cache[i-1];
						end
				end
		end
endgenerate

endmodule

