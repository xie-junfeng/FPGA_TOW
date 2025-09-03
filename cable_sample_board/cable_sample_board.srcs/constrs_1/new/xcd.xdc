#ϵͳ
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U18} [get_ports sys_clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N16} [get_ports rst_n]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y12} [get_ports {da_write_data[7]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y13} [get_ports {da_write_data[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V10} [get_ports {da_write_data[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V11} [get_ports {da_write_data[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W9} [get_ports {da_write_data[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W10} [get_ports {da_write_data[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y8} [get_ports {da_write_data[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y9} [get_ports {da_write_data[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y11} [get_ports da_write_clk]


#earth
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports eth_rst_n]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports eth_read_clk]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports eth_read_valid]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {eth_read_data_4[0]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {eth_read_data_4[1]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {eth_read_data_4[2]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {eth_read_data_4[3]}]

set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports eth_write_clk]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports eth_write_valid]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {eth_write_data_4[0]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {eth_write_data_4[1]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {eth_write_data_4[2]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {eth_write_data_4[3]}]

#ad
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W16} [get_ports {ad0_write_data[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T15} [get_ports {ad0_write_data[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y16} [get_ports {ad0_write_data[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U17} [get_ports {ad0_write_data[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V18} [get_ports {ad0_write_data[8]}]

#set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R18} [get_ports ad0_write_oe]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y19} [get_ports ad0_write_clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V16} [get_ports {ad0_write_data[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T14} [get_ports {ad0_write_data[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN Y17} [get_ports {ad0_write_data[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T16} [get_ports {ad0_write_data[7]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V17} [get_ports {ad0_write_data[9]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T17} [get_ports ad0_write_oe]

#ad_data1
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P16} [get_ports {ad1_write_data[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W19} [get_ports {ad1_write_data[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R17} [get_ports {ad1_write_data[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V20} [get_ports {ad1_write_data[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N17} [get_ports {ad1_write_data[8]}]

#set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N18} [get_ports ad1_write_oe]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U20} [get_ports ad1_write_clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P15} [get_ports {ad1_write_data[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W18} [get_ports {ad1_write_data[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R16} [get_ports {ad1_write_data[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN W20} [get_ports {ad1_write_data[7]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P18} [get_ports {ad1_write_data[9]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P19} [get_ports ad1_write_oe]
