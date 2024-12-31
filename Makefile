# Author: S. M. Tahmeed Reza
# Username: tahmeedKENJI (https://www.github.com/tahmeedKENJI)
# Email: tahmeedreza@gmail.com

#############################################################################################################################################
#DEFAULT
#############################################################################################################################################

.DEFAULT_GOAL := clean

#############################################################################################################################################
#VARIABLES
#############################################################################################################################################

ROOT_DIR := $(shell realpath .)
SRC_DIR := ${ROOT_DIR}/source/
TEST_DIR := ${ROOT_DIR}/test/

INC_DIR += -i ${ROOT_DIR}/include/
ifneq ($(TOP),)
	INC_DIR += -i ${TEST_DIR}/$(TOP)
endif

RTL_DIR := ${SRC_DIR}/*.sv

XVLOG_DEFS += --define SIMULATION
XVLOG_DEFS += --define ENABLE_DUMPFILE

CONFIG ?= default

#############################################################################################################################################
#PHONY_LIST
#############################################################################################################################################

.PHONY: clean clean_all xvlog xelab xsim gui_xsim wave

#############################################################################################################################################
#GOALS
#############################################################################################################################################

build:
	@mkdir -p build

log:
	@mkdir -p log

config:
	@cd build; echo "$(TOP) $(CONFIG)" > config

clean:
	@echo -e "\033[3;35mCleaning build directory...\033[0m"
	@rm -rf build
	@make -s build
	@echo -e "\033[3;35mCleaned build directory...\033[0m"

clean_all: clean
	@echo -e "\033[3;35mCleaning all generated files directories...\033[0m"
	@rm -rf log
	@make -s log
	@echo -e "\033[3;35mCleaned all generated files directories...\033[0m"

xvlog:
	@echo -e "\033[3;35mCompilation Started...\033[0m"
	@cd build; xvlog $(INC_DIR) --sv $(TEST_DIR)/$(TOP)/$(TOP).sv $(RTL_DIR) --nolog $(XVLOG_DEFS) | tee -a ../log/$(TOP)_$(CONFIG).log
	@echo -e "\033[3;35mDone Compilation...\033[0m"

xelab:
	@echo -e "\033[3;35mElaboration Started $(TOP)...\033[0m"
	@cd build; xelab $(TOP) -s $(TOP) --nolog | tee -a ../log/$(TOP)_$(CONFIG).log
	@echo -e "\033[3;35mDone Elaboration...\033[0m"

xsim:
	@echo -e "\033[3;35mSimulation Started $(TOP)...\033[0m"
	@cd build; xsim $(TOP) --runall --nolog | tee -a ../log/$(TOP)_$(CONFIG).log
	@echo -e "\033[3;35mDone Simulation $(TOP)...\033[0m"

gui_xsim:
	@echo -e "\033[3;35m GUI Simulation Started $(TOP)...\033[0m"
	@cd build; xsim $(TOP) --gui --nolog | tee -a ../log/$(TOP)_$(CONFIG).log
	@echo -e "\033[3;35mDone GUI Simulation $(TOP)...\033[0m"

simulate: clean config xvlog xelab xsim
gui_simulate: clean config xvlog xelab gui_xsim
	
wave: simulate
	@echo -e "\033[3;35mWaveform Started $(TOP)...\033[0m"
	@cd build; gtkwave dump.vcd
	@echo -e "\033[3;35mDone Waveform $(TOP)...\033[0m"