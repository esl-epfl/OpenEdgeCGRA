
# Generic top Makefile

APP_NAME  = $(shell basename $(CURDIR))

APP_SRC_FILES  =  main.c

CFLAGS += -O0

LD_SCRIPT = ${PROJECT_ROOT}/software/lnk/riscv_base.ld
# LD_SCRIPT = ${PROJECT_ROOT}/software/lnk/riscv_base_192kB.ld

-include ${PROJECT_ROOT}/software/scripts/riscv_app.mk

# Choose between cadence incisive or mentor graphics modelsim
-include ${PROJECT_ROOT}/software/scripts/riscv_sim_irun.mk
# -include ${PROJECT_ROOT}/software/scripts/riscv_sim_msim.mk

clean       : clean_app clean_sim
	rm -rf mem
all         : app sim_batch
run         : sim_batch
run_gui     : sim
