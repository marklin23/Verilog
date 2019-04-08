create_clock -name OSC_148M5 -period 6.734 [get_ports {OSC_148M5}]

create_clock -name PIXCLK -period 13.468 [get_ports {PIX_CLK}]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty

#output max delay  = ddmax + tsu_ext + (cd_altr_max - cd_ext_min)

#output min delay  = ddmin - th_ext  + (cd_altr_min - cd_ext_max)

#input max delay  = ddmax + tco_ext_max + (cd_ext_max - cd_altr_min)
#input min delay  = ddmin + tco_ext_min + (cd_ext_min - cd_altr_max)

#create virtual clock for input constraint
#create_clock -name clk_v_in;

#create virtual clock for output constraint
#create_clock -name clk_v_out;
 

#set_output_delay -max [expr 1 + 2 +( 0.5)] -clock [get_clocks output_clock][get_ports VIDEO_OUT_VS VIDEO_OUT_HS VIDEO_OUT_DE VIDEO_OUT_R VIDEO_OUT_G VIDEO_OUT_B]
#set_output_delay -min [expr 1 - 1 +(-0.5)] -clock [get_clocks output_clock][get_ports VIDEO_OUT_VS VIDEO_OUT_HS VIDEO_OUT_DE VIDEO_OUT_R VIDEO_OUT_G VIDEO_OUT_B]

#---------------------------------------------------------------------------------------------
#  original sdc io constrain
#---------------------------------------------------------------------------------------------

#create_generated_clock -name VIDEO_OUT_CLK -source [get_ports {PIX_CLK}] [get_ports {VIDEO_OUT_CLK}]
#
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_HS]
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_VS]
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_DE]
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_R[*]]
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_G[*]]
#set_output_delay -clock { VIDEO_OUT_CLK } -max 3.0  [get_ports VIDEO_OUT_B[*]]
#
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_HS]
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_VS]
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_DE]
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_R[*]]
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_G[*]]
#set_output_delay -clock { VIDEO_OUT_CLK } -min 0.5  [get_ports VIDEO_OUT_B[*]]
#
#set_input_delay -clock { PIX_CLK } -max 2.0 [get_ports {PIX_DATA*}]
#set_input_delay -clock { PIX_CLK } -min 0.2 [get_ports {PIX_DATA*}]
#set_input_delay -clock { PIX_CLK } -max 2.0 [get_ports {PIX_LV}]
#set_input_delay -clock { PIX_CLK } -min 0.2 [get_ports {PIX_LV}]
#set_input_delay -clock { PIX_CLK } -max 2.0 [get_ports {PIX_FV}]
#set_input_delay -clock { PIX_CLK } -min 0.2 [get_ports {PIX_FV}]

#---------------------------------------------------------------------------------------------
#  altera recommand sdc io constrain
#---------------------------------------------------------------------------------------------
 create_clock -name clk_v_in -period 13.468;
 create_clock -name clk_v_out -period 13.468;
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_HS]
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_VS]
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_DE]
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_R[*]]
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_G[*]]
 set_output_delay -clock { get_clocks clk_v_out } -max 3.0  [get_ports VIDEO_OUT_B[*]]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_HS]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_VS]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_DE]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_R[*]]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_G[*]]
 set_output_delay -clock { get_clocks clk_v_out } -min 0.5  [get_ports VIDEO_OUT_B[*]]
 set_input_delay -clock { get_clocks clk_v_in } -max 2.0 [get_ports {PIX_DATA*}]
 set_input_delay -clock { get_clocks clk_v_in } -min 0.2 [get_ports {PIX_DATA*}]
 set_input_delay -clock { get_clocks clk_v_in } -max 2.0 [get_ports {PIX_LV}]
 set_input_delay -clock { get_clocks clk_v_in } -min 0.2 [get_ports {PIX_LV}]
 set_input_delay -clock { get_clocks clk_v_in } -max 2.0 [get_ports {PIX_FV}]
 set_input_delay -clock { get_clocks clk_v_in } -min 0.2 [get_ports {PIX_FV}]


 
 
 