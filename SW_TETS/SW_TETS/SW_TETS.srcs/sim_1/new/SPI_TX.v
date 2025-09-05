module	SPI_TX
#(
parameter   DATA_WITH = 32,
parameter	ST_NULL = 0,
parameter	ST_TAIL = DATA_WITH+5
)
(
input	wire                    fpga_sys_clk_i,		
input	wire                    fpga_sys_rst_i,		
input	wire                    tx_clock_i,		
input	wire                    sclk_free_state,	
input	wire                    spi_cs_i,		
output	wire                    spi_miso_o,	
//output	wire                    TxStaEn,		
input  wire    [(DATA_WITH-1):0]		data_tx_i		
		);


reg		[4:0]	STSta;	
reg		[(DATA_WITH+2):0] TxBuf;

always@(posedge fpga_sys_clk_i or negedge fpga_sys_rst_i)	begin
	if(!fpga_sys_rst_i)	
	   TxBuf = 0;
	else		begin
		TxBuf[DATA_WITH:1] = 	data_tx_i[(DATA_WITH-1):0];
		TxBuf[DATA_WITH+2]	=	1'bZ;
		TxBuf[DATA_WITH+1]	=	sclk_free_state;
		TxBuf[0]	=	sclk_free_state;
	end
end

wire	TxStaEn;
assign	TxStaEn = ~spi_cs_i;
always@(posedge tx_clock_i or negedge fpga_sys_rst_i)	begin
	if(!fpga_sys_rst_i)begin		
	 STSta = ST_NULL;
	 end
	else begin
		if(!TxStaEn)	
		      STSta = ST_NULL;
		if(STSta<ST_TAIL)	
		      STSta = STSta+1;
		else				
		      STSta = ST_NULL;
		end
end

assign	spi_miso_o =  (TxStaEn && (STSta<DATA_WITH+1) ) ? TxBuf[DATA_WITH-STSta]:1'bZ;    

endmodule