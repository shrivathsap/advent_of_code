import time

def invert_grid(grid):
    new_grid = []
    new_grid.append("#"*(len(grid)+2))
    for row in grid:
        new_row = ""
        for c in row:
            if c == "#":
                new_row += "."
            else:
                new_row += "#"
        new_grid.append("#"+new_row+"#")
    new_grid.append("#"*(len(grid)+2))
    return new_grid

def dijkstra(maze, start, end):
    nodes = [(x, y) for x in range(len(maze)) for y in range(len(maze[0])) if maze[x][y]!="#"]
    if start not in nodes:
        nodes.append(start)
    if end not in nodes:
        nodes.append(end)
    weights = {x:float('inf') for x in nodes}
    visited = {}
    weights[start] = 0
    current = start
    while min(weights.values()) != float('inf') and current != end :
        x, y = current[0], current[1]
        next_nodes = [n for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)] if (maze[n[0]][n[1]] != "#" or n==end)]
        for n in next_nodes:
            if n in weights.keys():
                xdiff = n[0]-current[0]
                ydiff = n[1]-current[1]              
                cost = abs(xdiff)+abs(ydiff)
                weights[n] = min(weights[n], weights[current]+cost)
        visited[current] = weights[current]
        del weights[current]
        current = min(weights, key=weights.get)
    visited[current] = weights[current]
    return weights[current]

def find_ends(grid):
    start = (0, 0)
    end = (0, 0)
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "S":
                start = (i, j)
            elif grid[i][j] == "E":
                end = (i, j)
            else:
                continue
    return start, end

def get_path(grid, start, end):
    dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    x0, y0 = start[0], start[1]
    init_dir = (0, 0)
    for (dx, dy) in dirs:
        if grid[x0+dx][y0+dy] == ".":
            init_dir = (dx, dy)
    path_found = {start: (init_dir, 0)}
    current = start#path_found[-1]
    while current != end:
        (x, y) = current
        (a, b) = path_found[current][0]
        for (dx, dy) in dirs:
            if grid[x+a+dx][y+b+dy] == "." and (a, b)!= (-dx, -dy):
                path_found[(x+a, y+b)] = ((dx, dy), path_found[current][1]+1)
                current = (x+a, y+b)
            elif (x+a+dx, y+b+dy) == end:
                path_found[(x+a, y+b)] =((dx, dy), path_found[current][1]+1)
                path_found[end] = ((dx, dy), path_found[current][1]+2)
                current = end
            else:
                continue
    return path_found


def get_cheats(grid, start, end, path):
    cheats = []
    tiles = path.keys()
    length = path[end][1]
    dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    for (x, y) in tiles:
        for (a, b) in dirs:
            if grid[x+a][y+b] == "#":
                for (c, d) in dirs:
                    if (x+a+c, y+b+d) in tiles:
                        time_saved = path[(x+a+c, y+b+d)][1]-path[(x, y)][1]-2
                        if time_saved >= 100:
                            cheats.append([(x+a, y+b), (x+a+c, y+b+d), time_saved])
    return cheats

def get_longer_cheats(grid, path):
    inverted = invert_grid(grid)
    long_cheats = []
    for pointA in path.keys():
        for pointB in path.keys():
            if path[pointB][1]>=path[pointA][1]+50:
                cheat_time = dijkstra(inverted, (pointA[0]+1, pointA[1]+1), (pointB[0]+1, pointB[1]+1))
                if cheat_time<=20:
                    time_saved = path[pointB][1]-path[pointA][1]-cheat_time
                    if time_saved == 52:
                        long_cheats.append([pointA, pointB, time_saved])
    return long_cheats

def get_longer_cheats2(grid, path):
    long_cheats = []
    for pointA in path.keys():
        for pointB in path.keys():
            if path[pointB][1]>=path[pointA][1]+100:
                cheat_time = abs(pointB[0]-pointA[0])+abs(pointB[1]-pointA[1])
                if cheat_time<=20:
                    time_saved = path[pointB][1]-path[pointA][1]-cheat_time
                    if time_saved >= 100:
                        long_cheats.append([pointA, pointB, time_saved])
    return long_cheats


with open("day20.txt", "r") as f:
    grid = f.read().split("\n")

start, end = find_ends(grid)
path = get_path(grid, start, end)
s = time.time()
print(len(get_cheats(grid, start, end, path)))
print(len(get_longer_cheats2(grid, path)))
print(time.time()-s)

