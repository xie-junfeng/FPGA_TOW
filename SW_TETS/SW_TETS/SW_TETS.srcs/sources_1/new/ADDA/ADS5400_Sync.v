module  ADS5400_Sync
(
	input					Clk,
	input					Resetn,
	input					ADS5400_ovr,

	output				    ADS_RESET_N,
	output				    ADS_RESET_P
);

// -----------------------------------------------------------------------
//* REG
reg			ADS5400_ovr1;
reg			ADS5400_ovr2;
reg			ADS5400_rst;
reg [10:0]	Cnt;
// -----------------------------------------------------------------------
always@( posedge Clk or negedge Resetn )
begin
	if(!Resetn)
       begin
		  ADS5400_ovr1 <= 1'b0;
		  ADS5400_ovr2 <= 1'b0;
       end   
	else 
       begin
		  ADS5400_ovr1 <= ADS5400_ovr;
		  ADS5400_ovr2 <= ADS5400_ovr1;
       end     
end

always@( posedge Clk or negedge Resetn )
begin
	if(!Resetn)
	   Cnt <= 11'd0;
    else if (Cnt >= 11'd2010)
       Cnt <= 11'd2010;
	else if (ADS5400_ovr2 == 1 && Cnt < 11'd2010)
	   Cnt <= Cnt + 8'd1;
	else
	   Cnt <= 11'd0;
end

always@( posedge Clk or negedge Resetn )
begin
	if(!Resetn)
		ADS5400_rst <= 1'd0;
	else if( Cnt >= 11'd2005 && Cnt <= 11'd2008 )
		ADS5400_rst <= 1'd1;
	else
		ADS5400_rst <= 1'd0;
end



     OBUFDS
   #(.IOSTANDARD ("LVDS_25"))
  obufds_inst0
    (.O          (ADS_RESET_P  ),
     .OB         (ADS_RESET_N  ),
     .I          (ADS5400_rst ));




endmodule
