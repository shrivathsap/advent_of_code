def draw(grid):
    print("\n".join(grid))

def dijkstra(maze, start, end):
    nodes = [(x, y) for x in range(len(maze)) for y in range(len(maze[0])) if maze[x][y]!="#"]#corners(maze, len(maze), len(maze[0]))
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
        next_nodes = [n for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)] if maze[n[0]][n[1]] != "#"]#get_next(maze, current, nodes)
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
    return current, weights[current], visited

with open("day18.txt", "r") as f:
    coords = [(int(x.split(',')[1]), int(x.split(',')[0])) for x in f.read().split("\n")]

rnum = 72
cnum = 72
start = (1, 1)
end = (71, 71)

lower = 1024
upper = len(coords)

grid = []
kb = coords[:lower]
grid.append("#"*73)
for i in range(71):
    new_row = ""
    for j in range(71):
        if (i, j) in kb:
            new_row += "#"
        else:
            new_row += "."
    grid.append("#"+new_row+"#")
grid.append("#"*73)
a, b, sol = dijkstra(grid, start, end)
print(a, b)#part one solution

while upper-lower>10:
    mid = lower+(upper-lower)//2
    cutoff = mid
    grid = []
    kb = coords[:cutoff]
    grid.append("#"*73)
    for i in range(71):
        new_row = ""
        for j in range(71):
            if (i, j) in kb:
                new_row += "#"
            else:
                new_row += "."
        grid.append("#"+new_row+"#")
    grid.append("#"*73)

    a, b, spots = dijkstra(grid, start, end)
    if end in spots.keys():
        lower = mid
        upper = upper
    else:
        lower = lower
        upper = mid

for cutoff in range(lower-1, upper+1):
    grid = []
    kb = coords[:cutoff]
    grid.append("#"*73)
    for i in range(71):
        new_row = ""
        for j in range(71):
            if (i, j) in kb:
                new_row += "#"
            else:
                new_row += "."
        grid.append("#"+new_row+"#")
    grid.append("#"*73)


    a, b, spots = dijkstra(grid, start, end)
    if end in spots.keys():
        continue
    else:
        print(coords[cutoff-1])#part two solution, the x, y coords are interchanged...
        break
            


