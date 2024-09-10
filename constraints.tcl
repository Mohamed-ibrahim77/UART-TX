
#################### Define Design Constraints #########################
puts "###############################################"
puts "############ Design Constraints #### ##########"
puts "###############################################"

# Constraints
# ----------------------------------------------------------------------------
#
# 1. Master Clock Definitions
#
# 2. Generated Clock Definitions
#
# 3. Clock Uncertainties
#
# 4. Clock Latencies 
#
# 5. Clock Relationships
#
# 6. set input/output delay on ports
#
# 7. Driving cells
#
# 8. Output load

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

set CLK_NAME MASTER_CLK
set CLK_PER 8680
set CLK_SETUP_SKEW 0.25
set CLK_HOLD_SKEW 0.05
set CLK_LAT 0
set CLK_RISE 0.1
set CLK_FALL 0.1
#set REG_CLK_PER [expr $CLK_PER * 2]

create_clock -name $CLK_NAME -period $CLK_PER -waveform "0 [expr $CLK_PER/2]" [get_ports CLK]
set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clocks $CLK_NAME]
set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clocks $CLK_NAME]
set_clock_transition -rise $CLK_RISE  [get_clocks $CLK_NAME]
set_clock_transition -fall $CLK_FALL  [get_clocks $CLK_NAME]
set_clock_latency $CLK_LAT [get_clocks $CLK_NAME]


#create_generated_clock -master_clock $CLK_NAME -source [get_ports CLK] \
#                       -name "ALU_CLK" [get_port U0_CLK_GATE/GATED_CLK] \
#                       -divide_by 1
#set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clocks ALU_CLK]
#set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clocks ALU_CLK]
#set_clock_transition -rise $CLK_RISE  [get_clocks ALU_CLK]
#set_clock_transition -fall $CLK_FALL  [get_clocks ALU_CLK]
#set_clock_latency $CLK_LAT [get_clocks ALU_CLK]
#
#
#create_generated_clock -master_clock $CLK_NAME -source [get_ports CLK] \
#                       -name "REG_CLK" [get_port U0_ClkDiv/o_div_clk] \
#                       -divide_by 2
#set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clocks REG_CLK]
#set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clocks REG_CLK]
#set_clock_transition -rise $CLK_RISE  [get_clocks REG_CLK]
#set_clock_transition -fall $CLK_FALL  [get_clocks REG_CLK]
#set_clock_latency $CLK_LAT [get_clocks REG_CLK]
					   
set_dont_touch_network [get_clocks {MASTER_CLK RST}]

####################################################################################
           #########################################################
                  #### Section 2 : Clocks Relationships ####
           #########################################################
####################################################################################


####################################################################################
           #########################################################
             #### Section 3 : set input/output delay on ports ####
           #########################################################
####################################################################################

set in1_delay  [expr 0.3*$CLK_PER]
set out1_delay [expr 0.3*$CLK_PER]

#set in2_delay  [expr 0.2*$REG_CLK_PER]
#set out2_delay [expr 0.2*$REG_CLK_PER]

#Constrain Input Paths
set_input_delay $in1_delay -clock MASTER_CLK [get_port P_DATA]
set_input_delay $in1_delay -clock MASTER_CLK [get_port Data_Valid]
set_input_delay $in1_delay -clock MASTER_CLK [get_port parity_enable]
set_input_delay $in1_delay -clock MASTER_CLK [get_port parity_type]
#set_input_delay $in2_delay -clock REG_CLK [get_port WrEn]
#set_input_delay $in2_delay -clock REG_CLK [get_port RdEn]
#set_input_delay $in2_delay -clock REG_CLK [get_port Address]
#set_input_delay $in2_delay -clock REG_CLK [get_port WrData]
#set_input_delay $in1_delay -clock ALU_CLK [get_port ALU_FUN]
#set_input_delay $in1_delay -clock ALU_CLK [get_port ALU_Enable]

#Constrain Output Paths
set_output_delay $out2_delay -clock REG_CLK [get_port TX_OUT]
set_output_delay $out1_delay -clock ALU_CLK [get_port busy]
#set_output_delay $out1_delay -clock ALU_CLK [get_port ALU_OUT]

####################################################################################
           #########################################################
                  #### Section 4 : Driving cells ####
           #########################################################
####################################################################################

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port P_DATA]
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port Data_Valid]
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port parity_enable]
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port parity_type]
#set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port Address]
#set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port WrData]
#set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port ALU_FUN]
#set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port ALU_Enable]

####################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################

set_load 0.5 [get_port TX_OUT]
set_load 0.5 [get_port busy]
#set_load 75 [get_port ALU_OUT]

####################################################################################
           #########################################################
                 #### Section 6 : Operating Condition ####
           #########################################################
####################################################################################

# Define the Worst Library for Max(#setup) analysis
# Define the Best Library for Min(hold) analysis

set_operating_conditions -min_library "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" -min "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" \
                         -max_library "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c" -max "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"

####################################################################################
           #########################################################
                  #### Section 7 : wireload Model ####
           #########################################################
####################################################################################

set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c

####################################################################################
           #########################################################
                  #### Section 8 : multicycle path ####
           #########################################################
####################################################################################


###################### Mapping and optimization ########################
#puts "###############################################"
#puts "########## Mapping & Optimization #############"
#puts "###############################################"
#
#compile -map_effort high 
#
##############################################################################
## Write out Design after initial compile
##############################################################################
#
#write_file -format verilog -hierarchy -output UART_TX_Netlist.v
#write_file -format ddc -hierarchy -output UART_TX.ddc
#write_sdc  -nosplit UART_TX.sdc
#write_sdf           UART_TX.sdf
#
################## reporting #######################
#
#report_area -hierarchy > area.rpt
#report_power -hierarchy > power.rpt
#report_timing -max_paths 100 -delay_type min > hold.rpt
#report_timing -max_paths 100 -delay_type max > setup.rpt
#report_clock -attributes > clocks.rpt
#report_constraint -all_violators > constraints.rpt
#
################## starting graphical user interface #######################
#
##gui_start
#
##exit
