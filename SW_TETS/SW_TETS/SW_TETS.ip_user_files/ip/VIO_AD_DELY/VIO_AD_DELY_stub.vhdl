-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Wed Jun 18 15:13:26 2025
-- Host        : xie running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.runs/VIO_AD_DELY_synth_1/VIO_AD_DELY_stub.vhdl
-- Design      : VIO_AD_DELY
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbv484-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VIO_AD_DELY is
  Port ( 
    clk : in STD_LOGIC;
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 4 downto 0 )
  );

end VIO_AD_DELY;

architecture stub of VIO_AD_DELY is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_out0[0:0],probe_out1[4:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2023.2";
begin
end;
