
# Constraints
# ----------------------------------------------------------------------------
# 0. Ideal Network
#
# 1. Clock Definitions
#
# 2. set input/output delay on ports
#
# 3. Driving cells
#
# 4. Output load
#
# 5. Scan Config
#
# 6. Port Config
#


####################################################################################
           #########################################################
                  #### Section 0 : Ideal Network and DC Variables ####
           #########################################################
#################################################################################### 

set_case_analysis 1 [get_ports test_mode]
set_ideal_network {clk reset scan_clk scan_rst test_mode SE}

set_fix_multiple_port_nets -all -buffer_constants -feedthroughs

set test_default_period 100
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 40
set test_default_strobe_width 0

####################################################################################
           #########################################################
                  #### Section 1 : Clock Definition ####
           #########################################################
#################################################################################### 
# 1. Master Clock Definitions 
# 2. Generated Clock Definitions
# 3. Clock Latencies
# 4. Clock Uncertainties
# 4. Clock Transitions
####################################################################################

set DFT_CLK_NAME DFT_CLK
set DFT_CLK_PER 100
set DFT_CLK_SETUP_SKEW 0.025
set DFT_CLK_HOLD_SKEW 0.01
set CLK_LAT 0



create_clock -name $DFT_CLK_NAME -period $DFT_CLK_PER -waveform {45 55} [get_ports scan_clk]
		
set_clock_groups -logically_exclusive -group clk -group $DFT_CLK_NAME
			  
set_clock_uncertainty -setup $DFT_CLK_SETUP_SKEW [get_clocks $DFT_CLK_NAME]
set_clock_uncertainty -hold  $DFT_CLK_HOLD_SKEW  [get_clocks $DFT_CLK_NAME]


####################################################################################
           #########################################################
             #### Section 2 : set input/output delay on ports ####
           #########################################################
####################################################################################

set dft_in_delay  [expr 0.3*$DFT_CLK_PER]
set dft_out_delay [expr 0.3*$DFT_CLK_PER]


set dft_in_ports "SI SE test_mode"
set dft_out_ports "SO"

#Constrain Input Paths

set_input_delay $dft_in_delay -clock $DFT_CLK_NAME [get_ports "$dft_in_ports"]

#Constrain Output Paths

set_output_delay $dft_out_delay -clock $DFT_CLK_NAME [get_ports "$dft_out_ports"]

####################################################################################
           #########################################################
                  #### Section 3 : Driving cells ####
           #########################################################
####################################################################################

set_driving_cell -library "saed90nm_max" -lib_cell IBUFFX2 [get_ports "$dft_in_ports"]

####################################################################################
           #########################################################
                  #### Section 4 : Output load ####
           #########################################################
####################################################################################

set_load 0.1 [get_ports "$dft_out_ports"]


####################################################################################
           #########################################################
                  #### Section 5 : Scan Config ####
           #########################################################
####################################################################################

set_scan_configuration -style multiplexed_flip_flop -replace true -clock_mixing no_mix -max_length 1000

####################################################################################
           #########################################################
                  #### Section 6 : Port Config ####
           #########################################################
####################################################################################

set_dft_signal -view existing_dft -type ScanClock   -port [get_ports scan_clk] -timing {45 55}

#set_dft_signal -view existing_dft -type Reset      -port [get_ports scan_rst]  -active_state 0

set_dft_signal -view existing_dft -type Constant    -port [get_ports test_mode] -active_state 1
set_dft_signal -view spec         -type TestMode    -port [get_ports test_mode] -active_state 1

set_dft_signal -view spec         -type ScanEnable  -port [get_ports SE]        -active_state 1  -usage scan

set_dft_signal -view spec         -type ScanDataIn  -port [get_ports SI] 

set_dft_signal -view spec         -type ScanDataOut -port [get_ports SO] 



