-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Wed Jan  8 13:58:50 2025
-- Host        : DESKTOP-VP1BO8E running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/fpga_interface/test/UART/UART_MASTER_V0_1/UART_MASTER_V0_1/UART_INTERFACE.srcs/sources_1/ip/vio_start/vio_start_stub.vhdl
-- Design      : vio_start
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_start is
  Port ( 
    clk : in STD_LOGIC;
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_start;

architecture stub of vio_start is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_out0[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.1";
begin
end;
