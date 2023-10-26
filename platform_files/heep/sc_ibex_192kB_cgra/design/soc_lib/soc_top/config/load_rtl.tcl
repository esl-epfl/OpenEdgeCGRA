
################################################################################
# Author:         Benoît Denkinger - benoit.denkinger@epfl.ch                  #
#                                                                              #
# Additional contributions by:                                                 #
#                 Simone Machetti - simone.machetti@epfl.ch                    #
#                                                                              #
# Filename:       load_rtl.tcl                                                 #
# Project Name:   EDA tool flow                                                #
#                                                                              #
# Description:    Recursive script used to load full design. It lists the      #
#                 module/library files and the dependencies.                   #
#                                                                              #
################################################################################


set rtl_libs        [list]

set library         soc_lib
set module_dir      soc_top

set project_root    ${::env(PROJECT_ROOT)}
set digital_root    ${::env(DIGITAL_ROOT)}
set ips_root        ${::env(IPS_ROOT)}

if { ![info exist flow] } { set flow "unknown_flow" }

# Load rtl dependencies
set rtl_libs [concat $rtl_libs [PROC_load_rtl tech_lib sram_8192x32]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl tech_lib clkgate]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  my_pkg]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  ram_unified]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  ibex]]
# set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  ri5cy]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  bus_unified]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  cgra]]
set rtl_libs [concat $rtl_libs [PROC_load_rtl ips_lib  event_unit]]

# Load top level entity
lappend rtl_libs [list ${library} ${digital_root}/${library}/${module_dir}/rtl/soc_top.sv]
