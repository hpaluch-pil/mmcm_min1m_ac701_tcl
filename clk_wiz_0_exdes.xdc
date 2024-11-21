# file: clk_wiz_0_exdes.xdc
# 
# (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
# 
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
# 
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
# 
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
# 
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
# 

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Input clock periods. These duplicate the values entered for the
#  input clocks. You can use these to time your system
#----------------------------------------------------------------
## Clock signal 200 Mhz diff, U51 SIT9102
set_property -dict { PACKAGE_PIN R3 IOSTANDARD DIFF_SSTL15 } [get_ports sys_clk_p]
set_property -dict { PACKAGE_PIN P3 IOSTANDARD DIFF_SSTL15 } [get_ports sys_clk_n]
create_clock -name clk_p -period 5.0 [get_nets sys_clk_p]

# workaround to avoid TPSW violation
# from: https://adaptivesupport.amd.com/s/question/0D54U00008qlAmRSAU/mmcm-clkout4cascade-works-for-1-mhz-output-but-with-tpws-violation?language=en_US
set_property CLKOUT4_CASCADE TRUE [get_cells clk_wiz_inst1/clknetwork/inst/mmcm_adv_inst]

## SW8 "CPU Reset" button, Active High, Idle Low
## from ac701_ethernet\ac701_ethernet_rgmii_example\ac701_ethernet_rgmii_example.srcs\constrs_1\imports\example_design\ac701_ethernet_rgmii_example_design.xdc 
set_property PACKAGE_PIN U4           [get_ports glbl_rst]
set_property IOSTANDARD  SSTL15       [get_ports glbl_rst]
set_false_path -from [get_ports glbl_rst]

## J48 connector Pin1
set_property PACKAGE_PIN P26 [get_ports {pmod[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod[0]}]
## J48 connector Pin2
set_property PACKAGE_PIN T22 [get_ports {pmod[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod[1]}]
## R22 connector Pin3
set_property PACKAGE_PIN R22 [get_ports {pmod[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod[2]}]
## T23 connector Pin4
set_property PACKAGE_PIN T23 [get_ports {pmod[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod[3]}]

# Bank: 33 - GPIO_LED_0_LS
set_property DRIVE 12 [get_ports {led[0]}]
set_property SLEW SLOW [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property LOC M26 [get_ports {led[0]}]
# Bank: 33 - GPIO_LED_1_LS
set_property DRIVE 12 [get_ports {led[1]}]
set_property SLEW SLOW [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property LOC T24 [get_ports {led[1]}]
# Bank: 33 - GPIO_LED_2_LS
set_property DRIVE 12 [get_ports {led[2]}]
set_property SLEW SLOW [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property LOC T25 [get_ports {led[2]}]
# Bank: 33 - GPIO_LED_3_LS
set_property DRIVE 12 [get_ports {led[3]}]
set_property SLEW SLOW [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property LOC R26 [get_ports {led[3]}]

# lines below required for SPI flash programming
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.config.SPI_opcode 0x6B [current_design ]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]