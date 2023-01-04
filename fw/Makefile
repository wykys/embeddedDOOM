# DEMO Makefile RISC-V
# wykys 2019

######################################
# project variables
######################################
# target name
TARGET = app
# optimalization
OPT = -O0
# build dir
BUILD_DIR = build
# includes
INC = -Iapp/inc -Idrivers/inc

######################################
# source
######################################
# C sources
C_SOURCES = $(wildcard app/src/*.c)
C_SOURCES += $(wildcard drivers/src/*.c)

# ASM sources
ASM_SOURCES = \
startup.S


#######################################
# toolchain
#######################################
TOOLCHAIN_PATH = /opt/riscv-none-embed-gcc
#######################################
BINPATH = $(TOOLCHAIN_PATH)/bin/
PREFIX = riscv-none-embed-
CC = $(BINPATH)$(PREFIX)gcc -fdiagnostics-color=always
AS = $(BINPATH)$(PREFIX)gcc -fdiagnostics-color=always -x assembler-with-cpp
CP = $(BINPATH)$(PREFIX)objcopy
DP = $(BINPATH)$(PREFIX)objdump
LD = $(BINPATH)$(PREFIX)ld
AR = $(BINPATH)$(PREFIX)ar
SZ = $(BINPATH)$(PREFIX)size -A
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
RM = rm -rf
SIMULATOR = ../cpu-cpp-emulator/sw/build/cpu-emulator

#######################################
# build the application
#######################################
# compile gcc flags
ARCH = -march=rv32i
SPEC = -nostartfiles --specs=nosys.specs
AFLAGS = $(ARCH) $(SPEC) -Wall $(INC)
CFLAGS = $(ARCH) $(SPEC) -Wall -std=c99 $(INC) $(OPT) -fdata-sections -ffunction-sections

LDSCRIPT = linker_script.ld
LDFLAGS = $(ARCH) $(SPEC) -Wl,--gc-sections -Wl,-Map=$(BUILD_DIR)/$(TARGET).map -Wl,--cref -T$(LDSCRIPT)

# generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# add ASM to objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASM_SOURCES) $(BUILD_DIR)))

# default action: build all
all:                       \
$(BUILD_DIR)/$(TARGET).elf \
$(BUILD_DIR)/$(TARGET).lss \
$(BUILD_DIR)/$(TARGET).bin \
size

# create object files from C files
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@
# create object files from ASM files
$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	@$(AS) -c $(AFLAGS) $< -o $@
$(BUILD_DIR)/init.o: $(BUILD_DIR)/init.S Makefile | $(BUILD_DIR)
	@$(AS) -c $(AFLAGS) $< -o $@
# create init asm
init: $(BUILD_DIR)/rodata.bin $(BUILD_DIR)/data.bin
	@./init.py
# create aplication ELF file
$(BUILD_DIR)/tmp.elf: $(OBJECTS) Makefile
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
$(BUILD_DIR)/$(TARGET).elf: init $(OBJECTS) $(BUILD_DIR)/init.o Makefile
	@$(CC) $(OBJECTS) $(BUILD_DIR)/init.o $(LDFLAGS) -o $@
# create bin program file
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	@$(BIN) --only-section .text $< $@
# create bin data file for RAM initialization
$(BUILD_DIR)/rodata.bin: $(BUILD_DIR)/tmp.elf | $(BUILD_DIR)
	@$(BIN) --only-section .rodata $< $@
$(BUILD_DIR)/data.bin: $(BUILD_DIR)/tmp.elf | $(BUILD_DIR)
	@$(BIN) --only-section .data $< $@
# disassembly EFL
$(BUILD_DIR)/$(TARGET).lss: $(BUILD_DIR)/$(TARGET).elf
	@$(DP) -h -S $< > $@
# create build directory
$(BUILD_DIR):
	@mkdir $@
# prints memory usage tables
size:
	@$(SZ) $(BUILD_DIR)/$(TARGET).elf
# clean up
clean:
	@$(RM) $(BUILD_DIR)
show_default_linker_script:
	@$(LD) --verbose -arch=elf32lriscv

simulator: $(BUILD_DIR)/$(TARGET).bin
	@$(SIMULATOR) $(BUILD_DIR)/$(TARGET).bin
