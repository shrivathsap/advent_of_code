import hashlib

def md5(string):
    return hashlib.md5(string.encode('utf-8')).hexdigest()

start = "input"#goes here
count = 0

track = []
found = []
track2 = []
found2 = []

def has_triple(s):
    for i in range(len(s)-2):
        if (s[i]==s[i+1]) and (s[i]==s[i+2]):
            return True, s[i]
    return False, "0"

def has_quintuple(s, letter):
    for i in range(len(s)-4):
        if s[i:i+5]==letter*5:
            return True
    return False


#part one
def part_one():
    for i in range(10000000):
        to_check = md5(start+str(i))
        triple, letter = has_triple(to_check)
        if triple:
            track.append([to_check, i, letter])
        for x in track:
            if x[1]<i<=(x[1]+1000) and has_quintuple(to_check, x[2]):
                found.append((x[1], x[0]))
        if len(found) >= 64:
            print(sorted([x[0] for x in found])[63])
            break

#part two
def part_two():
    for i in range(50000000):
        to_check = start+str(i)
        for j in range(2017):
            to_check = md5(to_check)

        triple, letter = has_triple(to_check)
        if triple:
            track2.append([to_check, i, letter])
        for x in track2:
            if x[1]<i<=(x[1]+1000) and has_quintuple(to_check, x[2]):
                found2.append((x[1], x[0]))
        if len(found2) >= 64:
            print(sorted([x[0] for x in found2])[63])
            break
        
part_one()
part_two()