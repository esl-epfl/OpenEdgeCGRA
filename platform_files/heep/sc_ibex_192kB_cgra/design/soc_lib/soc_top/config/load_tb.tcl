
################################################################################
# Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                  #
#                                                                              #
# Additional contributions by:                                                 #
#                 Simone Machetti - simone.machetti@epfl.ch                    #
#                                                                              #
# Filename:       load_tb.tcl                                                  #
# Project Name:   EDA tool flow                                                #
#                                                                              #
# Description:    Script to load the testbench. Find based on top module       #
#                 defined in config/design_setup.tcl.                          #
#                                                                              #
################################################################################


set tb_libs        [list]

set tb_name        tb_platform
set library        soc_lib
set module_dir     soc_top

set project_root   ${::env(PROJECT_ROOT)}
set digital_root   ${::env(DIGITAL_ROOT)}
set ips_root       ${::env(IPS_ROOT)}

# load testbench
lappend tb_libs [list ${library} ${digital_root}/${library}/${module_dir}/testbench/tb_platform.sv]

set sdf_scope      $tb_name.soc_top_i
