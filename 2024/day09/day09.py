import time
from dataclasses import dataclass

@dataclass
class block:
    size: int
    start: int
    label: str
    is_num: bool

def block_sum(b):
    if b.is_num:
        return sum([i*int(b.label) for i in range(b.start, b.start+b.size)])
    else:
        return 0

def generate_blocks(string):
    block_list = [block(int(string[0]), 0, label='0', is_num = True)]
    for i in range(1, len(string)):
        start = block_list[-1].start+block_list[-1].size
        size = int(string[i])
        is_num = not bool(i%2)
        label = str(i//2) if is_num else '.'
        if size != 0:
            block_list.append(block(size, start, label, is_num))
    return block_list

def move_bits(block_list):
    result = []
    for b in block_list:
        if b.is_num:
            result.append(b)
        else:
            for c in block_list[::-1]:
                if c.is_num and c.start>b.start and b.size>0:
                    if c.size>b.size:
                        result.append(block(b.size, b.start, c.label, True))
                        c.size -= b.size
                        b.start += b.size
                        b.size -= b.size
                    else:
                        result.append(block(c.size, b.start, c.label, True))
                        c.label = '.'
                        c.is_num = False
                        b.start += c.size
                        b.size -= c.size
    return(result)

def move_files(block_list):
    result = []
    for b in block_list:
        if b.is_num:
            result.append(b)
        else:
            for c in block_list[::-1]:
                if c.is_num and c.size<=b.size and c.start>b.start:
                    result.append(block(c.size, b.start, c.label, True))
                    c.label = '.'
                    c.is_num = False
                    b.start += c.size
                    b.size -= c.size
    return(result)

def draw(block_list):
    string = ""
    for b in block_list:
        string += b.size*b.label
    return string
        
with open("day9.txt", "r") as f:
    line = f.read().split("\n")[0]
start = time.time()
a = generate_blocks(line)
b = move_bits(a)
print(sum([block_sum(x) for x in b]))
print(time.time()-start)
