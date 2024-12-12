def blink(stone):
    if stone == '0':
        return '1'
    elif len(stone)%2 == 0:
        left = str(int(stone[:len(stone)//2]))
        right = str(int(stone[len(stone)//2:]))
        return [left, right]
    else:
        return [str(2024*int(stone))]

with open("day11.txt", "r") as f:
    stones = (f.read().split("\n")[0]).split(" ")

stone_dict = {}
for stone in stones:
    if stone in stone_dict.keys():
        stone_dict[stone]+=1
    else:
        stone_dict[stone] = 1
for i in range(75):
    new_stone_dict = {}
    for stone in stone_dict.keys():
        for new_stone in blink(stone):
            if new_stone in new_stone_dict.keys():
                new_stone_dict[new_stone] += stone_dict[stone]
            else:
                new_stone_dict[new_stone] = stone_dict[stone]
    stone_dict = new_stone_dict
print(sum([stone_dict[x] for x in stone_dict.keys()]))
