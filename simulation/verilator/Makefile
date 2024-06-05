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

BASE_DIR = ../..
RTL_DIR = $(BASE_DIR)/AsteRISC-core/rtl
VER_DIR = $(BASE_DIR)/simulation/verilator
OBJ_DIR = $(VER_DIR)/obj
LOG_DIR = $(VER_DIR)/log
TB_DIR = $(VER_DIR)/src

INCLUDE_ALL_SCRIPT = $(VER_DIR)/include_all.py

ENV_SET = export LC_ALL=C; unset LANGUAGE;

########################################################
# Simulation Parameters
########################################################

MODULE = soc_wrapper_top

#IMEM_FILE = $(BASE_DIR)/AsteRISC-firmware/benchmarks/dhrystone_benchmark/bin/dhrystone_benchmark_imem.hex
#DMEM_FILE = $(BASE_DIR)/AsteRISC-firmware/benchmarks/dhrystone_benchmark/bin/dhrystone_benchmark_dmem.hex
IMEM_FILE = $(BASE_DIR)/AsteRISC-firmware/validation/tests/bin/tests_imem.hex
DMEM_FILE = $(BASE_DIR)/AsteRISC-firmware/validation/tests/bin/tests_dmem.hex

IMEM_DEPTH = 10
DMEM_DEPTH = 10

VCD_FILE = waveform.vcd
PRINT_FILE = $(LOG_DIR)/print.log

########################################################
# Files
########################################################

# Compiler les fichiers SystemVerilog
EXCLUDE_PREFIX = tb_
RTL_FILES := $(shell cd $(RTL_DIR); find . -name '*.sv' -not -name '$(EXCLUDE_PREFIX)*')
SV_FILES := $(wildcard $(RTL_DIR)/**/*.sv)

# Compiler les fichiers C++
CPP_FILES := $(wildcard $(TB_DIR)/*.cpp)

# Définir les cibles pour les fichiers Verilated
SIM_FILE = $(OBJ_DIR)/V$(MODULE)

# Options Verilator
VERILATOR_FLAGS = -Wall -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL --trace --x-assign unique --x-initial unique

########################################################
# Text formatting
########################################################

_BOLD    =\x1b[1m
_END     =\x1b[0m
_BLACK   =\x1b[30m
_RED     =\x1b[31m
_GREEN   =\x1b[32m
_YELLOW  =\x1b[33m
_BLUE    =\x1b[34m
_MAGENTA =\x1b[35m
_CYAN    =\x1b[36m
_WHITE   =\x1b[37m

VERILATOR_COLOR = "s/%Error\(\S*\):\(.*\)/%$(_BOLD)$(_RED)Error\1$(_END):$(_RED)\2$(_END)/g;s/%Warning\(\S*\):\(.*\)/%$(_BOLD)$(_YELLOW)Warning\1$(_END):$(_YELLOW)\2$(_END)/g"

########################################################
# Rules
########################################################

.PHONY: help
help: motd
	@echo -e "VERIFICATION"
	@echo -e "\t$(_BOLD)make lint$(_END): check syntax of rtl files"
	@echo -e "SIMULATION"
	@echo -e "\t$(_BOLD)make verilate$(_END): compile rtl"
	@echo -e "\t$(_BOLD)make sim$(_END): run the simulation"
	@echo -e "\t$(_BOLD)make view$(_END): view simulation waveform"
	@echo -e "OTHERS"
	@echo -e "\t$(_BOLD)make clear$(_END): clean generated files"
	@echo -e "\t$(_BOLD)make help$(_END): display a list of useful commands"

.PHONY: motd
motd:
	@echo -ne "$(_BOLD)"
	@echo "********************************************************************"
	@echo "*                             AsteRISC                             *"
	@echo "********************************************************************"
	@echo -ne "$(_END)"
	@echo ""

.PHONY: sim
sim: $(VCD_FILE)

.PHONY: view
#view: $(VCD_FILE)
view:
	@echo -ne "\n$(_BOLD)$(_CYAN)"
	@echo "######################################"
	@echo "              View Waves              "
	@echo "######################################"
	@echo -e "$(_END)"
	@gtkwave $(VCD_FILE) -a gtkwave_setup.gtkw

$(VCD_FILE): $(SIM_FILE)
	@echo -ne "\n$(_BOLD)$(_CYAN)"
	@echo "######################################"
	@echo "              Simulating              "
	@echo "######################################"
	@echo -e "$(_END)"
	@$(SIM_FILE) --imem_file "$(IMEM_FILE)" --dmem_file "$(DMEM_FILE)" --imem_depth $(IMEM_DEPTH) --dmem_depth $(DMEM_DEPTH) --vcd_file "$(VCD_FILE)" --print --print_save $(PRINT_FILE) \
	| sed $(VERILATOR_COLOR)
#	+verilator+rand+reset+2 

$(SIM_FILE): .stamp.verilate
	@echo -ne "\n$(_BOLD)$(_CYAN)"
	@echo "######################################"
	@echo "         Building Simulation          "
	@echo "######################################"
	@echo -e "$(_END)"
	@python3 $(INCLUDE_ALL_SCRIPT)
	@make -C $(OBJ_DIR) -f V$(MODULE).mk V$(MODULE) MAKEFLAGS=s --no-print-directory


.PHONY: verilate
verilate: .stamp.verilate

.stamp.verilate: makedir $(SV_FILES) $(CPP_FILES)
	@echo -ne "\n$(_BOLD)$(_CYAN)"
	@echo "######################################"
	@echo "              Verilating              "
	@echo "######################################"
	@echo -e "$(_END)"
	@$(ENV_SET) cd $(RTL_DIR); verilator -Mdir $(OBJ_DIR) --top-module $(MODULE) $(VERILATOR_FLAGS) -cc $(RTL_FILES) --exe $(CPP_FILES) \
	2>&1 | tee $(LOG_DIR)/verilator.log | sed $(VERILATOR_COLOR)
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
	@rm -rf waveform.vcd

.PHONY: makedir
makedir:
	@mkdir -p $(LOG_DIR)
