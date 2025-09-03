module W32T8
#(parameter count1=4,
  parameter A_WIDTH1=32,
  parameter B_WIDTH1=8  
)
(
input                 clk , 
input                 rst_n ,

input                 valid_in ,
input [A_WIDTH1-1:0]  data_in ,

output       reg      clk_out_fifo, 
output reg            valid_out ,
output wire          [B_WIDTH1-1:0] data_out
);
reg [7:0] cnt;
reg [7:0] cnt1;
reg [9:0] cnt2;
reg [B_WIDTH1-1:0] data_out_r;

always @ (posedge clk or negedge rst_n) 
begin
 if( ~rst_n ) begin
 cnt <= 4'd0;
 end
 else begin
 if( valid_in ) begin
    if(cnt==(count1-4'd1))
        cnt <= 4'd0;
    else
        cnt <= cnt + 4'd1;
 end
 end
end

always @ (posedge clk or negedge rst_n) 
begin
 if( ~rst_n ) begin
 cnt1 <= 4'd0;
 end
 else begin
    if(cnt1==(count1-4'd1))
        cnt1 <= 4'd0;
    else
        cnt1 <= cnt1 + 4'd1;
 end
 end

always @ (posedge clk or negedge rst_n) 
begin
 if( ~rst_n ) begin
 clk_out_fifo <= 1'b0;
 end
 else begin
 case(cnt1)
 4'd0 : begin
 clk_out_fifo <= 1'b1;
 end
 4'd1 : begin
 clk_out_fifo <= 1'b1;
 end
 4'd2 : begin
clk_out_fifo <= 1'b0;
 end
 4'd3 : begin 
 clk_out_fifo <= 1'b0;
end
endcase
end
end

always @ (posedge clk or negedge rst_n) 
begin
 if( ~rst_n ) begin
 valid_out <= 1'b0;
 data_out_r <= 8'b0;
 cnt2<= 0;
 end
 else begin
 if(valid_in) begin
 case(cnt)
 4'd0 : begin
 cnt2<=cnt2+1'd1;
 data_out_r <= data_in[31:24];
 valid_out <= 1'b1;
 end
 4'd1 : begin
  cnt2<=cnt2+1'd1;
data_out_r <= data_in[23:16];
 valid_out <= 1'b1;
 end
 4'd2 : begin
  cnt2<=cnt2+1'd1;
data_out_r <= data_in[15:8];
 valid_out <= 1'b1;
 end
 4'd3 : begin 
  cnt2<=cnt2+1'd1;
 data_out_r <= data_in[7:0];
 valid_out <= 1'b1;
 end
 endcase
 end
 else begin
 valid_out <= 1'b0;
end
end
end
assign data_out=data_out_r;
endmodule