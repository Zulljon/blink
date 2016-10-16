
# Binaries will be generated with this name (.elf, .bin, .hex, etc)
# and this name of project folder
PROJ_NAME=blink

# Put your STM32F4 library code directory here
STM_COMMON=/media/WIN_D/Micro_Cirquit/ARM/STM32Cube_FW_F4_V1.13.0

# HAL source files
HAL_DIR=$(STM_COMMON)/Drivers/STM32F4xx_HAL_Driver/Src
HAL_FILES=$(HAL_DIR)/*.c
#HAL_FILES=$(HAL_DIR)/stm32f4xx_hal.c
#HAL_FILES += $(HAL_DIR)/stm32f4xx_hal_rcc.c
#HAL_FILES += $(HAL_DIR)/stm32f4xx_hal_gpio.c
#HAL_FILES += $(HAL_DIR)/stm32f4xx_hal_cortex.c
#HAL_FILES += $(HAL_DIR)/stm32f4xx_hal_.c
#HAL_FILES += $(HAL_DIR)/stm32f4xx_hal_.c

# add BSP source file's
BSP_DIR=/media/WIN_D/Micro_Cirquit/ARM/STM32Cube_FW_F4_V1.13.0/Drivers/BSP/STM32F4-Discovery/
BSP_FILES=$(BSP_DIR)/stm32f4_discovery.c
#BSP_FILES += $(BSP_DIR)/stm32f4_discovery_accelerometer.c
#BSP_FILES += $(BSP_DIR)/stm32f4_discovery_audio.c


# Put your source files here (or *.c, etc)
SRCS=src/main.c src/system_stm32f4xx.c src/stm32f4xx_it.c src/stm32f4xx_hal_msp.c $(HAL_FILES) $(BSP_FILES)

# Put your stlink folder here so make burn will work.
STLINK=$(HOME)/STM32/stlink-master


# Normally you shouldn't need to change anything below this line!
#######################################################################################

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

# linker file "stm32_flash.ld"
CFLAGS  = -g -O2 -Wall -Tstm32_flash.ld
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I.

# Include files from STM libraries
# user "*.h" HEADER file's
CFLAGS += -I$(HOME)/git/stm32/${PROJ_NAME}/inc/
# add periphery device on STM32-Discovery Kit
CFLAGS += -I$(STM_COMMON)/Drivers/BSP/STM32F4-Discovery/
# add CMSIS library
CFLAGS += -I$(STM_COMMON)/Drivers/CMSIS/Include -I$(STM_COMMON)/Drivers/CMSIS/Device/ST/STM32F4xx/Include/
# add SPL library
#media/WIN_D/Micro_Cirquit/ARM/STM32F4xx_DSP_StdPeriph_Lib_V1.7.1/Libraries/STM32F4xx_StdPeriph_Driver/
CFLAGS += -I/media/WIN_D/Micro_Cirquit/ARM/STM32F4xx_DSP_StdPeriph_Lib_V1.7.1/Libraries/STM32F4xx_StdPeriph_Driver/inc
#add HAL library
CFLAGS += -I$(STM_COMMON)/Drivers/STM32F4xx_HAL_Driver/Inc/

# add startup file to build
SRCS += $(STM_COMMON)/Projects/STM32F4-Discovery/Templates/SW4STM32/startup_stm32f407xx.s
OBJS = $(SRCS:.c=.o)


.PHONY: proj

all: proj

proj: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ 

	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# Flash the STM32F4
burn: proj
	$(STLINK)/st-flash write $(PROJ_NAME).bin 0x8000000
