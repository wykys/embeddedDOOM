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
INC = \
-I../doom/inc \
-I../generated \

# defines
DEF = \

######################################
# source
######################################
# C sources
C_SOURCES = $(wildcard ../doom/src/info.c)

#######################################
# toolchain
#######################################
CC = gcc -fdiagnostics-color=always
RM = rm -rf

#######################################
# build the application
#######################################
# compile gcc flags
AFLAGS = -Wall $(INC)
CFLAGS = -Wall $(INC) $(DEF) $(OPT)

# generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"

# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# default action: build all
all:                            \
$(BUILD_DIR)/wadder             \
$(BUILD_DIR)/shrinkwad          \
$(GENERATED_DIR)/rawwad.c       \
$(GENERATED_DIR)/rawwad_use.c   \
$(GENERATED_DIR)/rawwad_begin.c \

# create object files from C files
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	@$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/shrinkwad.o: src/shrinkwad.c $(GENERATED_DIR)/rawwad.c Makefile | $(BUILD_DIR) $(GENERATED_DIR)
	@$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/wadder.o: src/wadder.c Makefile | $(BUILD_DIR)
	@$(CC) -c $(CFLAGS) $< -o $@

# wadder
$(BUILD_DIR)/wadder: $(BUILD_DIR)/wadder.o Makefile
	@$(CC) $(CFLAGS) $< -o $@

# shrinkwad
$(BUILD_DIR)/shrinkwad: $(BUILD_DIR)/shrinkwad.o $(OBJECTS) Makefile
	@$(CC) $(CFLAGS) $< -o $@

# gennerated
$(GENERATED_DIR)/rawwad.c: $(BUILD_DIR)/wadder | $(GENERATED_DIR)
	@$(BUILD_DIR)/wadder

$(GENERATED_DIR)/rawwad_use.c : $(BUILD_DIR)/shrinkwad stripchoice.txt add_sprites.txt | $(GENERATED_DIR)
	@$(BUILD_DIR)/shrinkwad stripchoice.txt add_sprites.txt $(GENERATED_DIR)/rawwad_use.c $(GENERATED_DIR)/rawwad_use.h

$(GENERATED_DIR)/rawwad_begin.c : $(BUILD_DIR)/shrinkwad stripchoicebegin.txt | $(GENERATED_DIR)
	@$(BUILD_DIR)/shrinkwad stripchoicebegin.txt 0 $(GENERATED_DIR)/rawwad_begin.c $(GENERATED_DIR)/rawwad_begin.h

# create build directory
$(BUILD_DIR):
	@mkdir $@

# create generated dir
$(GENERATED_DIR):
	@mkdir $@

# clean up
clean:
	$(RM) $(BUILD_DIR) $(GENERATED_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

