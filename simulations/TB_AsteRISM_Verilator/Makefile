#**********************************************************************#
#                               AsteRISC                               #
#**********************************************************************#
#
# Copyright (C) 2022 Jonathan Saussereau
#
# This file is part of AsteRISC.
# AsteRISC is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# AsteRISC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with AsteRISC. If not, see <https://www.gnu.org/licenses/>.
#

########################################################
# Paths
########################################################

PWD = $(shell pwd)
WORK_DIR = $(PWD)
ASTERISM_DIR = ../../Asterism
RTL_DIR = ../../AsteRISC-rtl/rtl
OBJ_DIR = $(PWD)/obj
LOG_DIR = $(PWD)/log
VCD_DIR = $(PWD)/vcd
TB_DIR  = $(PWD)/tb

ENV_SET = export LC_ALL=C; unset LANGUAGE;

########################################################
# Files
########################################################

INCLUDE_ALL_SCRIPT  = $(WORK_DIR)/include_all.py

RV_TEST_IMEM_FILE   = $(ASTERISM_DIR)/../AsteRISC-firmware/validation/tests/bin/tests_imem.hex
RV_TEST_DMEM_FILE   = $(ASTERISM_DIR)/../AsteRISC-firmware/validation/tests/bin/tests_dmem.hex
DHRYSTONE_IMEM_FILE = $(ASTERISM_DIR)/../AsteRISC-firmware/hex/dhrystone_benchmark_imem.hex
DHRYSTONE_DMEM_FILE = $(ASTERISM_DIR)/../AsteRISC-firmware/hex/dhrystone_benchmark_dmem.hex
COREMARK_IMEM_FILE  = $(ASTERISM_DIR)/../AsteRISC-firmware/benchmarks/coremark/bin/coremark_benchmark_imem.hex
COREMARK_DMEM_FILE  = $(ASTERISM_DIR)/../AsteRISC-firmware/benchmarks/coremark/bin/coremark_benchmark_dmem.hex

########################################################
# Simulation Parameters
########################################################

MODULE = soc_wrapper_top
VCD_FILE = $(VCD_DIR)/$(MODULE).vcd

IMEM_FILE = $(DHRYSTONE_IMEM_FILE)
DMEM_FILE = $(DHRYSTONE_DMEM_FILE)

IMEM_DEPTH = 11
DMEM_DEPTH = 11

########################################################
# Files
########################################################

VERILATOR_LOGFILE = verilator.log
SIM_LOGFILE = $(LOG_DIR)/sim.log
PRINT_FILE = $(LOG_DIR)/print.log

# RTL source files
EXCLUDE_PREFIX = tb_
RTL_FILES := $(shell cd $(RTL_DIR); find . -name '*.sv' -not -name '$(EXCLUDE_PREFIX)*')
SV_FILES := $(wildcard $(RTL_DIR)/**/*.sv)

# C++ (testbench) source files
CPP_FILES := $(wildcard $(TB_DIR)/*.cpp)

# Verilated tartget
SIM_FILE = $(OBJ_DIR)/V$(MODULE)

# Verilator options
VERILATOR_FLAGS = -Wall -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL --trace --x-assign unique --x-initial unique

########################################################
# Text formatting
########################################################

_END     =\033[0m
_BOLD    =\033[1m
_BLACK   =\033[30m
_RED     =\033[31m
_GREEN   =\033[32m
_YELLOW  =\033[33m
_BLUE    =\033[34m
_MAGENTA =\033[35m
_CYAN    =\033[36m
_WHITE   =\033[37m
_GREY    =\033[90m

VERILATOR_COLOR := $(shell printf 's/%%Error\\(\\S*\\):\\(.*\\)/%%$(_BOLD)$(_RED)Error\\1$(_END):$(_RED)\\2$(_END)/g;s/%%Warning\\(\\S*\\):\\(.*\\)/%%$(_BOLD)$(_YELLOW)Warning\\1$(_END):$(_YELLOW)\\2$(_END)/g')########################################################

########################################################
# Rules
########################################################

.PHONY: help
help:
	@printf "VERIFICATION\n"
	@printf "\t$(_BOLD)make lint$(_END): check syntax of rtl files\n"
	@printf "SIMULATION\n"
	@printf "\t$(_BOLD)make verilate$(_END): compile rtl\n"
	@printf "\t$(_BOLD)make sim$(_END): run the simulation\n"
	@printf "\t$(_BOLD)make view$(_END): view simulation waveform\n"
	@printf "OTHERS\n"
	@printf "\t$(_BOLD)make clean$(_END): clean generated files\n"
	@printf "\t$(_BOLD)make help$(_END): display a list of useful commands\n"

.PHONY: print
print: 
	@printf "CPP_FILES=$(CPP_FILES)\n"
	@printf "WORK_DIR=$(WORK_DIR)\n"
	@printf "RTL_DIR=$(RTL_DIR)\n"
	@printf "OBJ_DIR=$(OBJ_DIR)\n"
	@printf "LOG_DIR=$(LOG_DIR)\n"
	@printf "VCD_DIR=$(VCD_DIR)\n"
	@printf "TB_DIR=$(TB_DIR)\n"
	@printf "PWD=$(PWD)\n\n"

.PHONY: sim
sim: $(VCD_FILE)

.PHONY: view
view:
	@printf "\n$(_BOLD)$(_CYAN)"
	@printf "######################################\n"
	@printf "              View Waves              \n"
	@printf "######################################\n"
	@printf "$(_END)\n"
	@gtkwave $(VCD_FILE) -a gtkwave_setup.gtkw

$(VCD_FILE): $(SIM_FILE) 
	@printf "\n$(_BOLD)$(_CYAN)"
	@printf "######################################\n"
	@printf "              Simulating              \n"
	@printf "######################################\n"
	@printf "$(_END)\n"
	@$(SIM_FILE) --imem_file "$(IMEM_FILE)" --dmem_file "$(DMEM_FILE)" --imem_depth $(IMEM_DEPTH) --dmem_depth $(DMEM_DEPTH) --vcd_file "$(VCD_FILE)" --print --print_save $(PRINT_FILE) \
	| tee "$(SIM_LOGFILE)" | sed "$(VERILATOR_COLOR)"
#	+verilator+rand+reset+2 

$(SIM_FILE): .stamp.verilate
	@printf "\n$(_BOLD)$(_CYAN)"
	@printf "######################################\n"
	@printf "         Building Simulation          \n"
	@printf "######################################\n"
	@printf "$(_END)"
	@python3 $(INCLUDE_ALL_SCRIPT)
	@make -C $(OBJ_DIR) -f V$(MODULE).mk V$(MODULE) MAKEFLAGS=s --no-print-directory


.PHONY: verilate
verilate: .stamp.verilate

.stamp.verilate: makedir $(SV_FILES) $(CPP_FILES)
	@printf "\n$(_BOLD)$(_CYAN)"
	@printf "######################################\n"
	@printf "              Verilating              \n"
	@printf "######################################\n"
	@printf "$(_END)\n"
	@$(ENV_SET) cd $(RTL_DIR); verilator -Mdir $(OBJ_DIR) --top-module $(MODULE) $(VERILATOR_FLAGS) -cc $(RTL_FILES) --exe $(CPP_FILES) \
	2>&1 | tee "$(LOG_DIR)/$(VERILATOR_LOGFILE)" | sed "$(VERILATOR_COLOR)"
	@touch .stamp.verilate

.PHONY: lint
lint: $(SV_FILES)
	@$(ENV_SET) cd $(RTL_DIR); verilator --lint-only --top-module $(MODULE) $(VERILATOR_FLAGS) -cc $(RTL_FILES) \
	 2>&1 | sed $(VERILATOR_COLOR)

.PHONY: hierarchy
hierarchy: $(SV_FILES)
	@$(ENV_SET) cd $(RTL_DIR); verilator -C --top-module $(MODULE) $(VERILATOR_FLAGS) -cc $(RTL_FILES) \
	 2>&1 | sed $(VERILATOR_COLOR)

.PHONY: clean
clean:
	@rm -rf .stamp.*
	@rm -rf $(OBJ_DIR)
	@rm -rf $(LOG_DIR)
	@rm -rf $(VCD_DIR)

.PHONY: makedir
makedir:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(LOG_DIR)
	@mkdir -p $(VCD_DIR)
