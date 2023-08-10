#!/bin/bash
# run_mdc.sh
# Bash script to simulate design with Metrics DSim Cloud

# Set up environment
WAVE_FILE=waves.vcd.gz # remove .gz for an uncompressed result

set -e

# Compile vendor libraries
mdc dvhcom -a '-vhdl93 -f twentynm_files.txt -lib twentynm'
mdc dvhcom -a '-vhdl93 -f twentynm_hssi_files.txt -lib twentynm_hssi'
mdc dvhcom -a '-vhdl93 -f twentynm_hip_files.txt -lib twentynm_hip'
mdc dvhcom -a '-vhdl93 -f work_vhdl93_files.txt'
mdc dvlcom -a '-f twentynm_ver_files.txt -lib twentynm_ver'
mdc dvlcom -a '-f twentynm_hssi_ver_files.txt -lib twentynm_hssi_ver'
mdc dvlcom -a '-f twentynm_hip_ver_files.txt -lib twentynm_hip_ver'
mdc dvlcom -a '-f work_verilog_files.txt'

# Compile design libraries
mdc dvlcom -a './../../src/intel_FPGA_turbov_0_example_design_core.v'
mdc dvlcom -a '-sv -f work_sv_files.txt'

# Elaborate and Simulate design, and dump waveform
mdc dsim -a "-top work.turbov_ul_top_tb -libmap lib.map -timescale 1ps/1ps +acc+b -waves $WAVE_FILE -suppress NumericStd:ArraySubtypeWarning"
