def fits(lock, key, rows = 7, cols = 5):
    fits = True
    for i in range(cols):
        if lock[i]+key[i]>rows:
            fits = False
            break
    return fits

def locks_and_keys(items, rows, cols):
    keys = []
    locks = []
    for item in items:
        lines = item.split("\n")
        heights = [len([lines[r][c] for r in range(rows) if lines[r][c]=='#']) for c in range(cols)]
        if lines[0][0]=='#':
            locks.append(heights)
        else:
            keys.append(heights)
    return locks, keys
    
def part_one(locks, keys, rows = 7, cols = 5):
    pairs = []
    for lock in locks:
        for key in keys:
            if fits(lock, key, rows, cols):
                pairs.append((lock, key))
    return pairs 

with open("day25.txt", "r") as f:
    things = f.read().split("\n\n")

rnum = 7
cnum = 5
locks, keys = locks_and_keys(things, rnum, cnum)
fitting_pairs = part_one(locks, keys, rnum, cnum)
print(len(fitting_pairs))
