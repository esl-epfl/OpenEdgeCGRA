# Makefile

TARGET    = dbl_max_app

CC        = gcc
SRC_DIR   = src
BUILD_DIR = build
INC_DIR   = src

LIBS      = -lm -lrt
LIBDIR    = 
INCLUDE   = -I$(INC_DIR)

CFLAGS    = -O2 -Wall -g
VPATH     = $(SRC_DIR)

SRC       = $(notdir $(wildcard $(SRC_DIR)/*.c))
OBJ_PATH  = $(SRC:%.c=%.o)
OBJ       = $(patsubst %,$(BUILD_DIR)/%,$(OBJ_PATH))


all: $(TARGET)
	@echo ">>>>  COMPILATION FINISHED SUCCESSFULLY!"

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $+ $(LIBS) $(LIBDIRS)

$(BUILD_DIR)/%.o: %.c $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDE) -c -o $@ $<

$(BUILD_DIR):
	@mkdir $(BUILD_DIR)

clean:
	rm -rf *.s *.o *~ $(BUILD_DIR) $(TARGET) $(SRC_DIR)/*~

run:
	./$(TARGET)
