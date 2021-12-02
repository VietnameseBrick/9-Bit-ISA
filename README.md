# 9-Bit-Instruction-Set-Architecture

# Implementation: 
Our machine code reads in a singular opcode, 3-4 instruction bits, and
a register or immediate depending on the opcode input. We have two dictionaries called
instructions and registers. One contains the keywords to translate instruction words to the
corresponding bit equivalent. We receive the instructions from a text file and read it line
by line. Since our instructions only accept one input, we split each line in half via
whitespace in a list called currentInstruction. We call instruction.get(currentLine[0]) to
read the first half which converts the word to its appropriate bits (ex: mov translates to
00001). Our registers dictionary converts the register number to its bit equivalent. We use
currentInstruction[0] to check if the opcode bit is 0 or 1. If the value is 0, we know the
second input is a register, otherwise, we are reading in an immediate.
# Translations: 
We only have one branch instruction called bezr (branch equals zero
register). This checks if the accumulator is equal to zero. It then jumps to the register
value which represents the address we want to jump to, but it is a signed value that must
be translated then added to PC
