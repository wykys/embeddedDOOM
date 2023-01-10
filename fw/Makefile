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
INC = \
-Iapp/inc \
-Idrivers/inc \
-Idoom/inc \
-Igenerated \
-I/usr/include

# defines
DEF = \
-DRV32IMA_BUILD \
-DDISABLE_NETWORK \
-DFIXED_HEAP=262144 \
#-DMAXPLAYERS=1 \
-DDISABLE_NETWORK \
# -DUSEASM \
#-DLINUX \
# -DNORMALUNIX \
# -DRANGECHECK

######################################
# source
######################################
# C sources
C_SOURCES = $(wildcard app/src/*.c)
C_SOURCES += $(wildcard drivers/src/*.c)

C_SOURCES +=                   \
generated/rawwad_use.c         \
generated/baked_map_data.c     \
generated/baked_texture_data.c \

C_SOURCES +=        \
doom/src/doomdef.c  \
doom/src/doomstat.c \
doom/src/dstrings.c \
doom/src/i_system.c \
doom/src/tables.c   \
doom/src/f_finale.c \
doom/src/f_wipe.c   \
doom/src/d_main.c   \
doom/src/d_items.c  \
doom/src/g_game.c   \
doom/src/m_menu.c   \
doom/src/m_misc.c   \
doom/src/m_argv.c   \
doom/src/m_bbox.c   \
doom/src/m_fixed.c  \
doom/src/m_swap.c   \
doom/src/m_cheat.c  \
doom/src/m_random.c \
doom/src/am_map.c   \
doom/src/p_ceilng.c \
doom/src/p_doors.c  \
doom/src/p_enemy.c  \
doom/src/p_floor.c  \
doom/src/p_inter.c  \
doom/src/p_lights.c \
doom/src/p_map.c    \
doom/src/p_maputl.c \
doom/src/p_plats.c  \
doom/src/p_pspr.c   \
doom/src/p_setup.c  \
doom/src/p_sight.c  \
doom/src/p_spec.c   \
doom/src/p_switch.c \
doom/src/p_mobj.c   \
doom/src/p_telept.c \
doom/src/p_tick.c   \
doom/src/p_saveg.c  \
doom/src/p_user.c   \
doom/src/r_bsp.c    \
doom/src/r_data.c   \
doom/src/r_draw.c   \
doom/src/r_main.c   \
doom/src/r_plane.c  \
doom/src/r_segs.c   \
doom/src/r_sky.c    \
doom/src/r_things.c \
doom/src/w_wad.c    \
doom/src/wi_stuff.c \
doom/src/v_video.c  \
doom/src/st_lib.c   \
doom/src/st_stuff.c \
doom/src/hu_stuff.c \
doom/src/hu_lib.c   \
doom/src/z_zone.c   \
doom/src/info.c     \
doom/src/i_net.c    \
doom/src/d_net.c    \
doom/src/stubs.c    \
doom/src/sounds.c   \
doom/src/s_sound.c  \
doom/src/i_sound.c

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
ARCH = -march=rv32ima -mabi=ilp32   #-march=rv32i
SPEC = -nostartfiles --specs=nosys.specs
AFLAGS = $(ARCH) $(SPEC) -Wall $(INC)
CFLAGS = $(ARCH) $(SPEC) -Wall $(INC) $(DEF) $(OPT) -fno-stack-protector -static -static-libgcc -fdata-sections -ffunction-sections


# LDFLAGS= -Wl,--gc-sections # -T flatfile-rv32ima.lds -nostdlib

LDSCRIPT = linker_script.ld
LDFLAGS = $(ARCH) $(SPEC) -Wl,--gc-sections # -T$(LDSCRIPT)

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
	$(CC) -c $(CFLAGS) $< -o $@
# create object files from ASM files
$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(AFLAGS) $< -o $@
$(BUILD_DIR)/init.o: $(BUILD_DIR)/init.S Makefile | $(BUILD_DIR)
	$(AS) -c $(AFLAGS) $< -o $@
# create init asm
init: $(BUILD_DIR)/rodata.bin $(BUILD_DIR)/data.bin
	./init.py
# create aplication ELF file
$(BUILD_DIR)/tmp.elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
$(BUILD_DIR)/$(TARGET).elf: init $(OBJECTS) $(BUILD_DIR)/init.o Makefile
	$(CC) $(OBJECTS) $(BUILD_DIR)/init.o $(LDFLAGS) -o $@
# create bin program file
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	$(BIN) --only-section .text $< $@
# create bin data file for RAM initialization
$(BUILD_DIR)/rodata.bin: $(BUILD_DIR)/tmp.elf | $(BUILD_DIR)
	$(BIN) --only-section .rodata $< $@
$(BUILD_DIR)/data.bin: $(BUILD_DIR)/tmp.elf | $(BUILD_DIR)
	$(BIN) --only-section .data $< $@
# disassembly EFL
$(BUILD_DIR)/$(TARGET).lss: $(BUILD_DIR)/$(TARGET).elf
	$(DP) -h -S $< > $@
# create build directory
$(BUILD_DIR):
	mkdir $@
# prints memory usage tables
size:
	$(SZ) $(BUILD_DIR)/$(TARGET).elf
# clean up
clean:
	$(RM) $(BUILD_DIR)
show_default_linker_script:
	$(LD) --verbose -arch=elf32lriscv

simulator: $(BUILD_DIR)/$(TARGET).bin
	$(SIMULATOR) $(BUILD_DIR)/$(TARGET).bin

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)
