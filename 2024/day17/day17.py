A = 'A'; B = 'B'; C = 'C'
registers = {'A':0, 'B':0, 'C':0}
binary = {0:'000', 1:'001', 2:'010', 3:'011',
          4:'100', 5:'101', 6:'110', 7:'111'}
inv_bin = {v:k for k, v in binary.items()}
   

inst_pointer = 0
move = True
output = ""
program = []
opoutput = "".join([str(x) for x in program])

def combo(bit):
    if bit in [0, 1, 2, 3]: return bit
    elif bit==4: return registers[A]
    elif bit==5: return registers[B]
    else: return registers[C]

def adv(bit):
    registers[A] = registers[A]//(2**(combo(bit)))

def bxl(bit):
    registers[B] = registers[B]^bit


def bst(bit):
    registers[B] = combo(bit)%8

def jnz(bit):
    global inst_pointer, move
    if registers[A]==0:
        pass
    else:
        inst_pointer = bit
        move = False

def bxc(bit):
    registers[B] = registers[B]^registers[C]

def out(bit):
    global output
    output += ","+str(combo(bit)%8)

def bdv(bit):
    registers[B] = registers[A]//(2**(combo(bit)))
    
def cdv(bit):
    registers[C] = registers[A]//(2**(combo(bit)))

opcodes = {0:adv, 1:bxl,
           2:bst, 3:jnz,
           4:bxc, 5:out,
           6:bdv, 7:cdv}

while inst_pointer < len(program):
    opcodes[program[inst_pointer]](program[inst_pointer+1])
    if move:
        inst_pointer += 2
    else:
        move = True

solutions = ['']
while opoutput != "":
    new_solutions = []
    target = int(opoutput[-1])
    print(target, opoutput)
    for stringA in solutions:
        for b in range(0, 8):
            to_drop = b^1
            s = 0
            if to_drop>3:
                s = inv_bin[('0'*(3-len(stringA[:-(to_drop-3)][-3:])))+stringA[:-(to_drop-3)][-3:]]
            elif to_drop == 3:
                s = inv_bin[('0'*(3-len(stringA[-3:])))+stringA[-3:]]
            elif to_drop == 2:
                s = inv_bin[(('0'*(2-len(stringA[-2:])))+stringA[-2:]+binary[b][0])]
            elif to_drop == 1:
                s = inv_bin[(('0'*(1-len(stringA[-2:])))+stringA[-1:]+binary[b][:2])]
            else:
                s = b
            if (b^4)^s == target:
                new_solutions.append(stringA + binary[b])
            else:
                pass
    opoutput = opoutput[:-1]
    solutions = new_solutions

print(min([int(x, 2) for x in solutions]))
print(output[1:])  
