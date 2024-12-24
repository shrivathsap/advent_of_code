with open("day24.txt", "r") as f:
    parts = f.read().split("\n\n")
data = parts[0].split("\n")
inst = parts[1].split("\n")
data_dict = {x.split(": ")[0]:int(x.split(": ")[1]) for x in data}
inst_split = [x.split(" ") for x in inst]
inst_dict = {x[-1]:(x[0], x[2], x[1]) for x in inst_split}

def part_one(values, targets):
    data_dict = {x:values[x] for x in values.keys()}#don't want to affect the input dictionaries, so making a copy
    inst_dict = {x:targets[x] for x in targets.keys()}
    while inst_dict.keys():
        to_delete = []
        for target in inst_dict.keys():
            if inst_dict[target][0] in data_dict.keys() and inst_dict[target][1] in data_dict.keys():
                op = inst_dict[target][2]
                if op == "AND":
                    data_dict[target] = data_dict[inst_dict[target][0]] & data_dict[inst_dict[target][1]]
                elif op == "OR":
                    data_dict[target] = data_dict[inst_dict[target][0]] | data_dict[inst_dict[target][1]]
                elif op == "XOR":
                    data_dict[target] = data_dict[inst_dict[target][0]] ^ data_dict[inst_dict[target][1]]
                else:
                    raise Exception("Unknown operation")
                to_delete.append(target)
        for item in to_delete:
            del inst_dict[item]

    answer_string = ""
    for x in sorted(list(data_dict.keys()))[::-1]:#z00 is least significant
        if x[0]=='z':
            answer_string += str(data_dict[x])
    return data_dict, int(answer_string, 2)


def modding(num1, num2, instructions = inst_dict):
    converted1 = (bin(num1)[2:])[-45:]
    converted2 = (bin(num2)[2:])[-45:]
    string1 = '0'*(45-len(converted1))+converted1
    string2 = '0'*(45-len(converted2))+converted2
    loading_data = {}
    for i in range(45):
        loading_data['x'+('0'*(2-len(str(i))))+str(i)] = int(string1[-1-i])
        loading_data['y'+('0'*(2-len(str(i))))+str(i)] = int(string2[-1-i])
    final_dict, answer = part_one(loading_data, instructions)
##    print("Adding", int(string1, 2), int(string2, 2), "gives", answer)
    if answer != num1+num2:
        return [x for x in final_dict if final_dict[x]==1], False
    else:
        return [x for x in final_dict if final_dict[x]==1], True

def swap(bit1, bit2, instructions):
    new_instructions = {}
    for x in instructions:
        if x==bit1:
            new_instructions[bit2]=instructions[x]
        elif x==bit2:
            new_instructions[bit1]=instructions[x]
        else:
            new_instructions[x]=instructions[x]
    return new_instructions

'''The bits zij should look like (somthing)XOR(something), where one of these should be xij OR yij (the units place) and the other is the total carry
to that bit.
Looking through my input, z08, z28, z39 aren't like this which means they should be swapped with something else.
First place where 0+2**i failed was i=8, here it turned out that vvr and z08 were swapped.
The next place it happened was at i=16, where rnq held the carry and bkr held the units place but these two should have been swapped.
The next place it happened was i=28, as expected. Here ptk held x28 XOR y28 and tfb involved ptk and XOR. So, tfb and z28 were swapped.
Next was i=39. Repeat the steps for i=28. wnk held x39 XOR y39 and mhq had wnk XOR ...
'''

new_inst = swap('z08', 'vvr', inst_dict)
new_inst = swap('rnq', 'bkr', new_inst)
new_inst = swap('z28', 'tfb', new_inst)
new_inst = swap('z39', 'mqh', new_inst)
units_place = [x for x in inst_dict if (inst_dict[x][0][0]=='x' or inst_dict[x][0][0]=='y') and (inst_dict[x][1][0]=='x' or inst_dict[x][1][0]=='y')]
other_xors = [x for x in inst_dict if 'XOR' in inst_dict[x] and x not in units_place and x[0]!='z']
print(other_xors)

#to find first bit of failure
for i in range(45):
    a, b = modding(0, 2**i, new_inst)
    if not b:
        print(i, modding(0, 2**i, new_inst))
        break

solution = sorted(['z08', 'vvr', 'rnq', 'bkr', 'z28', 'tfb', 'z39', 'mqh'])
final_values, part_one_solution = part_one(data_dict, inst_dict)
print(part_one_solution)
print(",".join(solution))
