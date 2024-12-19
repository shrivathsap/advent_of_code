import time
def starts_with(towel, pattern):
    return pattern==towel[:len(pattern)]

def is_possible(towel, patterns):
    possible = False
    for p in patterns:
        if towel == "":
            possible = True
            break
        elif towel == p:
            possible = True
            break
        elif starts_with(towel, p):
            if is_possible(towel[len(p):], patterns):
                possible = True
                break
            else:
                continue
        else:
            continue
    return possible

def update_possibilities(towel, patterns, current):#assume patterns is sorted by length
    next_ = {}
    for s in current.keys():
        for p in patterns:
            if s+p in current.keys():
                current[s+p]+=current[s]
    for s in current.keys():
        if s == towel:
            next_[s] = current[s]
        else:
            for p in patterns:
                if s+p not in current.keys():
                    if starts_with(towel, s+p) and is_possible(towel[len(s+p):], patterns):
                        if s+p in next_.keys():
                            next_[s+p] += current[s]
                        else:
                            next_[s+p] = current[s]
    return dict(sorted(next_.items(), key=lambda item: len(item[0])))

def part_one(towels, patterns):
    return [towel for towel in towels if is_possible(towel, patterns)]

def part_two(towel, patterns):
    current = {p:1 for p in sorted(patterns, key=len) if (starts_with(towel, p) and is_possible(towel[len(p):], patterns))}
    while len(current.keys())!= 1 or towel not in current.keys():
        current = update_possibilities(towel, patterns, current)
    return current

def part_two_total(good_towels, patterns):
    score = 0
    for towel in good_towels:
        score += part_two(towel, patterns)[towel]
    return score

with open("day19.txt", "r") as f:
    lines = f.read().split("\n\n")

pattern_list = lines[0].split(", ")
towels = lines[1].split("\n")
start = time.time()
good_towels = part_one(towels, pattern_list)
print(len(part_one(towels, pattern_list)))
print(part_two_total(good_towels, pattern_list))
print(time.time()-start)
