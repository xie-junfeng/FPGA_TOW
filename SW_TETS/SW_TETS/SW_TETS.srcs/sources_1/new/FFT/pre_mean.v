`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:05:30
// Design Name: 
// Module Name: pre_mean
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


module pre_mean
#(
	parameter	AD_WIDTH		= 32'd16,
    parameter	LOG2_FFT_LEN	= 32'd11
)
(
	input					Clk,
	input					Clk_100M,
	input					Reset,

	input		  [AD_WIDTH-1:0]	Data_in1,
	input		  [AD_WIDTH-1:0]	Data_in2,
	input		  [AD_WIDTH-1:0]	Data_in3,
	input		  [AD_WIDTH-1:0]	Data_in4,
	
	output reg [AD_WIDTH-1:0] Data_out1,
	output reg [AD_WIDTH-1:0] Data_out2,
	output reg [AD_WIDTH-1:0] Data_out3,
    output reg [AD_WIDTH-1:0] Data_out4,

    output reg [AD_WIDTH-1:0] Data_in_Avg
);


//wire[AD_WIDTH-1:0]Data_1GHz_square;
//square_12_12 square_12_12_0 (
//		.dataa  (Data_1GHz),  //  mult_input.dataa
//		.result (Data_1GHz_square)  // mult_output.result
//);

//square_12_12 square_12_12_0 (
//  .CLK(Clk),  // input wire CLK
//  .A(A),      // input wire [11 : 0] A
//  .B(B),      // input wire [11 : 0] B
//  .P(P)      // output wire [23 : 0] P
//);


//////////////////////////////////////////////////////////////////////////////
wire[AD_WIDTH-1:0]  Data_in1_1024r;
wire[AD_WIDTH-1:0]  Data_in2_1024r;
wire[AD_WIDTH-1:0]  Data_in3_1024r;
wire[AD_WIDTH-1:0]  Data_in4_1024r;

reg[AD_WIDTH-1:0]Data_in1_0dc = 0;
reg[AD_WIDTH-1:0]Data_in2_Avg = 0;



reg	[10:0]	Data_in_wraddress = 11'd0;
reg	[10:0]	Data_in_rdaddress = 11'd1024;

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_in_wraddress <= 11'b0;
	else
		Data_in_wraddress <= Data_in_wraddress + 11'b1;
end
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_in_rdaddress <= 11'd1024;
	else
		Data_in_rdaddress <= Data_in_wraddress - 11'd1023;
end

//RAM_dual_8096 RAM_dual_8096_1 (
//		.data      (Data_in1),      //  ram_input.datain
//		.wraddress (Data_in_wraddress), //           .wraddress
//		.rdaddress (Data_in_rdaddress), //           .rdaddress
//		.wren      (1'b1),      //           .wren
//		.clock     (Clk),     //           .clock
//		.rden      (1'b1),      //           .rden
//		.q         (Data_in1_1024r)          // ram_output.dataout
//);
//RAM_dual_8096 RAM_dual_8096_2 (
//		.data      (Data_in2),      //  ram_input.datain
//		.wraddress (Data_in_wraddress), //           .wraddress
//		.rdaddress (Data_in_rdaddress), //           .rdaddress
//		.wren      (1'b1),      //           .wren
//		.clock     (Clk),     //           .clock
//		.rden      (1'b1),      //           .rden
//		.q         (Data_in2_1024r)          // ram_output.dataout
//);
//RAM_dual_8096 RAM_dual_8096_3 (
//		.data      (Data_in3),      //  ram_input.datain
//		.wraddress (Data_in_wraddress), //           .wraddress
//		.rdaddress (Data_in_rdaddress), //           .rdaddress
//		.wren      (1'b1),      //           .wren
//		.clock     (Clk),     //           .clock
//		.rden      (1'b1),      //           .rden
//		.q         (Data_in3_1024r)          // ram_output.dataout
//);
//RAM_dual_8096 RAM_dual_8096_4 (
//		.data      (Data_in4),      //  ram_input.datain
//		.wraddress (Data_in_wraddress), //           .wraddress
//		.rdaddress (Data_in_rdaddress), //           .rdaddress
//		.wren      (1'b1),      //           .wren
//		.clock     (Clk),     //           .clock
//		.rden      (1'b1),      //           .rden
//		.q         (Data_in4_1024r)          // ram_output.dataout
//);

RAM_dual_8096 RAM_dual_8096_1  (
  .clka(Clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(Data_in_wraddress),  // input wire [10 : 0] addra
  .dina(Data_in1),    // input wire [11 : 0] dina
  .clkb(Clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(Data_in_rdaddress),  // input wire [10 : 0] addrb
  .doutb(Data_in1_1024r)  // output wire [11 : 0] doutb
);

RAM_dual_8096 RAM_dual_8096_2 (
  .clka(Clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(Data_in_wraddress),  // input wire [10 : 0] addra
  .dina(Data_in2),    // input wire [11 : 0] dina
  .clkb(Clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(Data_in_rdaddress),  // input wire [10 : 0] addrb
  .doutb(Data_in2_1024r)  // output wire [11 : 0] doutb
);

RAM_dual_8096 RAM_dual_8096_3 (
  .clka(Clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(Data_in_wraddress),  // input wire [10 : 0] addra
  .dina(Data_in3),    // input wire [11 : 0] dina
  .clkb(Clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(Data_in_rdaddress),  // input wire [10 : 0] addrb
  .doutb(Data_in3_1024r)  // output wire [11 : 0] doutb
);

RAM_dual_8096 RAM_dual_8096_4 (
  .clka(Clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(Data_in_wraddress),  // input wire [10 : 0] addra
  .dina(Data_in4),    // input wire [11 : 0] dina
  .clkb(Clk),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(Data_in_rdaddress),  // input wire [10 : 0] addrb
  .doutb(Data_in4_1024r)  // output wire [11 : 0] doutb
);




reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in12_add = 0;
reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in34_add = 0;
reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in1234_add = 0;
reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in12_add_1024r = 0;
reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in34_add_1024r = 0;
reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in1234_add_1024r = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
        Data_in12_add <= 'd0;
        Data_in34_add <= 'd0;
        Data_in1234_add <= 'd0;
        Data_in12_add_1024r <= 'd0;
        Data_in34_add_1024r <= 'd0;
        Data_in1234_add_1024r <= 'd0;
    end
	else begin 
        Data_in12_add <= {{LOG2_FFT_LEN{1'b0}},Data_in1} + {{LOG2_FFT_LEN{1'b0}},Data_in2};
        Data_in34_add <= {{LOG2_FFT_LEN{1'b0}},Data_in3} + {{LOG2_FFT_LEN{1'b0}},Data_in4};
        Data_in1234_add <= Data_in12_add + Data_in34_add;
        Data_in12_add_1024r <= {{LOG2_FFT_LEN{1'b0}},Data_in1_1024r} + {{LOG2_FFT_LEN{1'b0}},Data_in2_1024r};
        Data_in34_add_1024r <= {{LOG2_FFT_LEN{1'b0}},Data_in3_1024r} + {{LOG2_FFT_LEN{1'b0}},Data_in4_1024r};
        Data_in1234_add_1024r <= Data_in12_add_1024r + Data_in34_add_1024r;
    end
end

reg [AD_WIDTH+LOG2_FFT_LEN-1:0]	Data_in_Sum = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_in_Sum <= 'd0;
    end
	else begin 
		Data_in_Sum <= Data_in_Sum + Data_in1234_add - Data_in1234_add_1024r;
    end
end
always@(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Data_in_Avg <= 'd0;
	else
		Data_in_Avg <= Data_in_Sum[AD_WIDTH+LOG2_FFT_LEN-1:LOG2_FFT_LEN];
end

reg [AD_WIDTH-1:0] Data_out1_r1 = 0;
reg [AD_WIDTH-1:0] Data_out2_r1 = 0;
reg [AD_WIDTH-1:0] Data_out3_r1 = 0;
reg [AD_WIDTH-1:0] Data_out4_r1 = 0;
reg [AD_WIDTH-1:0] Data_out1_r2 = 0;
reg [AD_WIDTH-1:0] Data_out2_r2 = 0;
reg [AD_WIDTH-1:0] Data_out3_r2 = 0;
reg [AD_WIDTH-1:0] Data_out4_r2 = 0;
reg [AD_WIDTH-1:0] Data_out1_r3 = 0;
reg [AD_WIDTH-1:0] Data_out2_r3 = 0;
reg [AD_WIDTH-1:0] Data_out3_r3 = 0;
reg [AD_WIDTH-1:0] Data_out4_r3 = 0;
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_out1_r1 <= 'b0;
        Data_out2_r1 <= 'b0;
        Data_out3_r1 <= 'b0;
        Data_out4_r1 <= 'b0;
    end
	else begin 
		Data_out1_r1 <= Data_in1_1024r;
        Data_out2_r1 <= Data_in2_1024r;
        Data_out3_r1 <= Data_in3_1024r;
        Data_out4_r1 <= Data_in4_1024r;
    end
end
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_out1_r2 <= 'b0;
        Data_out2_r2 <= 'b0;
        Data_out3_r2 <= 'b0;
        Data_out4_r2 <= 'b0;
    end
	else begin 
		Data_out1_r2 <= Data_out1_r1;
        Data_out2_r2 <= Data_out2_r1;
        Data_out3_r2 <= Data_out3_r1;
        Data_out4_r2 <= Data_out4_r1;
    end
end
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_out1_r3 <= 'b0;
        Data_out2_r3 <= 'b0;
        Data_out3_r3 <= 'b0;
        Data_out4_r3 <= 'b0;
    end
	else begin 
		Data_out1_r3 <= Data_out1_r2;
        Data_out2_r3 <= Data_out2_r2;
        Data_out3_r3 <= Data_out3_r2;
        Data_out4_r3 <= Data_out4_r2;
    end
end
always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		Data_out1 <= 'b0;
        Data_out2 <= 'b0;
        Data_out3 <= 'b0;
        Data_out4 <= 'b0;
    end
	else begin 
		Data_out1 <= Data_out1_r3;
        Data_out2 <= Data_out2_r3;
        Data_out3 <= Data_out3_r3;
        Data_out4 <= Data_out4_r3;
    end
end



    
endmodule
