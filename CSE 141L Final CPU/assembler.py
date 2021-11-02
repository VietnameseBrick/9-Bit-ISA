instruction = {
    'seti': '100',
    'sliz': '101',
    'slti': '110',
    'add': '00000',
    'mov': '00001',
    'halt': '00010',
    'slt': '00011',
    'set': '00100',
    'sub': '00101',
    'sll': '00110',
    'twosComp': '00111',
    'or': '01000',
    'slr': '01001',
    'bezr': '01010',
    'sw': '01011',
    'ld': '01100'
    }

registers = {
    '$r0': '0000',
    '$r1': '0001',
    '$r2': '0010',
    '$r3': '0011',
    '$r4': '0100',
    '$r5': '0101',
    '$r6': '0110',
    '$r7': '0111',
    '$r8': '1000',
    '$r9': '1001',
    '$r10': '1010',
    '$r11': '1011',
    '$r12': '1100',
    '$r13': '1101',
    '$r14': '1110',
    '$r15': '1111'
    }

def main():  
    convertMachineCode()



def convertMachineCode():

    # Using readlines()
    file1 = open('machineCode.txt', 'r')
    outF = open("machineBinary.txt", "w")
    Lines = file1.readlines() 
  
    count = 0
    # Strips the newline character 
    for line in Lines: 
        currentLine = line.split(" ")
        currentInstruction = instruction.get(currentLine[0])
        registerToRead = currentLine[1].replace("\n","")
        
        register = ''
        machineCode = ''
        immediate = ''     
        
        if currentInstruction[0] == '0':
            register = registers.get(registerToRead)
            machineCode = currentInstruction + register

        elif currentInstruction[0] == '1':
            immediate = int(currentLine[1])
            immediateBin = bin(immediate).replace("0b", "")
            stringImmediate = str(immediateBin)
            finalImmediate = stringImmediate.zfill(6)
            machineCode = currentInstruction + finalImmediate


        outF.write(machineCode)
        outF.write("\n")

    outF.close()
                

if __name__ == "__main__":
    main()