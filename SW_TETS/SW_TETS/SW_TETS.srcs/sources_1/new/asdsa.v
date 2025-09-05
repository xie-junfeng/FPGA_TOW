module DSA_ARW637_SER
(
input	clk, //  50MHz
input	rst_n,
input	start_tx,
input [6:0]	atten,

output reg	End_Config,
output reg	SPI_LE,
output reg	SPI_CLK,
output reg	SPI_SERNIN
);

reg	Config_flag;
reg [2:0]	clk_div;  //    50MHz/4
reg [5:0]	bit_cnt;

// ================================================================
always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
Config_flag <= 1'd0;
else if(bit_cnt >= 6'd60)
Config_flag <= 1'd0;
else if(start_tx)
Config_flag <= 1'd1;
else
Config_flag <= Config_flag;
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
clk_div <= 3'd0;
else if(Config_flag == 1'b1)
clk_div <= clk_div + 3'd1;
else
clk_div <= 3'd0;
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
bit_cnt <= 6'd0;
else if(Config_flag == 1'd1)
begin
if(clk_div == 3'd1)
bit_cnt <= bit_cnt + 6'd1;
else
bit_cnt <= bit_cnt;
end
else
bit_cnt <= 6'd0;
end    

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
SPI_SERNIN <= 1'b0;
else
case (bit_cnt)
6'd1: SPI_SERNIN <= atten[0];
6'd2: SPI_SERNIN <= atten[1];
6'd3: SPI_SERNIN <= atten[2];
6'd4: SPI_SERNIN <= atten[3];
6'd5: SPI_SERNIN <= atten[4];
6'd6: SPI_SERNIN <= atten[5];
6'd7: SPI_SERNIN <= atten[6];
6'd8: SPI_SERNIN <= 1'b0;
default: SPI_SERNIN<= SPI_SERNIN;
endcase
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
SPI_CLK <= 1'b0;
else if(bit_cnt >= 24'd1 && bit_cnt <= 24'd8)
begin
if (clk_div >= 6'd2 && clk_div <= 6'd5)
SPI_CLK <= 1'b0;
else
SPI_CLK <= 1'b1;
end
else 
SPI_CLK <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
SPI_LE <= 1'b0;
else if(bit_cnt == 6'd10)
SPI_LE <= 1'b1;
else 
SPI_LE <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
End_Config <= 1'd0;
else if(bit_cnt == 6'd59)
End_Config <= 1'd1;
else
End_Config <= 1'd0;	
end
endmodule