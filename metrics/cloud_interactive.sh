#!/bin/bash
# cloud_interactive.sh
# Bash script to simulate design with Metrics DSim Cloud

# Set up environment
cd work
WAVE_FILE=waves.vcd.gz # remove .gz for an uncompressed result
set -e

# Compile vendor libraries
mdc dvhcom -a '-vhdl93 -F ../common/twentynm_hip_filelist.txt -lib twentynm_hip'
mdc dvhcom -a '-vhdl93 -F ../common/twentynm_hssi_filelist.txt -lib twentynm_hssi'
mdc dvhcom -a '-vhdl93 -F ../common/work_vhdl93_filelist.txt'
mdc dvlcom -a '-F ../common/twentynm_ver_filelist.txt -lib twentynm_ver'
mdc dvlcom -a '-F ../common/twentynm_hip_ver_filelist.txt -lib twentynm_hip_ver'
mdc dvlcom -a '-F ../common/twentynm_hssi_ver_filelist.txt -lib twentynm_hssi_ver'
mdc dvlcom -a '-F ../common/work_verilog_filelist.txt'

# Compile design libraries
mdc dvlcom -a '../../../src/intel_FPGA_turbov_0_example_design_core.v'
mdc dvlcom -a '-sv -F ../common/work_sv_filelist.txt'

# Elaborate and Simulate design, and dump waveform
mdc dsim -a "-top work.turbov_ul_top_tb -libmap ../common/lib.map -timescale 1ps/1ps +acc+b -waves $WAVE_FILE -suppress NumericStd:ArraySubtypeWarning"
