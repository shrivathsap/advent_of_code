import re

corrupted_memory = ""#"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

with open("day3.txt", "r") as f:
    corrupted_memory = f.read()

#just regular expressions. \d{1,3} is needed because question says the numbers have 1-3 digits
#but [0-9]* also works fine and is what I did first because there are no 4 or higher digit numbers
list_of_muls = re.findall(r"mul\(\d{1,3},\d{1,3}\)", corrupted_memory)
all_instr = re.findall(r"mul\(\d{1,3},\d{1,3}\)|do\(\)|don\'t\(\)", corrupted_memory)
total = 0
for prod in list_of_muls:
    first = int(prod[4:-1].split(',')[0])
    second = int(prod[4:-1].split(',')[1])
    total += first*second

proper_total = 0
mult_enabled = True
for item in all_instr:
    if item[:3] == 'mul' and mult_enabled == True:
        first = int(item[4:-1].split(',')[0])
        second = int(item[4:-1].split(',')[1])
        proper_total += first*second
    elif item == 'don\'t()':
        mult_enabled = False
    elif item == 'do()':
        mult_enabled = True
    else:
        pass

print(total)
print(proper_total)
