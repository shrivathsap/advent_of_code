'''I first had various functions to add vectors, to check whether a position is within the bounds of an array etc.
I was also using lists. It turns out that it is far faster to use sets from the get go than to convert a list into a set,
and it's faster to not have functions but to simply do the thing you want to be done right where you want it to be done
rather than call a function. This program takes around 3.45 seconds to complete. My original attempt with lists and such never finished :/'''
obstacle = "#"
init_orientation = {"^":(-1, 0), ">":(0, 1), "v":(1, 0), "<":(0, -1)}
rotate = {(-1, 0):(0, 1), (0, 1):(1, 0), (1, 0):(0, -1), (0, -1):(-1, 0)}

def find_initial(grid):
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] not in ["#", "."]:
                return (i, j), init_orientation[grid[i][j]]

def possible(grid, initial_pos, direction, x, y):
    num_of_rows = len(grid)
    num_of_cols = len(grid[0])
    if grid[x][y] in ["#", "^", ">", "V", "<"]:
        return False
    else:
        current_pos = initial_pos
        current_dir = direction
        #turns out its faster to only keep track of obstacles visited
        obstacles_visited = set()
        while True:
            _next = (current_pos[0]+current_dir[0], current_pos[1]+current_dir[1])
            if not ((0<=_next[0]<num_of_rows) and (0<=_next[1]<num_of_cols)):
                return False
            elif (_next, current_dir) in obstacles_visited:
                return True
            elif grid[_next[0]][_next[1]] == "#" or _next == (x, y):
                obstacles_visited.add((_next,current_dir))
                current_dir = rotate[current_dir]
            else:
               current_pos = _next

with open("day6.txt", "r") as f:
    grid = f.read().split("\n")

num_of_rows = len(grid)
num_of_cols = len(grid[0])
start_pos, start_dir = find_initial(grid)
current_pos, current_dir = start_pos, start_dir
visited = set()
visited.add((current_pos, current_dir))

while True:
    _next = (current_pos[0]+current_dir[0], current_pos[1]+current_dir[1])
    if not ((0<=_next[0]<num_of_rows) and (0<=_next[1]<num_of_cols)):
        break
    elif grid[_next[0]][_next[1]] == "#":
        current_dir = rotate[current_dir]
    else:
       visited.add((_next,current_dir))
       current_pos = _next

#if position and direction were not tuples, this would throw an error because set([[1, 2], [2, 3]]) is wrong...
distinct_places = set([x[0] for x in visited])
obstacle_count = 0
#only need to put obstacles on the guard's path...
for pos in distinct_places:
    if possible(grid, start_pos, start_dir, pos[0], pos[1]):
        obstacle_count += 1

print(obstacle_count)
print(len(distinct_places))
