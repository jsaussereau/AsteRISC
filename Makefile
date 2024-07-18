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
DHRYSTONE_WORK          = work/simulations/Dhrystone

########################################################
# Files
########################################################

ASTERISM_COMMAND        = python3 $(ASTERISM_DIR)/scripts/asterism.py
ASTERISM_EXPLORE_COMMAND= python3 $(ASTERISM_DIR)/scripts/asterism-explore.py
DHRYSTONE_SETTINGS      = simulations/_run_dhrystone_settings.yml

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

.PHONY: help
help: motd
	@printf "SIMULATION\n"
	@printf "\t$(_BOLD)make sim$(_END): run simulations\n"
	@printf "\t$(_BOLD)make benchmarks$(_END): run benchmark simulations\n"
	@printf "SYNTHESIS\n"
	@printf "\t$(_BOLD)make vivado$(_END): run synthesis + place&route in Vivado\n"
	@printf "\t$(_BOLD)make dc$(_END): run synthesis + place&route in Design Compiler\n"
	@printf "DATA EXPORT\n"
	@printf "\t$(_BOLD)make results$(_END): export synthesis results\n"
	@printf "\t$(_BOLD)make results_vivado$(_END): export Vivado synthesis results\n"
	@printf "\t$(_BOLD)make results_dc$(_END): export Design Compiler synthesis results\n"
	@printf "DATA EXPLORATION\n"
	@printf "\t$(_BOLD)make explore$(_END): explore results in a web app (localhost only)\n"
	@printf "\t$(_BOLD)make explore_network$(_END): explore results in a web app (network-accessible)\n"
	@printf "OTHERS\n"
	@printf "\t$(_BOLD)make help$(_END): display a list of useful commands\n"

.PHONY: motd
motd:

	@printf "$(_BLUE)$(_WHITE)5555555$(_YELLOW)555555555555$(_WHITE)$(_BLUE)  $(_YELLOW)            _____ _______ ______ _____  _____  _____  _____ \n"
	@printf "$(_BLUE)$(_WHITE)555555555$(_YELLOW)5555555555$(_WHITE)$(_BLUE)  $(_YELLOW)     /\    / ____|__   __|  ____|  __ \|_   _|/ ____|/ ____|\n"
	@printf "$(_BLUE)5555555$(_WHITE)555$(_YELLOW)555555555$(_WHITE)$(_BLUE)  $(_YELLOW)    /  \  | (___    | |  | |__  | |__) | | | | (___ | |     \n"
	@printf "$(_BLUE)5555555$(_WHITE)555$(_YELLOW)55555555$(_WHITE)5$(_BLUE)  $(_YELLOW)   / /\ \  \___ \   | |  |  __| |  _  /  | |  \___ \| |     \n"
	@printf "$(_BLUE)555555$(_WHITE)555$(_YELLOW)55555555$(_WHITE)55$(_BLUE)  $(_YELLOW)  / ____ \ ____) |  | |  | |____| | \ \ _| |_ ____) | |____ \n"
	@printf "$(_BLUE)5$(_WHITE)5555555$(_YELLOW)55555555$(_WHITE)555$(_BLUE)  $(_YELLOW) /_/    \_\_____/   |_|  |______|_|  \_\_____|_____/ \_____|\n"
	@printf "$(_BLUE)55$(_WHITE)5555$(_YELLOW)55555555$(_WHITE)5555$(_BLUE)5\n"
	@printf "$(_BLUE)5555$(_WHITE)5555$(_YELLOW)55555$(_WHITE)5555$(_BLUE)55                 $(_BOLD)A Flexible RISC-V Processor Core$(_END)\n"
	@printf "$(_BLUE)55555$(_WHITE)5555$(_YELLOW)55$(_WHITE)5555$(_BLUE)5555                   $(_BOLD)For Design Space Exploration$(_END)\n"
	@printf "$(_BLUE)5555555$(_WHITE)5555$(_YELLOW)$(_WHITE)555$(_BLUE)55555\n$(_END)"
	@printf "\n"

.PHONY: clean
clean: 
	@$(ASTERISM_COMMAND) clean --nobanner

########################################################
# Simulation
########################################################

.PHONY: sim
sim: motd
	@$(ASTERISM_COMMAND) sim --nobanner

.PHONY: benchmarks
benchmarks: motd benchmarks_only results_benchmarks

.PHONY: benchmarks_only
benchmarks_only:
	@$(ASTERISM_COMMAND) sim -i $(DHRYSTONE_SETTINGS) --nobanner

.PHONY: results_benchmarks
results_benchmarks:
	@$(ASTERISM_COMMAND) res_benchmark --work $(DHRYSTONE_WORK) --nobanner

########################################################
# Vivado
########################################################

.PHONY: vivado
vivado: motd run_vivado clean_vivado

.PHONY: run_vivado
run_vivado: 
	@$(ASTERISM_COMMAND) synth --tool vivado --nobanner

.PHONY: results_vivado
results_vivado:
	@$(ASTERISM_COMMAND) res_synth --tool vivado --nobanner

.PHONY: clean_vivado
clean_vivado:
	@$(ASTERISM_COMMAND) clean --quiet --nobanner

########################################################
# Design Compiler
########################################################

.PHONY: dc
dc: motd 
	@$(ASTERISM_COMMAND) synth --tool design_compiler --nobanner

.PHONY: results_dc
results_dc:
	@$(ASTERISM_COMMAND) res_synth --tool design_compiler --nobanner

.PHONY: clean_dc
clean_dc:
	@$(ASTERISM_COMMAND) clean --quiet --nobanner

########################################################
# Generic
########################################################

# export results 

.PHONY: results
results: results_benchmarks results_vivado


# explore results

.PHONY: explore
explore:
	@$(ASTERISM_EXPLORE_COMMAND)
