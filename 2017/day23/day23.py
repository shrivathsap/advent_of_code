lines = []

regs = {"a":0,"b":0,"c":0,"d":0,"e":0,"f":0,"g":0,"h":0}

with open("day23.txt", 'r') as f:
    for line in f:
        if line[-1]=='\n':
            line = line[:-1]
        lines.append(line)

def is_prime(num):
    prime = True
    for j in range(2, num):
        if num%j==0:
            prime = False
            break
    return prime

def part_one():
    pointer = 0
    count = 0
    N = len(lines)
    s = 0
    while pointer>=0 and pointer<N:
        s += 1
        if s%10000==0:
            print(s)
    ##    print(regs, pointer)
        inst = lines[pointer].split(' ')
        cmd = inst[0]
        reg = inst[1]
        if (inst[2] in regs.keys()):
            value = regs[inst[2]]
        else:
            value = int(inst[2])
        if cmd=="set":
            regs[reg] = value
            pointer += 1
        elif cmd=="sub":
            regs[reg] -= value
            pointer += 1
        elif cmd=="mul":
            regs[reg] *= value
            pointer += 1
            count += 1
        elif cmd=="jnz":
            to_jump = False
            if reg in regs.keys():
                to_jump = (regs[reg]!=0)
            else:
                to_jump = (reg != 0)
            if to_jump:
                pointer += value
            else:
                pointer += 1
        else:
            print("Command not found")
            break
    print(regs)
    print(count)


def part_two():
    b = (84*100)+100000
    c = (84*100)+100000+17000
    count = 0
    for i in range(b, c+1, 17):
        if not(is_prime(i)):
            count += 1
    print(count)
    
part_one()
part_two()
