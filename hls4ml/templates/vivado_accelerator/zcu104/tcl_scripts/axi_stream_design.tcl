#@todo: try to remove startgroup and endgroup and see if it work
set tcldir [file dirname [info script]]
source [file join $tcldir project.tcl]

create_project project_1 ${myproject}_vivado_accelerator -part xczu7ev-ffvc1156-2-e -force

set_property board_part xilinx.com:zcu104:part0:1.1 [current_project]
set_property  ip_repo_paths  ${myproject}_prj [current_project]
update_ip_catalog

create_bd_design "design_1"
current_bd_design "design_1"
set_property  ip_repo_paths ${myproject}_prj/solution1/impl/ip [current_project]
update_ip_catalog

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]

set_property -dict [list CONFIG.PSU__USE__S_AXI_GP0 {1} CONFIG.PSU__SAXIGP0__DATA_WIDTH {32} CONFIG.PSU__GPIO_EMIO_WIDTH {16} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {16} ] [get_bd_cells zynq_ultra_ps_e_0]

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
endgroup
set_property -dict [list CONFIG.c_m_axi_s2mm_data_width.VALUE_SRC USER CONFIG.c_s_axis_s2mm_tdata_width.VALUE_SRC USER] [get_bd_cells axi_dma_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {26} CONFIG.c_sg_include_stscntrl_strm {0} CONFIG.c_m_axi_mm2s_data_width ${bit_width_hls_input} CONFIG.c_m_axis_mm2s_tdata_width ${bit_width_hls_input} CONFIG.c_mm2s_burst_size {256} CONFIG.c_m_axi_s2mm_data_width ${bit_width_hls_output} CONFIG.c_s_axis_s2mm_tdata_width ${bit_width_hls_output} CONFIG.c_s2mm_burst_size {256}] [get_bd_cells axi_dma_0]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_dma_0/S_AXI_LITE} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/axi_dma_0/M_AXI_MM2S} Slave {/zynq_ultra_ps_e_0/S_AXI_HPC0_FPD} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
endgroup

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Master {/axi_dma_0/M_AXI_S2MM} Slave {/zynq_ultra_ps_e_0/S_AXI_HPC0_FPD} ddr_seg {Auto} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} Slave {/axi_dma_0/S_AXI_LITE} ddr_seg {Auto} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 
endgroup
set_property -dict [list CONFIG.DIN_FROM {1} CONFIG.DIN_TO {0} CONFIG.DIN_WIDTH {16} CONFIG.DOUT_WIDTH {2} ] [get_bd_cells xlslice_0]

startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:${myproject}_axi:1.0 ${myproject}_axi_0
endgroup

startgroup
create_bd_port -dir O -from 1 -to 0 LED
endgroup

connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins ${myproject}_axi_0/in_r]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins ${myproject}_axi_0/out_r]
connect_bd_net -net xlslice_0_Dout [get_bd_ports LED] [get_bd_pins xlslice_0/Dout]
connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins xlslice_0/Din] [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o]

apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins ${myproject}_axi_0/ap_clk]
group_bd_cells hier_0 [get_bd_cells axi_dma_0] [get_bd_cells ${myproject}_axi_0]

read_xdc trigger.xdc

make_wrapper -files [get_files ./${myproject}_vivado_accelerator/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top

add_files -norecurse ./${myproject}_vivado_accelerator/project_1.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v

reset_run impl_1
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run -timeout 360 impl_1

open_run impl_1
report_utilization -file util.rpt -hierarchical -hierarchical_percentages
