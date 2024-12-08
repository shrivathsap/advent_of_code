def get_dict(grid):
    antenna_dict = {}
    rnum = len(grid)
    cnum = len(grid[0])
    for i in range(rnum):
        for j in range(cnum):
            ant = grid[i][j]
            if ant != ".":
                if ant not in antenna_dict.keys():
                    antenna_dict[ant] = [(i, j)]
                else:
                    antenna_dict[ant].append((i,j))
            else:
                pass
    return antenna_dict

def generate(list_of_tups, num_of_rows, num_of_cols, resonant = False):
    antinodes = []
    for pos1 in list_of_tups:
        for pos2 in list_of_tups:
            if (pos1 != pos2):
                x1 = pos1[0]
                y1 = pos1[1]
                x2 = pos2[0]
                y2 = pos2[1]
                for i in range(1, max([num_of_rows, num_of_cols])):
                    to_add = (x1+i*(x2-x1), y1+i*(y2-y1))
                    if (0<=x1+i*(x2-x1)<num_of_rows) and (0<=y1+i*(y2-y1)<num_of_cols) and (to_add not in antinodes):
                        if resonant:
                            antinodes.append(to_add)
                        else:
                            if i == 2:
                                antinodes.append(to_add)

    return antinodes

with open("day8.txt", "r") as f:
    grid = f.read().split("\n")

rnum = len(grid)
cnum = len(grid[0])
antenna_dict = get_dict(grid)
all_antinodes = []
for x in antenna_dict.keys():
    all_antinodes += generate(antenna_dict[x], rnum, cnum)
all_resonant_antinodes = []
for x in antenna_dict.keys():
    all_resonant_antinodes += generate(antenna_dict[x], rnum, cnum, True)
print(len(set(all_antinodes)))
print(len(set(all_resonant_antinodes)))
