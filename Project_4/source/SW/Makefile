#  
#  COMMIT (Compiler & Micro-architecture)
#

    HOME=/home/compiler/work/riscv-gnu-toolchain/riscv
    LLVM=/home/compiler/work/llvm-project/build/bin
    RV=$(HOME)/bin
    AS=$(RV)/riscv32-unknown-elf-as
    LD=$(RV)/riscv32-unknown-elf-ld
    CLANG=$(LLVM)/clang
	CC=$(LLVM)/llc
    OPT=$(LLVM)/opt
    OBJDUMP=$(RV)/riscv32-unknown-elf-objdump
    OBJCOPY=$(RV)/riscv32-unknown-elf-objcopy
    ASFLAGS= -g -march=rv32im
    LDFLAGS= -N -X -T sections.lds
    CCFLAGS= -S -emit-llvm
    TARGET=riscv32
    MARCH=rv32im
    FEATURE=+m
    OPTLEVEL=0
    SRC=conv
    OPT_SRC=$(SRC)


    all: main_code 

    #############################
    ####  Test 1
    #############################

    main_code: $(OPT_SRC).o init.o
	$(LD) $(LDFLAGS) init.o $(OPT_SRC).o -o out 
	$(OBJDUMP) -D  out > out.dump
	$(OBJCOPY) -O  binary out out.bin
	./bin2hex_out.perl > out.hex

    $(OPT_SRC).o: $(SRC).c
	$(CLANG) $(CCFLAGS) -fno-builtin -march=$(MARCH) -O$(OPTLEVEL) --target=$(TARGET) $(SRC).c
	$(CC) -mattr=$(FEATURE) $(OPT_SRC).ll
	$(AS) $(ASFLAGS) $(OPT_SRC).s -o $(OPT_SRC).o
#	$(AS) $(ASFLAGS) -mabi=$(MABI) $(OPT_SRC).s -o $(OPT_SRC).o


    init.o: init.S
	$(AS) $(ASFLAGS) init.S -o init.o

    clean:
	rm -rf *.o *.dump *.hex *.bin out *.ll *.s *.bc
