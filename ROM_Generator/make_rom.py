#!/usr/bin/python3

# Machine code for the program.
code = bytearray {[
	0xa9, 0xff,    #lda $#ff
]}

# Write NOP instructions for everything but our code.
rom = bytearray([0xea] * (32768 - len(code)))

# Add reset vector.
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

# Add NMIB vector.

# Add IRQB vector.

# Write to binary file.
with open("rom.bin", "wb") as file_out:
	file_out.write(rom)

