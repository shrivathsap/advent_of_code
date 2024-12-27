import re

with open("day06.txt", "r") as f:
    instructions = f.read().split("\n")

def update_brightness(config, inst):
    print(inst)
    nums = [int(x) for x in re.findall(r"\d+", inst)]
    x0, y0 = nums[0], nums[1]
    x1, y1 = nums[2], nums[3]
    region = [(x, y) for x in range(x0, x1+1) for y in range(y0, y1+1)]
    if inst.startswith("turn on"):
        for p in region:
            if p in config.keys():
                config[p]+=1
            else:
                config[p] = 1
    elif inst.startswith("turn off"):
        for p in region:
            if p in config.keys():
                if config[p] > 1:
                    config[p] -= 1
                else:
                    config[p] = 0
    else:
        for p in region:
            if p in config.keys():
                config[p] += 2
            else:
                config[p] = 2
    return config

initial = {}
for i in instructions:
    initial = update_brightness(initial, i)
print(sum([initial[x] for x in initial.keys()]))
    
    
