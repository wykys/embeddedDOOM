# Makefile for generating support files for DOOM
# wykys 2023

######################################
# project variables
######################################
# optimalization
OPT = -O0
# build dir
BUILD_DIR = build
GENERATED_DIR = ../generated

# includes
INC =          \
-I../doom/inc  \
-I../generated \
-I/usr/include \

# defines
DEF =                    \
-DGENERATE_BAKED         \
-DGENERATE_BAKED_INITIAL \
-DNORMALUNIX             \
-DLINUX                  \
-DMAXPLAYERS=1           \
-DRANGECHECK             \
-DDISABLE_NETWORK        \

######################################
# source
######################################
# C sources
C_SOURCES =            \
../doom/src/i_video.c  \
../doom/src/i_main.c   \
../doom/src/doomdef.c  \
../doom/src/doomstat.c \
../doom/src/dstrings.c \
../doom/src/i_system.c \
../doom/src/tables.c   \
../doom/src/f_finale.c \
../doom/src/f_wipe.c   \
../doom/src/d_main.c   \
../doom/src/d_items.c  \
../doom/src/g_game.c   \
../doom/src/m_menu.c   \
../doom/src/m_misc.c   \
../doom/src/m_argv.c   \
../doom/src/m_bbox.c   \
../doom/src/m_fixed.c  \
../doom/src/m_swap.c   \
../doom/src/m_cheat.c  \
../doom/src/m_random.c \
../doom/src/am_map.c   \
../doom/src/p_ceilng.c \
../doom/src/p_doors.c  \
../doom/src/p_enemy.c  \
../doom/src/p_floor.c  \
../doom/src/p_inter.c  \
../doom/src/p_lights.c \
../doom/src/p_map.c    \
../doom/src/p_maputl.c \
../doom/src/p_plats.c  \
../doom/src/p_pspr.c   \
../doom/src/p_setup.c  \
../doom/src/p_sight.c  \
../doom/src/p_spec.c   \
../doom/src/p_switch.c \
../doom/src/p_mobj.c   \
../doom/src/p_telept.c \
../doom/src/p_tick.c   \
../doom/src/p_saveg.c  \
../doom/src/p_user.c   \
../doom/src/r_bsp.c    \
../doom/src/r_data.c   \
../doom/src/r_draw.c   \
../doom/src/r_main.c   \
../doom/src/r_plane.c  \
../doom/src/r_segs.c   \
../doom/src/r_sky.c    \
../doom/src/r_things.c \
../doom/src/w_wad.c    \
../doom/src/wi_stuff.c \
../doom/src/v_video.c  \
../doom/src/st_lib.c   \
../doom/src/st_stuff.c \
../doom/src/hu_stuff.c \
../doom/src/hu_lib.c   \
../doom/src/z_zone.c   \
../doom/src/info.c     \
../doom/src/i_net.c    \
../doom/src/d_net.c    \
../doom/src/stubs.c    \
../doom/src/sounds.c   \
../doom/src/s_sound.c  \
../doom/src/i_sound.c

C_SOURCES += $(GENERATED_DIR)/rawwad_begin.c

#######################################
# toolchain
#######################################
CC = gcc -fdiagnostics-color=always
RM = rm -rf

#######################################
# build the application
#######################################
# compile gcc flags
LIBS = -lXext -lX11 -lnsl -lm -lpthread
AFLAGS = -m32 $(INC)
CFLAGS = -m32 $(INC) $(DEF) $(OPT) -g -w -flto -fdata-sections -ffunction-sections

# generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"

LDFLAGS = -Wl,--gc-sections $(CFLAGS)

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# default action: build all
all:                            \
$(BUILD_DIR)/gentables          \
#$(GENERATED_DIR)/rawwad.c       \
#$(GENERATED_DIR)/rawwad_use.c   \

# create object files from C files
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

# gentables
$(BUILD_DIR)/gentables: $(OBJECTS)
	$(CC) $(LDFLAGS) $(LIBS) $^ /usr/lib/i386-linux-gnu/libX11.so -o $@

# create build directory
$(BUILD_DIR):
	@mkdir $@

# create generated dir
$(GENERATED_DIR):
	@mkdir $@

# clean up
clean:
	$(RM) $(BUILD_DIR) # $(GENERATED_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

