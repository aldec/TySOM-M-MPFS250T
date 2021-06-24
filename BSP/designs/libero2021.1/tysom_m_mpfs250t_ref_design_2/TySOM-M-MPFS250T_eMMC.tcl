# TySOM-M-MPFS250T eMMC Libero design

if {[string compare [string range [get_libero_version] 0 end-3] "2021.1.0"]==0} { 
	puts "Libero v2021.1 detected." 
} else {
	error "Incorrect Libero version. Please use Libero v2021.1 to run these scripts."
}

if { [lindex $tcl_platform(os) 0]  == "Windows" } {
	if {[string length [pwd]] < 90} {
		puts "Project path length ok." 
	} else {
		error "Path to project is too long, please reduce the path and try again."
	}
}

if { $::argc > 0 } {
    set i 1
    foreach arg $::argv {
		set temp [split $arg ":"]
		puts "Setting parameter [lindex $temp 0] to [lindex $temp 1]"
		set [lindex $temp 0] "[lindex $temp 0]:[lindex $temp 1]"
        incr i
    }
} else {
    puts "no command line argument passed"
}

set install_loc [defvar_get -name ACTEL_SW_DIR]
set mss_config_loc "$install_loc/bin64/pfsoc_mss"
set local_dir [pwd]
set project_dir "$local_dir/TySOM_M_MPFS250T_eMMC"

set emmc_sd "emmc"

set constraint_path ./constraints

new_project -location {./TySOM_M_MPFS250T_eMMC} -name {TySOM_M_MPFS250T_eMMC} -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -use_relative_path 0 -linked_files_root_dir_env {} -hdl {VERILOG} -family {PolarFireSoC} -die {MPFS250T_ES} -package {FCG1152} -speed {-1} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT} 
set_device -family {PolarFireSoC} -die {MPFS250T_ES} -package {FCG1152} -speed {-1} -die_voltage {1.0} -part_range {EXT} -adv_options {IO_DEFT_STD:LVCMOS 1.8V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} -adv_options {TEMPR:EXT} -adv_options {VCCI_1.2_VOLTR:EXT} -adv_options {VCCI_1.5_VOLTR:EXT} -adv_options {VCCI_1.8_VOLTR:EXT} -adv_options {VCCI_2.5_VOLTR:EXT} -adv_options {VCCI_3.3_VOLTR:EXT} -adv_options {VOLTR:EXT} 

download_core -vlnv {Actel:SgCore:PF_OSC:1.0.102} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:SgCore:PF_CCC:2.2.100} -location {www.microchip-ip.com/repositories/SgCore}
download_core -vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore}
download_core -vlnv {Microsemi:SgCore:PFSOC_INIT_MONITOR:1.0.205} -location {www.microchip-ip.com/repositories/SgCore} 

source ./script_support/TySOM_M_MPFS250T_eMMC_recursive.tcl

run_tool -name {CONSTRAINT_MANAGEMENT} 

import_files \
         -convert_EDN_to_HDL 0 \
         -sdc "${constraint_path}/ALDEC_SDC.sdc" 

# Import I/O constraints
import_files \
         -convert_EDN_to_HDL 0 \
		 -io_pdc "${constraint_path}/ALDEC_QSFP.pdc" \
		 -io_pdc "${constraint_path}/ALDEC_DDR4.pdc" \
         -io_pdc "${constraint_path}/ALDEC_CAN0.pdc" \
         -io_pdc "${constraint_path}/ALDEC_MAC.pdc" \
         -io_pdc "${constraint_path}/ALDEC_UARTs.pdc" \
		 -io_pdc "${constraint_path}/ALDEC_USB.pdc" \
		 -io_pdc "${constraint_path}/ALDEC_SDIO.pdc" \
		 -io_pdc "${constraint_path}/ALDEC_I2C0.pdc"

organize_tool_files -tool {PLACEROUTE} -file "${project_dir}/constraint/io/ALDEC_DDR4.pdc" -file "${project_dir}/constraint/io/ALDEC_QSFP.pdc" -file "${project_dir}/constraint/io/ALDEC_CAN0.pdc" -file "${project_dir}/constraint/io/ALDEC_SDIO.pdc" -file "${project_dir}/constraint/io/ALDEC_USB.pdc" -file "${project_dir}/constraint/io/ALDEC_MAC.pdc" -file "${project_dir}/constraint/io/ALDEC_UARTs.pdc" -file "${project_dir}/constraint/io/ALDEC_I2C0.pdc" -module {tysom_m_v10::work} -input_type {constraint} 
organize_tool_files -tool {VERIFYTIMING} -file "${project_dir}/constraint/ALDEC_SDC.sdc" -module {tysom_m_v10::work} -input_type {constraint} 
organize_tool_files -tool {SYNTHESIZE}  -file "${project_dir}/constraint/ALDEC_SDC.sdc" -module {tysom_m_v10::work} -input_type {constraint} 

derive_constraints_sdc 
configure_tool -name {PLACEROUTE} -params {DELAY_ANALYSIS:MAX} -params {EFFORT_LEVEL:false} -params {GB_DEMOTION:true} -params {INCRPLACEANDROUTE:false} -params {IOREG_COMBINING:false} -params {MULTI_PASS_CRITERIA:VIOLATIONS} -params {MULTI_PASS_LAYOUT:false} -params {NUM_MULTI_PASSES:5} -params {PDPR:false} -params {RANDOM_SEED:0} -params {REPAIR_MIN_DELAY:true} -params {REPLICATION:false} -params {SLACK_CRITERIA:WORST_SLACK} -params {SPECIFIC_CLOCK:} -params {START_SEED_INDEX:1} -params {STOP_ON_FIRST_PASS:false} -params {TDPR:true} 

save_project 
