set top_module zigbee_phy_tx
lappend search_path /home/ICer/Downloads/Lib/synopsys/models
lappend search_path /home/ICer/zigbee/synthesis/rtl
##########################################################
##########################################################
set synopsys_auto_setup true
##########################################################
set_svf "/home/ICer/zigbee/synthesis/run/${top_module}.svf"
##########################################################
set SSLIB "saed90nm_max.db"
##########################################################
read_db -container ref [list $SSLIB]
##########################################################
read_verilog -container ref {*.v}
##########################################################
set_reference_design $top_module
set_top $top_module
##########################################################
read_db -container imp [list $SSLIB]
##########################################################
read_verilog -container imp -netlist "/home/ICer/zigbee/synthesis/results/outputs/${top_module}.v"
############################################################
set_implementation_design $top_module
set_top $top_module
############################################################
#set_constant ref:/WORK/*/test_mode 0
#set_constant imp:/WORK/*/test_mode 0
#############################################################
match
#############################################################
    set successful [verify]
    if {! $successful} {
    diagnose    
    analyze_points -failing
    } else {
    puts "successful"
    }
###################################################################
report_passing_points > ../results/reports/passing_points.rpt
report_failing_points > ../results/reports/failing_points.rpt
report_aborted_points > ../results/reports/aborted_points.rpt
report_unverified_points > ../results/reports/unverified_points.rpt
