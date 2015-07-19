TARGET=main
all: burn

PREFIX=arm-none-eabi

CC=$(PREFIX)-gcc
LD=$(PREFIX)-gcc
AS=$(PREFIX)-as
CP=$(PREFIX)-objcopy
OD=$(PREFIX)-objdump


OBJCOPYFLAGS = -O binary

BIN=$(CP) -O ihex 

DEFS =  -DSTM32F40_41xxx  -DHSE_VALUE=8000000
STARTUP = lib/startup_stm32f40_41xxx.s
STLIB = STM32F4xx_StdPeriph_Driver
MCU = cortex-m3
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mthumb-interwork

STM32_INCLUDES = -Ilib -I. -I$(STLIB)/inc


OPTIMIZE       = -Os

CFLAGS	= $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I. -I./ $(STM32_INCLUDES)  -Wl,-T,lib/stm32f407.ld
CFLAGS+=-DDEBUG

AFLAGS	= $(MCFLAGS) 

SRC = main.c \
	stm32f4xx_it.c \
	lib/system_stm32f4xx.c \
	lib/systems.c \
	$(STLIB)/src/stm32f4xx_rcc.c \
	$(STLIB)/src/stm32f4xx_gpio.c


burn : $(TARGET).bin
	openocd -f flash.cfg #-d3
terminal :
	openocd -f terminal.cfg

$(TARGET).bin : $(TARGET).out
	$(CP) $(OBJCOPYFLAGS) $< $@

$(TARGET).hex: $(EXECUTABLE)
	$(CP) -O ihex $^ $@

$(TARGET).out : $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -lm -lc -lnosys  -o $@

clean:
	rm -f $(TARGET).lst $(TARGET).out $(TARGET).hex $(TARGET).bin $(TARGET).map  $(EXECUTABLE)
