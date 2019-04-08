
# (C) 2001-2019 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ----------------------------------------
# Auto-generated simulation script msim_setup.tcl
# ----------------------------------------
# This script provides commands to simulate the following IP detected in
# your Quartus project:
#     pattern_gen
# 
# Altera recommends that you source this Quartus-generated IP simulation
# script from your own customized top-level script, and avoid editing this
# generated script.
# 
# To write a top-level script that compiles Altera simulation libraries and
# the Quartus-generated IP in your project, along with your design and
# testbench files, copy the text from the TOP-LEVEL TEMPLATE section below
# into a new file, e.g. named "mentor.do", and modify the text as directed.
# 
# ----------------------------------------
# # TOP-LEVEL TEMPLATE - BEGIN
# #
# # QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# # construct paths to the files required to simulate the IP in your Quartus
# # project. By default, the IP script assumes that you are launching the
# # simulator from the IP script location. If launching from another
# # location, set QSYS_SIMDIR to the output directory you specified when you
# # generated the IP script, relative to the directory from which you launch
# # the simulator.
# #
# set QSYS_SIMDIR <script generation output directory>
# #
# # Source the generated IP simulation script.
# source $QSYS_SIMDIR/mentor/msim_setup.tcl
# #
# # Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# #
# # Call command to compile the Quartus EDA simulation library.
# dev_com
# #
# # Call command to compile the Quartus-generated IP simulation files.
# com
# #
# # Add commands to compile all design files and testbench files, including
# # the top level. (These are all the files required for simulation other
# # than the files compiled by the Quartus-generated IP simulation script)
# #
# vlog <compilation options> <design and testbench files>
# #
# # Set the top-level simulation or testbench module/entity name, which is
# # used by the elab command to elaborate the top level.
# #
# set TOP_LEVEL_NAME <simulation top>
# #
# # Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
# #
# # Call command to elaborate your design and testbench.
# elab
# #
# # Run the simulation.
# run -a
# #
# # Report success to the shell.
# exit -code 0
# #
# # TOP-LEVEL TEMPLATE - END
# ----------------------------------------
# 
# IP SIMULATION SCRIPT
# ----------------------------------------
# If pattern_gen is one of several IP cores in your
# Quartus project, you can generate a simulation script
# suitable for inclusion in your top-level simulation
# script by running the following command line:
# 
# ip-setup-simulation --quartus-project=<quartus project>
# 
# ip-setup-simulation will discover the Altera IP
# within the Quartus project, and generate a unified
# script which supports all the Altera IP within the design.
# ----------------------------------------
# ACDS 16.1 196 win32 2019.04.03.15:39:07

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "pattern_gen"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/intelfpga_lite/16.1/quartus/"
}

if ![info exists USER_DEFINED_COMPILE_OPTIONS] { 
  set USER_DEFINED_COMPILE_OPTIONS ""
}
if ![info exists USER_DEFINED_ELAB_OPTIONS] { 
  set USER_DEFINED_ELAB_OPTIONS ""
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                       ./libraries/altera_ver/           
  vmap       altera_ver            ./libraries/altera_ver/           
  ensure_lib                       ./libraries/lpm_ver/              
  vmap       lpm_ver               ./libraries/lpm_ver/              
  ensure_lib                       ./libraries/sgate_ver/            
  vmap       sgate_ver             ./libraries/sgate_ver/            
  ensure_lib                       ./libraries/altera_mf_ver/        
  vmap       altera_mf_ver         ./libraries/altera_mf_ver/        
  ensure_lib                       ./libraries/altera_lnsim_ver/     
  vmap       altera_lnsim_ver      ./libraries/altera_lnsim_ver/     
  ensure_lib                       ./libraries/cyclonev_ver/         
  vmap       cyclonev_ver          ./libraries/cyclonev_ver/         
  ensure_lib                       ./libraries/cyclonev_hssi_ver/    
  vmap       cyclonev_hssi_ver     ./libraries/cyclonev_hssi_ver/    
  ensure_lib                       ./libraries/cyclonev_pcie_hip_ver/
  vmap       cyclonev_pcie_hip_ver ./libraries/cyclonev_pcie_hip_ver/
}
ensure_lib                                        ./libraries/altera_common_sv_packages/             
vmap       altera_common_sv_packages              ./libraries/altera_common_sv_packages/             
ensure_lib                                        ./libraries/error_adapter_0/                       
vmap       error_adapter_0                        ./libraries/error_adapter_0/                       
ensure_lib                                        ./libraries/avalon_st_adapter/                     
vmap       avalon_st_adapter                      ./libraries/avalon_st_adapter/                     
ensure_lib                                        ./libraries/rsp_mux/                               
vmap       rsp_mux                                ./libraries/rsp_mux/                               
ensure_lib                                        ./libraries/rsp_demux/                             
vmap       rsp_demux                              ./libraries/rsp_demux/                             
ensure_lib                                        ./libraries/cmd_mux/                               
vmap       cmd_mux                                ./libraries/cmd_mux/                               
ensure_lib                                        ./libraries/cmd_demux/                             
vmap       cmd_demux                              ./libraries/cmd_demux/                             
ensure_lib                                        ./libraries/alt_vip_cl_cvo_0_control_burst_adapter/
vmap       alt_vip_cl_cvo_0_control_burst_adapter ./libraries/alt_vip_cl_cvo_0_control_burst_adapter/
ensure_lib                                        ./libraries/mm_master_bfm_0_m0_limiter/            
vmap       mm_master_bfm_0_m0_limiter             ./libraries/mm_master_bfm_0_m0_limiter/            
ensure_lib                                        ./libraries/router_002/                            
vmap       router_002                             ./libraries/router_002/                            
ensure_lib                                        ./libraries/router/                                
vmap       router                                 ./libraries/router/                                
ensure_lib                                        ./libraries/alt_vip_cl_cvo_0_control_agent/        
vmap       alt_vip_cl_cvo_0_control_agent         ./libraries/alt_vip_cl_cvo_0_control_agent/        
ensure_lib                                        ./libraries/mm_master_bfm_0_m0_agent/              
vmap       mm_master_bfm_0_m0_agent               ./libraries/mm_master_bfm_0_m0_agent/              
ensure_lib                                        ./libraries/alt_vip_cl_cvo_0_control_translator/   
vmap       alt_vip_cl_cvo_0_control_translator    ./libraries/alt_vip_cl_cvo_0_control_translator/   
ensure_lib                                        ./libraries/mm_master_bfm_0_m0_translator/         
vmap       mm_master_bfm_0_m0_translator          ./libraries/mm_master_bfm_0_m0_translator/         
ensure_lib                                        ./libraries/p2b_adapter/                           
vmap       p2b_adapter                            ./libraries/p2b_adapter/                           
ensure_lib                                        ./libraries/b2p_adapter/                           
vmap       b2p_adapter                            ./libraries/b2p_adapter/                           
ensure_lib                                        ./libraries/transacto/                             
vmap       transacto                              ./libraries/transacto/                             
ensure_lib                                        ./libraries/p2b/                                   
vmap       p2b                                    ./libraries/p2b/                                   
ensure_lib                                        ./libraries/b2p/                                   
vmap       b2p                                    ./libraries/b2p/                                   
ensure_lib                                        ./libraries/fifo/                                  
vmap       fifo                                   ./libraries/fifo/                                  
ensure_lib                                        ./libraries/timing_adt/                            
vmap       timing_adt                             ./libraries/timing_adt/                            
ensure_lib                                        ./libraries/jtag_phy_embedded_in_jtag_master/      
vmap       jtag_phy_embedded_in_jtag_master       ./libraries/jtag_phy_embedded_in_jtag_master/      
ensure_lib                                        ./libraries/scheduler/                             
vmap       scheduler                              ./libraries/scheduler/                             
ensure_lib                                        ./libraries/tpg_core/                              
vmap       tpg_core                               ./libraries/tpg_core/                              
ensure_lib                                        ./libraries/output_mux/                            
vmap       output_mux                             ./libraries/output_mux/                            
ensure_lib                                        ./libraries/seq_to_par_0/                          
vmap       seq_to_par_0                           ./libraries/seq_to_par_0/                          
ensure_lib                                        ./libraries/scaler_core_0/                         
vmap       scaler_core_0                          ./libraries/scaler_core_0/                         
ensure_lib                                        ./libraries/line_buffer_0/                         
vmap       line_buffer_0                          ./libraries/line_buffer_0/                         
ensure_lib                                        ./libraries/input_demux/                           
vmap       input_demux                            ./libraries/input_demux/                           
ensure_lib                                        ./libraries/video_in_cmd/                          
vmap       video_in_cmd                           ./libraries/video_in_cmd/                          
ensure_lib                                        ./libraries/kernel_creator/                        
vmap       kernel_creator                         ./libraries/kernel_creator/                        
ensure_lib                                        ./libraries/video_out/                             
vmap       video_out                              ./libraries/video_out/                             
ensure_lib                                        ./libraries/video_in_resp/                         
vmap       video_in_resp                          ./libraries/video_in_resp/                         
ensure_lib                                        ./libraries/control/                               
vmap       control                                ./libraries/control/                               
ensure_lib                                        ./libraries/cvo_core/                              
vmap       cvo_core                               ./libraries/cvo_core/                              
ensure_lib                                        ./libraries/sop_align/                             
vmap       sop_align                              ./libraries/sop_align/                             
ensure_lib                                        ./libraries/video_in/                              
vmap       video_in                               ./libraries/video_in/                              
ensure_lib                                        ./libraries/rst_controller/                        
vmap       rst_controller                         ./libraries/rst_controller/                        
ensure_lib                                        ./libraries/mm_interconnect_0/                     
vmap       mm_interconnect_0                      ./libraries/mm_interconnect_0/                     
ensure_lib                                        ./libraries/mm_master_bfm_0/                       
vmap       mm_master_bfm_0                        ./libraries/mm_master_bfm_0/                       
ensure_lib                                        ./libraries/master_0/                              
vmap       master_0                               ./libraries/master_0/                              
ensure_lib                                        ./libraries/alt_vip_cl_tpg_0/                      
vmap       alt_vip_cl_tpg_0                       ./libraries/alt_vip_cl_tpg_0/                      
ensure_lib                                        ./libraries/alt_vip_cl_scl_0/                      
vmap       alt_vip_cl_scl_0                       ./libraries/alt_vip_cl_scl_0/                      
ensure_lib                                        ./libraries/alt_vip_cl_cvo_0/                      
vmap       alt_vip_cl_cvo_0                       ./libraries/alt_vip_cl_cvo_0/                      

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                     -work altera_ver           
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                              -work lpm_ver              
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                 -work sgate_ver            
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                             -work altera_mf_ver        
    eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                         -work altera_lnsim_ver     
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                        -work cyclonev_ver         
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                   -work cyclonev_hssi_ver    
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
    eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"               -work cyclonev_pcie_hip_ver
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/common/alt_vip_common_pkg.sv"                                                                                             -work altera_common_sv_packages             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                                                                                                                -work altera_common_sv_packages             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                                                                                                                -work altera_common_sv_packages             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/avalon_utilities_pkg.sv"                                                                                                         -work altera_common_sv_packages             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv"                                 -L altera_common_sv_packages -work error_adapter_0                       
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_avalon_st_adapter.v"                                                                               -work avalon_st_adapter                     
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_rsp_mux.sv"                                                           -L altera_common_sv_packages -work rsp_mux                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                        -L altera_common_sv_packages -work rsp_mux                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_rsp_demux.sv"                                                         -L altera_common_sv_packages -work rsp_demux                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_cmd_mux.sv"                                                           -L altera_common_sv_packages -work cmd_mux                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                                                        -L altera_common_sv_packages -work cmd_mux                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_cmd_demux.sv"                                                         -L altera_common_sv_packages -work cmd_demux                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                                                                     -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_uncmpr.sv"                                                              -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_13_1.sv"                                                                -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_new.sv"                                                                 -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_incr_burst_converter.sv"                                                                     -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_wrap_burst_converter.sv"                                                                     -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_default_burst_converter.sv"                                                                  -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                                                 -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv"                                                                 -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                                   -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_burst_adapter
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                                                                   -L altera_common_sv_packages -work mm_master_bfm_0_m0_limiter            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv"                                                                    -L altera_common_sv_packages -work mm_master_bfm_0_m0_limiter            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                            -L altera_common_sv_packages -work mm_master_bfm_0_m0_limiter            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                                   -L altera_common_sv_packages -work mm_master_bfm_0_m0_limiter            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_router_002.sv"                                                        -L altera_common_sv_packages -work router_002                            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0_router.sv"                                                            -L altera_common_sv_packages -work router                                
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                                                       -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_agent        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                                                -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_agent        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                                                      -L altera_common_sv_packages -work mm_master_bfm_0_m0_agent              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                                                  -L altera_common_sv_packages -work alt_vip_cl_cvo_0_control_translator   
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                                                 -L altera_common_sv_packages -work mm_master_bfm_0_m0_translator         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_master_0_p2b_adapter.sv"                                                                -L altera_common_sv_packages -work p2b_adapter                           
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_master_0_b2p_adapter.sv"                                                                -L altera_common_sv_packages -work b2p_adapter                           
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_packets_to_master.v"                                                                                               -work transacto                             
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_packets_to_bytes.v"                                                                                             -work p2b                                   
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_bytes_to_packets.v"                                                                                             -work b2p                                   
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                                                         -work fifo                                  
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/pattern_gen_master_0_timing_adt.sv"                                                                 -L altera_common_sv_packages -work timing_adt                            
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_jtag_interface.v"                                                                                               -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_jtag_dc_streaming.v"                                                                                                      -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_jtag_sld_node.v"                                                                                                          -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_jtag_streaming.v"                                                                                                         -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_clock_crosser.v"                                                                                                -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_std_synchronizer_nocut.v"                                                                                                 -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                                                                                -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_idle_remover.v"                                                                                                 -work jtag_phy_embedded_in_jtag_master      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_avalon_st_idle_inserter.v"                                                                                                -work jtag_phy_embedded_in_jtag_master      
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv"                                                                 -L altera_common_sv_packages -work jtag_phy_embedded_in_jtag_master      
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_tpg_scheduler.sv"                                                            -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work tpg_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work tpg_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_tpg_alg_core.sv"                                                             -L altera_common_sv_packages -work tpg_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work output_mux                            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work output_mux                            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_packet_mux.sv"                                                               -L altera_common_sv_packages -work output_mux                            
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work seq_to_par_0                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work seq_to_par_0                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_fifo2/src_hdl/alt_vip_common_fifo2.sv"                                -L altera_common_sv_packages -work seq_to_par_0                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_pip_converter_core.sv"                                                       -L altera_common_sv_packages -work seq_to_par_0                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_mult_add/src_hdl/alt_vip_common_mult_add.sv"                          -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel.sv"                          -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel_par.sv"                      -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_h_kernel/src_hdl/alt_vip_common_h_kernel_seq.sv"                      -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_mirror/src_hdl/alt_vip_common_mirror.sv"                              -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_edge_detect_chain/src_hdl/alt_vip_common_edge_detect_chain.sv"        -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_step_coeff.sv"                                               -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_step_line.sv"                                                -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_realign.sv"                                                  -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_controller.sv"                                               -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_nn_channel.sv"                                               -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_horizontal_channel.sv"                                       -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_vertical_channel.sv"                                         -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_edge_detect.sv"                                              -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_bilinear_channel.sv"                                         -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core_bilinear_coeffs.sv"                                          -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_alg_core.sv"                                                          -L altera_common_sv_packages -work scaler_core_0                         
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_alt_vip_cl_scl_0_scaler_core_0.v"                                                                                    -work scaler_core_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_fifo2/src_hdl/alt_vip_common_fifo2.sv"                                -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sop_align/src_hdl/alt_vip_common_sop_align.sv"                        -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_line_buffer_controller.sv"                                                   -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_line_buffer_mem_block.sv"                                                    -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_line_buffer_multicaster.sv"                                                  -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_line_buffer.sv"                                                              -L altera_common_sv_packages -work line_buffer_0                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work input_demux                           
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work input_demux                           
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_packet_demux.sv"                                                             -L altera_common_sv_packages -work input_demux                           
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work video_in_cmd                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work video_in_cmd                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_video_input_bridge_cmd.sv"                                                   -L altera_common_sv_packages -work video_in_cmd                          
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_kernel_creator_step.sv"                                               -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_kernel_creator_div.sv"                                                -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_kernel_creator_nn.sv"                                                 -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_kernel_creator_non_nn.sv"                                             -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_kernel_creator.sv"                                                    -L altera_common_sv_packages -work kernel_creator                        
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_slave_interface/src_hdl/alt_vip_common_slave_interface.sv"            -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_slave_interface/src_hdl/alt_vip_common_slave_interface_mux.sv"        -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_scaler_scheduler.sv"                                                         -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_latency_0_to_latency_1.sv" -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_video_packet_empty.sv"     -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_video_packet_encode/src_hdl/alt_vip_common_video_packet_encode.sv"    -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sop_align/src_hdl/alt_vip_common_sop_align.sv"                        -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_video_output_bridge.sv"                                                      -L altera_common_sv_packages -work video_out                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work video_in_resp                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work video_in_resp                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_video_packet_decode/src_hdl/alt_vip_common_latency_1_to_latency_0.sv" -L altera_common_sv_packages -work video_in_resp                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_video_packet_decode/src_hdl/alt_vip_common_video_packet_decode.sv"    -L altera_common_sv_packages -work video_in_resp                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_video_input_bridge_resp.sv"                                                  -L altera_common_sv_packages -work video_in_resp                         
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work control                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work control                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_control_slave.sv"                                                            -L altera_common_sv_packages -work control                               
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_stream_marker.sv"                                                        -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_core.sv"                                                                 -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_sync_compare.v"                                                          -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_sync_conditioner.sv"                                                     -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_sync_generation.sv"                                                      -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_calculate_mode.v"                                                        -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_mode_banks.sv"                                                           -L altera_common_sv_packages -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_statemachine.sv"                                                         -L altera_common_sv_packages -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_fifo/src_hdl/alt_vip_common_fifo.v"                                                                -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_generic_step_count/src_hdl/alt_vip_common_generic_step_count.v"                                    -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_to_binary/src_hdl/alt_vip_common_to_binary.v"                                                      -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sync/src_hdl/alt_vip_common_sync.v"                                                                -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_trigger_sync/src_hdl/alt_vip_common_trigger_sync.v"                                                -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sync_generation/src_hdl/alt_vip_common_sync_generation.v"                                          -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_frame_counter/src_hdl/alt_vip_common_frame_counter.v"                                              -work cvo_core                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sample_counter/src_hdl/alt_vip_common_sample_counter.v"                                            -work cvo_core                              
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work sop_align                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work sop_align                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_sop_align/src_hdl/alt_vip_common_sop_align.sv"                        -L altera_common_sv_packages -work sop_align                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_pip_sop_realign.sv"                                                          -L altera_common_sv_packages -work sop_align                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_decode/src_hdl/alt_vip_common_event_packet_decode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/modules/alt_vip_common_event_packet_encode/src_hdl/alt_vip_common_event_packet_encode.sv"    -L altera_common_sv_packages -work scheduler                             
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/mentor/src_hdl/alt_vip_cvo_scheduler.sv"                                                            -L altera_common_sv_packages -work scheduler                             
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_alt_vip_cl_cvo_0_video_in.v"                                                                                         -work video_in                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                                                                                       -work rst_controller                        
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                                                                                     -work rst_controller                        
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_mm_interconnect_0.v"                                                                                                 -work mm_interconnect_0                     
  eval  vlog -sv $USER_DEFINED_COMPILE_OPTIONS "$QSYS_SIMDIR/submodules/altera_avalon_mm_master_bfm.sv"                                                                     -L altera_common_sv_packages -work mm_master_bfm_0                       
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_master_0.v"                                                                                                          -work master_0                              
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_alt_vip_cl_tpg_0.v"                                                                                                  -work alt_vip_cl_tpg_0                      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_alt_vip_cl_scl_0.v"                                                                                                  -work alt_vip_cl_scl_0                      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/submodules/pattern_gen_alt_vip_cl_cvo_0.v"                                                                                                  -work alt_vip_cl_cvo_0                      
  eval  vlog $USER_DEFINED_COMPILE_OPTIONS     "$QSYS_SIMDIR/pattern_gen.v"                                                                                                                                                                          
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L error_adapter_0 -L avalon_st_adapter -L rsp_mux -L rsp_demux -L cmd_mux -L cmd_demux -L alt_vip_cl_cvo_0_control_burst_adapter -L mm_master_bfm_0_m0_limiter -L router_002 -L router -L alt_vip_cl_cvo_0_control_agent -L mm_master_bfm_0_m0_agent -L alt_vip_cl_cvo_0_control_translator -L mm_master_bfm_0_m0_translator -L p2b_adapter -L b2p_adapter -L transacto -L p2b -L b2p -L fifo -L timing_adt -L jtag_phy_embedded_in_jtag_master -L scheduler -L tpg_core -L output_mux -L seq_to_par_0 -L scaler_core_0 -L line_buffer_0 -L input_demux -L video_in_cmd -L kernel_creator -L video_out -L video_in_resp -L control -L cvo_core -L sop_align -L video_in -L rst_controller -L mm_interconnect_0 -L mm_master_bfm_0 -L master_0 -L alt_vip_cl_tpg_0 -L alt_vip_cl_scl_0 -L alt_vip_cl_cvo_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L error_adapter_0 -L avalon_st_adapter -L rsp_mux -L rsp_demux -L cmd_mux -L cmd_demux -L alt_vip_cl_cvo_0_control_burst_adapter -L mm_master_bfm_0_m0_limiter -L router_002 -L router -L alt_vip_cl_cvo_0_control_agent -L mm_master_bfm_0_m0_agent -L alt_vip_cl_cvo_0_control_translator -L mm_master_bfm_0_m0_translator -L p2b_adapter -L b2p_adapter -L transacto -L p2b -L b2p -L fifo -L timing_adt -L jtag_phy_embedded_in_jtag_master -L scheduler -L tpg_core -L output_mux -L seq_to_par_0 -L scaler_core_0 -L line_buffer_0 -L input_demux -L video_in_cmd -L kernel_creator -L video_out -L video_in_resp -L control -L cvo_core -L sop_align -L video_in -L rst_controller -L mm_interconnect_0 -L mm_master_bfm_0 -L master_0 -L alt_vip_cl_tpg_0 -L alt_vip_cl_scl_0 -L alt_vip_cl_cvo_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo "                                 For most designs, this should be overridden"
  echo "                                 to enable the elab/elab_debug aliases."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
  echo
  echo "USER_DEFINED_COMPILE_OPTIONS  -- User-defined compile options, added to com/dev_com aliases."
  echo
  echo "USER_DEFINED_ELAB_OPTIONS     -- User-defined elaboration options, added to elab/elab_debug aliases."
}
file_copy
h
