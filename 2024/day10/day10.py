def find_trailheads(grid):
    trailheads = []
    numr = len(grid)
    numc = len(grid[0])
    for i in range(numr):
        for j in range(numc):
            if grid[i][j]=='0':
                trailheads.append((i, j))
    return trailheads

def find_next(pos, grid):
    next_pos = []
    x, y = pos[0], pos[1]
    numr, numc = len(grid), len(grid[0])
    height = int(grid[x][y])
    neighbours = [(x-1, y), (x, y+1), (x+1, y), (x, y-1)]
    for neighbour in neighbours:
        if (0<=neighbour[0]<numr) and (0<=neighbour[1]<numc):
            if int(grid[neighbour[0]][neighbour[1]]) == height+1:
                next_pos.append(neighbour)
    return list(set(next_pos)) #remove list(set) for part 2

with open("day10.txt", "r") as f:
    grid = f.read().split("\n")
trailheads = find_trailheads(grid)
score = 0
for trailhead in trailheads:
    trails = [trailhead]
    for i in range(0, 9):
        trails = [y for x in trails for y in find_next(x, grid)]
    score+= len(trails)

print(score)