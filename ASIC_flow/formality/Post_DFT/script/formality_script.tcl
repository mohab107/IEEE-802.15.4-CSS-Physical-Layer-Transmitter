###################################################################
########################### Variables #############################
###################################################################

set top_module zigbee_phy_tx

lappend search_path "../../../std_cells"
lappend search_path "../../../rtl"

################## Design Compiler Library Files #setup ######################

set synopsys_auto_setup true

set_svf ../../../dft/run/${top_module}_dft.svf

set SSLIB "saed90nm_max.db"

###################################################################
###################### Reference Container ########################
###################################################################

read_db -container Ref [list $SSLIB]

read_verilog -container Ref "chirp_modulation.v"
read_verilog -container Ref "demux.v"
read_verilog -container Ref "dqpsk_encoder.v"
read_verilog -container Ref "form_ppdu.v"
read_verilog -container Ref "master_ctrl_fsm.v"
read_verilog -container Ref "mux2x1.v"
read_verilog -container Ref "payload_ram.v"
read_verilog -container Ref "piso.v"
read_verilog -container Ref "preamble_sfd_rom.v"
read_verilog -container Ref "qpsk_dqpsk_chirp_top.v"
read_verilog -container Ref "qpsk_mapper.v"
read_verilog -container Ref "symbol_mapper.v"
read_verilog -container Ref "symbol_mapper_RAM.v"
read_verilog -container Ref "zero_padder.v"
read_verilog -container Ref "zigbee_phy_tx.v"

set_reference_design $top_module
set_top $top_module

##################################################################
#################### Implementation Container #####################
###################################################################

read_db -container imp [list $SSLIB]
read_ddc -container imp  "../../../dft/results/zigbee_phy_tx_dft.ddc"

set_implementation_design $top_module
set_top $top_module

############## Constants ################################
set_constant Ref:/WORK/*/test_mode 0 
set_constant imp:/WORK/*/test_mode 0 

set_constant Ref:/WORK/*/SE 0 
set_constant imp:/WORK/*/SE 0 

############## Don't Verify ##############################
set_dont_verify_points -type port Ref:/WORK/*/SI
set_dont_verify_points -type port imp:/WORK/*/SI

set_dont_verify_points -type port Ref:/WORK/*/SO
set_dont_verify_points -type port imp:/WORK/*/SO


###################### Matching Compare points ####################

match

######################### Run Verification ########################

set successful [verify]

if {!$successful} {
diagnose
analyze_points -failing
} else {
puts "successful"
}

########################### Reporting ############################# 
report_passing_points    > ../results/passing_points.rpt
report_failing_points    > ../results/failing_points.rpt
report_aborted_points    > ../results/aborted_points.rpt
report_unverified_points > ../results/unverified_points.rpt


start_gui

