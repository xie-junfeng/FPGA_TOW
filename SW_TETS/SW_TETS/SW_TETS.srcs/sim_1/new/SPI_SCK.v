module	SPI_SCK
(
input	wire	    fpga_sys_clk_i,		
input	wire	    fpga_sys_rst_i,		
		
input	wire   	    spi_sclk_i,		
input	wire [1:0]	SPI_MODE,	
input	wire 	    tx_en_i,
			 
output	wire	     tx_clock_o,
output	wire	     rx_clock_o,
		
output reg          sclk_free_state		
		);
		
parameter DATA_WITH = 32;
parameter ST_TAIL = DATA_WITH+5;

reg 	SCKBUF[1:0];
reg		SCK_PHA;
always	@(posedge fpga_sys_clk_i or negedge fpga_sys_rst_i)begin
	if(!fpga_sys_rst_i)	begin	
	   sclk_free_state<=0;	
	   SCK_PHA<=0; 
	end
	else begin
		case(SPI_MODE)
		0:begin	sclk_free_state<=0;	SCK_PHA<=0; end
		1:begin	sclk_free_state<=0;	SCK_PHA<=1; end
		2:begin	sclk_free_state<=1;	SCK_PHA<=0; end
		3:begin	sclk_free_state<=1;	SCK_PHA<=1; end
		endcase
	end
end

always@(posedge fpga_sys_clk_i )begin
		SCKBUF[0] <= spi_sclk_i;
		SCKBUF[1] <= SCKBUF[0];		
end

wire	nSCK,pSCK;
assign 	nSCK = (~SCKBUF[0] & SCKBUF[1])? 1'b1:1'b0;
assign 	pSCK = (~SCKBUF[1] & SCKBUF[0])? 1'b1:1'b0;


reg		[4:0]	TxSckCnt;
reg		TxEnable;	
always@(posedge fpga_sys_clk_i or negedge fpga_sys_rst_i)begin
	if(!fpga_sys_rst_i)	TxEnable <= 0;
	else	begin
			if(tx_en_i)				
			     TxEnable <= 1;
			if(TxSckCnt==ST_TAIL)	
			     TxEnable <= 0;
	end
end

always@(posedge spi_sclk_i or negedge fpga_sys_rst_i)begin
	if(!fpga_sys_rst_i)	begin
			TxSckCnt <= 0;
	end
	else	begin
			if(TxEnable)	
			     TxSckCnt <= TxSckCnt+1;
			else			
			     TxSckCnt <= 0;
	end
end

assign	tx_clock_o = (TxEnable && (SPI_MODE==0))? pSCK:1'bz;
assign	tx_clock_o = (TxEnable && (SPI_MODE==1))? nSCK:1'bz;
assign	tx_clock_o = (TxEnable && (SPI_MODE==2))? nSCK:1'bz;
assign	tx_clock_o = (TxEnable && (SPI_MODE==3))? pSCK:1'bz;
assign	tx_clock_o = (!TxEnable)? sclk_free_state:1'bz;

assign  rx_clock_o = (SPI_MODE==0)? pSCK:1'bz;
assign  rx_clock_o = (SPI_MODE==1)? nSCK:1'bz;
assign  rx_clock_o = (SPI_MODE==2)? nSCK:1'bz;
assign  rx_clock_o = (SPI_MODE==3)? pSCK:1'bz;

endmodule