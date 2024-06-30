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

ASTERISM_DIR            = Asterism
ASTERISC_DIR            = $(shell pwd)
WORK_DIR                = work
ARCHITECTURES_DIR       = architectures
SIMULATIONS_DIR         = simulations
RESULTS_DIR             = results
BENCHMARKS_DIR          = $(RESULTS_DIR)
BENCHMARKS_SIM_DIR      = $(WORK_DIR)/simulation/TB_AsteRISM_Verilator

########################################################
# Files
########################################################

SYNTH_SETTINGS_FILE     = _run_fmax_synthesis_settings.yml
SIM_SETTINGS_FILE       = _run_simulations_settings.yml
BENCHMARKS_FILE         = $(BENCHMARKS_DIR)/benchmark.yml

########################################################
# Text formatting
########################################################

_BOLD                   =\033[1m
_END                    =\033[0m
_RED                    =\033[31m
_BLUE                   =\033[34m
_CYAN                   =\033[36m
_YELLOW                 =\033[33m
_GREEN                  =\033[32m
_WHITE                  =\033[37m
_GREY                   =\033[90m
_BLACK                  =\033[30m

########################################################
# General rules
########################################################

.PHONY: motd
motd:

	@printf "$(_BLUE)$(_WHITE)5555555$(_YELLOW)555555555555$(_WHITE)$(_BLUE)  $(_YELLOW)            _____ _______ ______ _____  _____  _____  _____ \n"
	@printf "$(_BLUE)$(_WHITE)555555555$(_YELLOW)5555555555$(_WHITE)$(_BLUE)  $(_YELLOW)     /\    / ____|__   __|  ____|  __ \|_   _|/ ____|/ ____|\n"
	@printf "$(_BLUE)5555555$(_WHITE)555$(_YELLOW)555555555$(_WHITE)$(_BLUE)  $(_YELLOW)    /  \  | (___    | |  | |__  | |__) | | | | (___ | |     \n"
	@printf "$(_BLUE)5555555$(_WHITE)555$(_YELLOW)55555555$(_WHITE)5$(_BLUE)  $(_YELLOW)   / /\ \  \___ \   | |  |  __| |  _  /  | |  \___ \| |     \n"
	@printf "$(_BLUE)555555$(_WHITE)555$(_YELLOW)55555555$(_WHITE)55$(_BLUE)  $(_YELLOW)  / ____ \ ____) |  | |  | |____| | \ \ _| |_ ____) | |____ \n"
	@printf "$(_BLUE)5$(_WHITE)5555555$(_YELLOW)55555555$(_WHITE)555$(_BLUE)  $(_YELLOW) /_/    \_\_____/   |_|  |______|_|  \_\_____|_____/ \_____|\n"
	@printf "$(_BLUE)55$(_WHITE)5555$(_YELLOW)55555555$(_WHITE)5555$(_BLUE)5\n"
	@printf "$(_BLUE)5555$(_WHITE)5555$(_YELLOW)55555$(_WHITE)5555$(_BLUE)55                     $(_BOLD)An Open-Source Flexible $(_END)\n"
	@printf "$(_BLUE)55555$(_WHITE)5555$(_YELLOW)55$(_WHITE)5555$(_BLUE)5555                     $(_BOLD) RISC-V Processor Core$(_END)\n"
	@printf "$(_BLUE)5555555$(_WHITE)5555$(_YELLOW)$(_WHITE)555$(_BLUE)55555\n$(_END)"
	@printf "\n"

.PHONY: clean
clean: clean_vivado clean_dc

########################################################
# Simulation
########################################################

.PHONY: sim
sim: motd
	@make -C $(ASTERISM_DIR) $@_only CURRENT_DIR=$(ASTERISC_DIR) OPTIONS="-i $(ASTERISC_DIR)/$(SIM_SETTINGS_FILE) --archpath $(ASTERISC_DIR)/$(ARCHITECTURES_DIR) --simpath $(ASTERISC_DIR)/$(SIMULATIONS_DIR) --work $(ASTERISC_DIR)/$(WORK_DIR)/simulation" --no-print-directory

.PHONY: benchmarks
benchmarks: motd benchmarks_only results_benchmarks

.PHONY: benchmarks_only
benchmarks_only:
	@make -C $(ASTERISM_DIR) sim_only CURRENT_DIR=$(ASTERISC_DIR) OPTIONS="-i $(ASTERISC_DIR)/$(SIM_SETTINGS_FILE) --archpath $(ASTERISC_DIR)/$(ARCHITECTURES_DIR) --simpath $(ASTERISC_DIR)/$(SIMULATIONS_DIR) --work $(ASTERISC_DIR)/$(WORK_DIR)/simulation" --no-print-directory

.PHONY: results_benchmarks
results_benchmarks:
	@make -C $(ASTERISM_DIR) $@_only OPTIONS="-i $(ASTERISC_DIR)/$(BENCHMARKS_SIM_DIR) -o $(ASTERISC_DIR)/$(BENCHMARKS_FILE)" --no-print-directory

########################################################
# Vivado
########################################################

.PHONY: vivado
vivado: motd run_vivado clean_vivado results_vivado

.PHONY: run_vivado
run_vivado: 
	@make -C $(ASTERISM_DIR) $@_only CURRENT_DIR=$(ASTERISC_DIR) OPTIONS="-i $(ASTERISC_DIR)/$(SYNTH_SETTINGS_FILE) --archpath $(ASTERISC_DIR)/$(ARCHITECTURES_DIR) --work $(ASTERISC_DIR)/$(WORK_DIR)" --no-print-directory

.PHONY: results_vivado
results_vivado:
	@make -C $(ASTERISM_DIR) $@_only OPTIONS="-i $(ASTERISC_DIR)/$(WORK_DIR) -o $(ASTERISC_DIR)/$(RESULTS_DIR) --benchmark --benchmark_file $(ASTERISC_DIR)/$(BENCHMARKS_FILE)" --no-print-directory

.PHONY: clean_vivado
clean_vivado:
	@make -C $(ASTERISM_DIR) $@ CURRENT_DIR=$(ASTERISC_DIR) --no-print-directory

########################################################
# Design Compiler
########################################################

.PHONY: dc
dc: motd 
	@make -C $(ASTERISM_DIR) $@_only CURRENT_DIR=$(ASTERISC_DIR) OPTIONS="-i $(ASTERISC_DIR)/$(SYNTH_SETTINGS_FILE) --archpath $(ASTERISC_DIR)/$(ARCHITECTURES_DIR) --work $(ASTERISC_DIR)/$(WORK_DIR)" --no-print-directory

.PHONY: results_dc
results_dc:
	@make -C $(ASTERISM_DIR) $@_only OPTIONS="-i $(ASTERISC_DIR)/$(WORK_DIR) -o $(ASTERISC_DIR)/$(RESULTS_DIR) --benchmark --benchmark_file $(ASTERISC_DIR)/$(BENCHMARKS_FILE)" --no-print-directory

.PHONY: clean_dc
clean_dc:
	@make -C $(ASTERISM_DIR) $@ CURRENT_DIR=$(ASTERISC_DIR) --no-print-directory

########################################################
# Generic
########################################################

# export results 

.PHONY: results
results: results_benchmarks results_vivado results_dc


# explore results

.PHONY: explore
explore:
	@make -C $(ASTERISM_DIR) $@_only OPTIONS="-i $(ASTERISC_DIR)/$(RESULTS_DIR)" --no-print-directory
