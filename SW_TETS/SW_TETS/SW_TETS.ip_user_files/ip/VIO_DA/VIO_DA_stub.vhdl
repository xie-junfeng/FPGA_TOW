-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Wed Jun 18 15:13:31 2025
-- Host        : xie running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/VIO_DA/VIO_DA_stub.vhdl
-- Design      : VIO_DA
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbv484-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VIO_DA is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in7 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );

end VIO_DA;

architecture stub of VIO_DA is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[3:0],probe_in1[7:0],probe_in2[7:0],probe_in3[7:0],probe_in4[7:0],probe_in5[7:0],probe_in6[7:0],probe_in7[7:0],probe_in8[0:0],probe_out0[0:0],probe_out1[0:0],probe_out2[0:0],probe_out3[0:0],probe_out4[4:0],probe_out5[0:0],probe_out6[6:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2023.2";
begin
end;
