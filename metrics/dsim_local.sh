#!/bin/bash
# dsim_local.sh
# Bash script to simulate design with Metrics DSim on local machine

# Set up environment
cd work
WAVE_FILE=waves.mxd
set -e

# Compile standard libraries
dlib map -lib ieee ${STD_LIBS}/ieee93
dvhcom -vhdl93 -lib altera -F ../common/altera_filelist.txt
dvhcom -vhdl93 -lib altera_lnsim -F ../common/altera_lnsim_filelist.txt
dvhcom -vhdl93 -lib altera_mf -F ../common/altera_mf_filelist.txt
dvhcom -vhdl93 -lib lpm -F ../common/lpm_filelist.txt
dvhcom -vhdl93 -lib sgate -F ../common/sgate_filelist.txt
dvlcom -lib altera_ver -F ../common/altera_ver_filelist.txt
dvlcom -lib altera_lnsim_ver -F ../common/altera_lnsim_ver_filelist.txt
dvlcom -lib altera_mf_ver -F ../common/altera_mf_ver_filelist.txt
dvlcom -lib lpm_ver -F ../common/lpm_ver_filelist.txt
dvlcom -lib sgate_ver -F ../common/sgate_ver_filelist.txt

# Compile vendor libraries
dvhcom -vhdl93 -lib twentynm_hip -F ../common/twentynm_hip_filelist.txt
dvhcom -vhdl93 -lib twentynm_hssi -F ../common/twentynm_hssi_filelist.txt
dvhcom -vhdl93 -F ../common/work_vhdl93_filelist.txt
dvlcom -lib twentynm_ver -F ../common/twentynm_ver_filelist.txt
dvlcom -lib twentynm_hip_ver -F ../common/twentynm_hip_ver_filelist.txt
dvlcom -lib twentynm_hssi_ver -F ../common/twentynm_hssi_ver_filelist.txt
dvlcom -F ../common/work_verilog_filelist.txt

# Compile design libraries
dvlcom ../../../src/intel_FPGA_turbov_0_example_design_core.v
dvlcom -sv -F ../common/work_sv_filelist.txt

# Elaborate and Simulate design, and dump waveform
dsim -top work.turbov_ul_top_tb -libmap ../common/lib.map -timescale 1ps/1ps +acc+b -waves $WAVE_FILE -suppress NumericStd:ArraySubtypeWarning
