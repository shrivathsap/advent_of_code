import time
steps = 6
rules = {"A": [(1,1,"B"),(0,-1,"B")],
         "B": [(1,-1,"A"),(1,1,"A")]}
tape = {}
init_on = []
init_state = "A"
init_pos = 0

def turing(ones, state, pos):
    cur_val = 1 if pos in ones else 0
    (new_val, dx, new_state) = rules[state][cur_val]
    if new_val == 1:
        ones += [pos]
    else:
        ones = [x for x in ones if x!=pos]
    return ones, new_state, (pos+dx)
    
def turing2(tape, state, pos):
    cur_val = tape[pos] if pos in tape.keys() else 0
    (new_val, dx, new_state) = rules[state][cur_val]
    tape[pos] = new_val
    return tape, new_state, (pos+dx)

def part_one():
    global init_on, init_state, init_pos, steps
    for i in range(steps):
        init_on, init_state, init_pos = turing(init_on, init_state, init_pos)
    print(len(init_on))

def part_one2():
    global tape, init_state, init_pos, steps
    for i in range(steps):
        tape, init_state, init_pos = turing2(tape, init_state, init_pos)
    print(sum(tape.values()))

s = time.time()
part_one2()
print(time.time()-s)
