module SPI_RX
#(
parameter DATA_WITH = 32
)
(
input   wire               fpga_sys_clk_i, 
input   wire               fpga_sys_rst_i,
   
input   wire               spi_cs_i,  

input   wire               rx_clock_i, 
input   wire               spi_mosi_i,

output reg [(DATA_WITH-1):0]   data_rx_o,
output reg                    rx_en_o
);
	


reg [4:0] RxSta;		
reg [(DATA_WITH-1):0] RxBuf;

always@(posedge fpga_sys_clk_i or negedge fpga_sys_rst_i)	begin
	if(!fpga_sys_rst_i)	begin
		data_rx_o <= 0;
		rx_en_o    <= 0;
	end
	else begin
		if(RxSta == 4'd0)begin	
		data_rx_o <= RxBuf;
		 rx_en_o  <= 1'd1;
		 end
		 else begin
		 rx_en_o    <= 1'd0;
		 end
	end
end

always@(posedge rx_clock_i or negedge fpga_sys_rst_i)	begin
	if(!fpga_sys_rst_i)	begin
		RxBuf <= 0;	
		RxSta <= 0;
	end
	else begin
		RxBuf[0] <= spi_mosi_i;
		RxBuf[(DATA_WITH-1):1] <= RxBuf[(DATA_WITH-2):0];
		if(RxSta<(DATA_WITH-1)) begin	
		  RxSta <= RxSta+1;
		  end
		else begin
		  RxSta <= 0;
		  end
	end
end

endmodule