def draw(grid):
    print("\n".join(grid))

def is_corner(maze, pos):
    x, y = pos[0], pos[1]
    if maze[x][y] == "#":
        return False
    else:
        #two roads diverged in a yellow wood
        roads = [n for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)] if maze[n[0]][n[1]] == "."]
        if len(roads) >2:
            return True
        elif len(roads) == 2 and (roads[0][0]!=roads[1][0]) and (roads[0][1]!=roads[1][1]):
            return True
        else:
            return False

def corners(maze, rows, cols):
    return [(x, y) for x in range(rows) for y in range(cols) if is_corner(maze, (x, y))]

def seats_between(pos1, pos2):
    x1, y1 = pos1[0], pos1[1]
    x2, y2 = pos2[0], pos2[1]
    if (x1!=x2) and (y1!=y2):
        return []
    elif (x1==x2) and (y1!=y2):
        return [(x1, y) for y in range(min(y1, y2), max(y1, y2)+1)]
    elif (x1!=x2) and (y1==y2):
        return [(x, y1) for x in range(min(x1, x2), max(x1, x2)+1)]
    else:
        return [(x1, y1)]

def get_next(maze, node, corners):#node is assumed to be a corner
    dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    x, y = node[0], node[1]
    next_corners = []
    for (dx, dy) in dirs:
        i = 1
        while maze[x+i*dx][y+i*dy] != "#":#move until you hit a wall
            if (x+i*dx, y+i*dy) in corners:
                next_corners.append((x+i*dx, y+i*dy))
            else:
                pass
            i+=1
    return next_corners

def dijkstra(maze, start, end, init_dir = (0, 1)):
    nodes = corners(maze, len(maze), len(maze[0]))
    if start not in nodes:
        nodes.append(start)
    if end not in nodes:
        nodes.append(end)
    dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    weights = {(x, y):float('inf') for x in nodes for y in dirs}
    visited = {}
    weights[(start, init_dir)] = 0
    current = (start, init_dir) #min(weights, key=weights.get)
    while current[0] != end:
        (dx, dy) = current[1]
        next_nodes = get_next(maze, current[0], nodes)
        for n in next_nodes:
            for (x, y) in dirs:
                if (n, (x, y)) in weights.keys():
                    xdiff = n[0]-current[0][0]
                    ydiff = n[1]-current[0][1]
                    xdir, ydir = xdiff//(abs(xdiff)+abs(ydiff)), ydiff//(abs(xdiff)+abs(ydiff))
                    
                    cost = abs(xdiff)+abs(ydiff)+1000*(1-(dx*xdir)-(dy*ydir))+1000*(1-(x*xdir)-(y*ydir))
                    weights[(n, (x, y))] = min(weights[(n, (x, y))], weights[current]+cost)
        for (x, y) in dirs:
            if (current[0], (x, y)) in weights.keys():
                cost = 1000*(1-(dx*x)-(dy*y))
                weights[(current[0], (x, y))] = min(weights[(current[0], (x, y))], weights[current]+cost)
        visited[current] = weights[current]
        del weights[current]
        current = min(weights, key=weights.get)
    visited[current] = weights[current]
    return current, weights[current], visited


def dijkstra2(maze, start, end, init_dir = (0, 1)):
    nodes = corners(maze, len(maze), len(maze[0]))
    if start not in nodes:
        nodes.append(start)
    if end not in nodes:
        nodes.append(end)
    dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    #a dictionary that has the cost to reach a vertex and a list of vertices to reach it from with minimal cost
    weights = {(x, y):(float('inf'), None) for x in nodes for y in dirs}
    visited = {}#a dictionary of visited vertices with the same data
    weights[(start, init_dir)] = (0, [(start, init_dir)])#initialize
    current = (start, init_dir)
    while current[0] != end:
        (dx, dy) = current[1]#current direction
        next_nodes = get_next(maze, current[0], nodes)
        for n in next_nodes:#update the distance to the next nodes
            for (x, y) in dirs:
                if (n, (x, y)) in weights.keys():
                    #find the x and y offset, then normalize to get direction
                    xdiff = n[0]-current[0][0]
                    ydiff = n[1]-current[0][1]
                    xdir, ydir = xdiff//(abs(xdiff)+abs(ydiff)), ydiff//(abs(xdiff)+abs(ydiff))
                    #linear distance plus the total cost of turning given by the offset of a dot product
                    cost = abs(xdiff)+abs(ydiff)+1000*(1-(dx*xdir)-(dy*ydir))+1000*(1-(x*xdir)-(y*ydir))
                    #if the cost is the same, then include the current point
                    if weights[(n, (x, y))][0]==weights[current][0]+cost:
                        #this next line is there so that if the present point is actually on the way
                        #to the target from a previous point, then there's no point in including it
                        #this is useful when backtracking
                        if not [t for t in weights[(n, (x, y))][1] if t in weights[current][1]]:
                            weights[(n, (x, y))] = (weights[current][0]+cost, weights[(n, (x, y))][1]+[current])
                    #if the cost is minimized, then replace the list by only the current point
                    elif weights[(n, (x, y))][0]>weights[current][0]+cost:
                        weights[(n, (x, y))] = (weights[current][0]+cost, [current])
                    else:
                        pass
        #code block to handle turnings at the same location                          
        for (x, y) in dirs:
            if (current[0], (x, y)) in weights.keys():
                cost = 1000*(1-(dx*x)-(dy*y))
                if weights[(current[0], (x, y))][0]> weights[current][0]+cost:
                    weights[(current[0], (x, y))] = (weights[current][0]+cost, [current])
        #remove current from unvisited list
        visited[current] = weights[current]
        del weights[current]
        current = min(weights, key=lambda x:weights[x][0])
    #adding the end point
    visited[current] = weights[current]
    return current, weights[current], visited

def backtrack(maze, nodes, visited, start, end, init_dir = (0, 1)):
    seats = []
    current_layer = [max(visited, key=lambda x:visited[x][0])]
    visited_nodes = set([x[0] for x in visited.keys()])
    checked = [end]
    while start not in checked:
        for x in current_layer:
            prev_layer = visited[x][1]
            for pos in prev_layer:
                seats += seats_between(x[0], pos[0])            
            checked += list(set([pos[0] for pos in prev_layer]))
        current_layer = list(set([y for x in current_layer for y in visited[x][1]]))
    return set(seats)            

def solve(maze, start, end):
    nodes = corners(maze, len(maze), len(maze[0]))
    if start not in nodes:
        nodes.append(start)
    if end not in nodes:
        nodes.append(end)
    paths = [[start]]
    solutions = []
    found = False
    while not found:#any(end in x for x in paths):
        new_paths = []
        for path in paths:
            last = path[-1]
            next_corners = get_next(maze, last, nodes)
            if end in next_corners:
                found = True
                solutions+=[path+[end]]
            new_paths += [path + [n] for n in next_corners]
        paths = new_paths
    return solutions

def linear_length(path):
    score = 0
    current = path[0]
    for node in path:
        score += abs(node[0]-current[0])+abs(node[1]-current[1])
        current = node
    return score

def min_length(paths):
    best_path = []
    current_min = float('inf')
    for path in paths:
        score = linear_length(path)
        if score<current_min:
            current_min = score
            best_path = path
    return best_path, current_min

with open("day16.txt", "r") as f:
    grid = f.read().split("\n")

rnum = len(grid)
cnum = len(grid[0])
start = (rnum-2, 1)#could write a function to generate this, but I looked at the input
end = (1, cnum-2)
score = 0
init_dir = (0, 1)
all_corners = corners(grid, rnum, cnum)
a, b, finals = dijkstra2(grid, start, end)
tiles = backtrack(grid, all_corners, finals, start, end)
print(a, b, len(finals), len(tiles))
