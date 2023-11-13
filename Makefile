UNAME := $(shell uname)
DEBUG := 0
ifeq ($(UNAME), Linux)
TARGET = test_linux
else
TARGET = test_windows
OS_LDLIBS = -lws2_32 -lwsock32
endif

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

EXE := $(BIN_DIR)/$(TARGET)
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

INC_DIRS := ./include
# (12)Include files add together a prefix, clang make sense that -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS   := $(INC_FLAGS) -Wall -pthread -std=c99
LDFLAGS  := -Llib
LDLIBS   := -lm $(OS_LDLIBS)

CC 	 := gcc

ifdef OS
   RM = del /Q
   FixPath = $(subst /,\,$1)
else
   ifeq ($(shell uname), Linux)
      RM = rm -rf
      FixPath = $1
   endif
endif

.PHONY: all clean

all: $(EXE)

$(EXE): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean:
	$(RM) $(BIN_DIR) 
	$(RM) $(OBJ_DIR)

.PHONY = run
run: clear all
	.\$(EXE)

-include $(OBJ:.o=.d)