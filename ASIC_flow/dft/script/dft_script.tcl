
########################### Define Top Module ############################
                                                   
set top_module zigbee_phy_tx

##################### Define Working Library Directory ######################
                                                   
define_design_lib work -path ./work

################## Design Compiler Library Files #setup ######################

lappend search_path "../../std_cells"
lappend search_path "../../rtl"

set SSLIB "saed90nm_max.db"

## Standard Cell libraries 
set target_library [list $SSLIB]

## Standard Cell & Hard Macros libraries 
set link_library [list * $SSLIB]  


set_svf ${top_module}_dft.svf


################## Read RTL ######################
set my_files [list \
    chirp_modulation.v \
    demux.v \
    dqpsk_encoder.v \
    form_ppdu.v \
    master_ctrl_fsm.v \
    mux2x1.v \
    payload_ram.v \
    piso.v \
    preamble_sfd_rom.v \
    qpsk_dqpsk_chirp_top.v \
    qpsk_mapper.v \
    symbol_mapper.v \
    symbol_mapper_RAM.v \
    zero_padder.v \
    zigbee_phy_tx.v \
]

# 1. Analyze all files
analyze -format verilog $my_files

# 2. Elaborate the top module (This resolves all parameters like mux2x1)
elaborate $top_module

###################### Defining toplevel ###################################
current_design $top_module

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## Liniking All The Design Parts ########"
puts "###############################################"

link 

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## checking design consistency ##########"
puts "###############################################"

check_design

#################### Define Design Constraints #########################
puts "###############################################"
puts "############ Design Constraints #### ##########"
puts "###############################################"

source -echo -verbose ../cons/synthesis_cons.tcl
source -echo -verbose ../cons/dft_cons.tcl

#################### Replace DFF with SFF #########################

compile -scan -map_effort high


###################### Mapping and optimization ########################
puts "###############################################"
puts "########## Mapping & Optimization #############"
puts "###############################################"

compile -scan -map_effort high


#################### Test Protocol #########################

create_test_protocol

#################### DRC Check #########################

dft_drc -verbose               > ../results/dft_pre_dft_drc.rpt

#show the dft chains
preview_dft -show scan_summary > ../results/dft_pre_dft_chains.rpt


#################### Scan Stitching #########################

insert_dft

compile -scan -map_effort high -incremental

#################### Second Checks #########################

dft_drc -coverage_estimate     > ../results/dft_post_dft_drc.rpt

#show the dft chains
preview_dft -show scan_summary > ../results/dft_post_dft_chains.rpt


set_svf -off


#############################################################################
# Write out Design
#############################################################################

write -hierarchy -format verilog -output ../results/${top_module}_dft.v
write -hierarchy -format ddc     -output ../results/${top_module}_dft.ddc
write_sdc                                ../results/${top_module}_dft.sdc
write_sdf                                ../results/${top_module}_dft.sdf
################# reporting #######################


report_area -hierarchy                       > ../results/area_dft.rpt
report_power -hierarchy                      > ../results/power_dft.rpt
report_timing -max_paths 100 -delay_type max > ../results/setup_dft.rpt
report_timing -max_paths 100 -delay_type min > ../results/hold_dft.rpt
report_clocks -attributes                    > ../results/clocks_dft.rpt
report_constraint -all_violators             > ../results/constraints_dft.rpt
report_port                                  > ../results/ports_dft.rpt

################# starting graphical user interface #######################

#gui_start
