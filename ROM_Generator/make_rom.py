#!/usr/bin/python3

#
# This is more or less taken verbatim from Ben Eater:
# http://eater.net/6502
#


# Machine code for the program.
code = bytearray ([
	0xa9, 0xff,	    #lda $#ff
	0x8d, 0x02, 0x60,   #sta $6002

	# Store LED pattern 1 (0x55) to $6000:
	0xa9, 0x55,	    #lda $#ff (0b01010101)
	0x8d, 0x00, 0x60,   #sta $6000

	# Store LED pattern 2 (0xAA) to $6002:
	0xa9, 0xaa,         #lda $#aa (0b10101010)
        0x8d, 0x00, 0x60,   #sta $6000
	
	# 10 GOTO 10:
	0x4c, 0x05, 0x80    #jmp $8005
])

# Write NOP instructions for everything but our code.
rom = code + bytearray([0x00] * (32768 - len(code)))

# Add reset vector.
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

# Add NMIB vector.
#rom[0x7ffa] = 0x00
#rom[0x7ffb] = 0x00

# Add IRQB vector.
#rom[0x7ffe] = 0x00
#rom[0x7fff] = 0x00

# Write to binary file.
with open("rom.bin", "wb") as file_out:
	file_out.write(rom)

