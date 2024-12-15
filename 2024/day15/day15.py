def draw(grid):
    print("\n".join(grid))
def find_robo(grid, rows, cols):
    for i in range(rows):
        for j in range(cols):
            if grid[i][j] == "@":
                return (i, j)
def transpose(grid):
    numr = len(grid)
    numc = len(grid[0])
    transposed = []
    for i in range(numc):
        new_row = ""
        for j in range(numr):
            new_row += grid[j][i]
        transposed.append(new_row)
    return transposed

def flip(grid):
    return [row[::-1] for row in grid]

def flip_vert(grid):
    return grid[::-1]

def move_right(grid, rows, cols, current_pos):
    new_grid = []
    #new_grid.append(grid[0]) #upper wall
    r, c = current_pos[0], current_pos[1]
    new_pos = (0, 0)
    for i in range(0, rows):
        if i != r:
            new_grid.append(grid[i])
        else:
            new_row = ""
            for j in range(cols):
                if j<c:
                    new_row += grid[i][j]
                else:                    
                    if grid[i][j] == "#":
                        new_row += "#"
                    elif "#" in grid[i][c:j] or "." in grid[i][c:j]:
                        new_row += grid[i][j]
                    elif grid[i][j] == ".":# and grid[i][j-1]!="#":
                        new_row += grid[i][j-1]
                        if grid[i][j-1] == "@":
                            new_pos = (i, j)
                    elif grid[i][j] == "O" and "." in grid[i][j+1:]:
                        if (grid[i][j+1:]).index(".")<(grid[i][j+1:]).index("#"):
                            new_row += grid[i][j-1]
                            if grid[i][j-1] == "@":
                                new_pos = (i, j)
                        else:
                            new_row += "O"
                    elif grid[i][j] == "@" and ("." in grid[i][j+1:]):
                        if (grid[i][j+1:]).index(".")<(grid[i][j+1:]).index("#"):
                            new_row += "."
                            new_pos = (i, j+1)
                        else:
                            new_row += "@"
                            new_pos = (i, j)
                    else:
                        new_row += grid[i][j]
                        if grid[i][j] == "@":
                            new_pos = (i, j)
            new_grid.append(new_row)
    return new_grid, new_pos

def move_down(grid, rows, cols, current_pos):
    new_grid, new_pos = move_right(transpose(grid), cols, rows, (current_pos[1], current_pos[0]))
    return transpose(new_grid), (new_pos[1], new_pos[0])

def move_left(grid, rows, cols, current_pos):
    new_grid, new_pos = move_right(flip(grid), rows, cols, (current_pos[0], cols-current_pos[1]-1))
    return flip(new_grid), (new_pos[0], cols-new_pos[1]-1)

def move_up(grid, rows, cols, current_pos):
    new_grid, new_pos = move_left(transpose(grid), cols, rows, (current_pos[1], current_pos[0]))
    return transpose(new_grid), (new_pos[1], new_pos[0])

def does_move_up(grid, box_r, box_c, current_pos):
    if not can_move_up(grid, box_r, box_c):
        return False
    elif not is_pushed(grid, box_r, box_c, current_pos):
        return False
    else:
        if grid[box_r+1][box_c] == "]" and grid[box_r+1][box_c+1] in [".", "#"]:
            return does_move_up(grid, box_r+1, box_c-1, current_pos)
        elif grid[box_r+1][box_c]in [".", "#"] and grid[box_r+1][box_c+1]=="[":
            return does_move_up(grid, box_r+1, box_c+1, current_pos)
        elif grid[box_r+1][box_c] == "]" and grid[box_r+1][box_c+1] == "[":
            return does_move_up(grid, box_r+1, box_c-1, current_pos) or does_move_up(grid, box_r+1, box_c+1, current_pos)
        elif "@" in [grid[box_r+1][box_c], grid[box_r+1][box_c+1]]:
            return True
        else:#there's a box directly beneath
            return does_move_up(grid, box_r+1, box_c, current_pos)

def can_move_up(grid, box_r, box_c):
    if grid[box_r-1][box_c] == "#" or grid[box_r-1][box_c+1]=="#":
        return False
    elif grid[box_r-1][box_c] == "." and grid[box_r-1][box_c+1] == ".":
        return True
    elif grid[box_r-1][box_c] == "." and grid[box_r-1][box_c+1] == "[":
        return can_move_up(grid, box_r-1, box_c+1)
    elif grid[box_r-1][box_c] == "[" and grid[box_r-1][box_c+1] == "]":
        return can_move_up(grid, box_r-1, box_c)
    elif grid[box_r-1][box_c] == "]" and grid[box_r-1][box_c+1] == ".":
        return can_move_up(grid, box_r-1, box_c-1)
    elif grid[box_r-1][box_c] == "]" and grid[box_r-1][box_c+1] == "[":
        return (can_move_up(grid, box_r-1, box_c-1) and can_move_up(grid, box_r-1, box_c+1))
    else:#the robot is above the box
        return False

def is_pushed(grid, box_r, box_c, current_pos):#gets the box's row and column where it starts
    r, c = current_pos[0], current_pos[1]
    if box_r>=r:#box is unaffected by the robot moving up
        return False
    elif grid[box_r+1][box_c] == "." and grid[box_r+1][box_c+1] == ".":#there's space below
        return False
    elif grid[box_r+1][box_c] == "#" and grid[box_r+1][box_c+1] == "#":#there's two walls below
        return False
    elif grid[box_r+1][box_c] == "]" and grid[box_r+1][box_c+1] in [".", "#"]:
        return is_pushed(grid, box_r+1, box_c-1, current_pos)
    elif grid[box_r+1][box_c] in [".", "#"] and grid[box_r+1][box_c+1] == "[":
        return is_pushed(grid, box_r+1, box_c+1, current_pos)
    elif grid[box_r+1][box_c] == "]" and grid[box_r+1][box_c+1] == "[":
        return (is_pushed(grid, box_r+1, box_c-1, current_pos) or is_pushed(grid, box_r+1, box_c+1, current_pos))
    elif grid[box_r+1][box_c] == "[" and grid[box_r+1][box_c+1] == "]":
        return is_pushed(grid, box_r+1, box_c, current_pos)
    elif "@" in [grid[box_r+1][box_c], grid[box_r+1][box_c+1]]:#the robot is directly below the box
        return True
    else:#all other cases
        return False    

def move_up_wide(grid, rows, cols, current_pos):
    new_grid = ["" for _ in range(rows)]
    r, c = current_pos[0], current_pos[1]
    new_pos = (0, 0)
    for j in range(cols):
        for i in range(rows):
            if grid[i][j] == "#":
                new_grid[i] += "#"
            elif grid[i][j] == "[":
                if does_move_up(grid, i, j, current_pos):
                    if grid[i+1][j] == "." or grid[i+1][j] == "#":
                        new_grid[i] += "."
                    elif grid[i+1][j] == "[":
                        new_grid[i] += "["
                    elif grid[i+1][j] == "]":
                        if does_move_up(grid, i+1, j-1, current_pos):
                            new_grid[i] += "]"
                        else:
                            new_grid[i] += "."
                    else:
                        new_grid[i] += "@"
                        new_pos = (i, j)
                else:
                    new_grid[i] += "["
            elif grid[i][j] == "]":
                if does_move_up(grid, i, j-1, current_pos):
                    if grid[i+1][j] == "." or grid[i+1][j] == "#":
                        new_grid[i] += "."
                    elif grid[i+1][j] == "[":
                        if does_move_up(grid, i+1, j, current_pos):
                            new_grid[i] += "["
                        else:
                            new_grid[i] += "."
                    elif grid[i+1][j] == "]":
                        new_grid[i] += "]"
                    else:
                        new_grid[i] += "@"
                        new_pos = (i, j)
                else:
                    new_grid[i] += "]"
            elif grid[i][j] == ".":
                if grid[i+1][j] == ".":
                    new_grid[i] += "."
                elif grid[i+1][j] == "[":
                    if does_move_up(grid, i+1, j, current_pos):
                        new_grid[i] += "["
                    else:
                        new_grid[i] += "."
                elif grid[i+1][j] == "]":
                    if does_move_up(grid, i+1, j-1, current_pos):
                        new_grid[i] += "]"
                    else:
                        new_grid[i] += "."
                elif grid[i+1][j] == "@":
                    new_grid[i] += "@"
                    new_pos = (i, j)
                else:#remaining choice is wall "#"
                    new_grid[i] += "."
            else:#we are looking at the robot
                if grid[i-1][j] == ".":
                    new_grid[i] += "."
                    new_pos = (i-1, j)
                elif grid[i-1][j] == "#":
                    new_grid[i] += "@"
                    new_pos = (i, j)
                elif grid[i-1][j] == "[":
                    if does_move_up(grid, i-1, j, current_pos):#it's pushed regardless
                        new_grid[i] += "."
                        new_pos = (i-1, j)
                    else:
                        new_grid[i] += "@"
                        new_pos = (i, j)
                else:# grid[i-1][j] == "]":
                    if does_move_up(grid, i-1, j-1, current_pos):
                        new_grid[i] += "."
                        new_pos = (i-1, j)
                    else:
                        new_grid[i] += "@"
                        new_pos = (i, j)
    return new_grid, new_pos

def move_right_wide(grid, rows, cols, current_pos):
    new_grid = []
    r, c = current_pos[0], current_pos[1]
    new_pos = (0, 0)
    for i in range(0, rows):
        if i != r:
            new_grid.append(grid[i])
        else:
            new_row = ""
            for j in range(cols):
                if j<c:
                    new_row += grid[i][j]
                else:                    
                    if grid[i][j] == "#":
                        new_row += "#"
                    elif "#" in grid[i][c:j] or "." in grid[i][c:j]:
                        new_row += grid[i][j]
                    elif grid[i][j] == ".":
                        new_row += grid[i][j-1]
                        if grid[i][j-1] == "@":
                            new_pos = (i, j)
                    elif grid[i][j] == "[" and "." in grid[i][j+1:]:
                        if (grid[i][j+1:]).index(".")<(grid[i][j+1:]).index("#"):
                            new_row += grid[i][j-1]
                            if grid[i][j-1] == "@":
                                new_pos = (i, j)
                        else:
                            new_row += "["
                    elif grid[i][j] == "]" and "." in grid[i][j+1:]:
                        if (grid[i][j+1:]).index(".")<(grid[i][j+1:]).index("#"):
                            new_row += grid[i][j-1]
                        else:
                            new_row += "]"
                    elif grid[i][j] == "@" and ("." in grid[i][j+1:]):
                        if (grid[i][j+1:]).index(".")<(grid[i][j+1:]).index("#"):
                            new_row += "."
                            new_pos = (i, j+1)
                        else:
                            new_row += "@"
                            new_pos = (i, j)
                    else:
                        new_row += grid[i][j]
                        if grid[i][j] == "@":
                            new_pos = (i, j)
            new_grid.append(new_row)
    return new_grid, new_pos

def move_left_wide(grid, rows, cols, current_pos):
    new_grid, new_pos = move_right_wide(flip(grid), rows, cols, (current_pos[0], cols-current_pos[1]-1))
    return flip(new_grid), (new_pos[0], cols-new_pos[1]-1)

def move_down_wide(grid, rows, cols, current_pos):
    new_grid, new_pos = move_up_wide(flip_vert(grid), rows, cols, (rows-current_pos[0]-1, current_pos[1]))
    return flip_vert(new_grid), (rows-new_pos[0]-1, new_pos[1])
    
def widen(grid):
    new_grid = []
    for i in range(len(grid)):
        new_row = ""
        for j in range(len(grid[0])):
            if grid[i][j] == "#":
                new_row += "##"
            elif grid[i][j] == ".":
                new_row += ".."
            elif grid[i][j] == "O":
                new_row += "[]"
            else:
                new_row += "@."
        new_grid.append(new_row)
    return new_grid

def partOne(grid):
    score = 0
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "O":
                score += 100*i+j
    return score

def partTwo(grid):
    score = 0
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "[":
                score += 100*(i)+j
    return score

with open("day15.txt", "r") as f:
    grid, moves = f.read().split("\n\n")
    grid = grid.split("\n")

rnum, cnum = len(grid), len(grid[0])
initial = find_robo(grid, rnum, cnum)
current = initial
wgrid = widen(grid)
rnum_w, cnum_w = len(wgrid), len(wgrid[0])
initial_w = find_robo(wgrid, rnum_w, cnum_w)
current_w = initial_w
for direction in moves:
    if direction == "^":
        wgrid, current_w = move_up_wide(wgrid, rnum_w, cnum_w, current_w)
    elif direction == ">":
        wgrid, current_w = move_right_wide(wgrid, rnum_w, cnum_w, current_w)
    elif direction == "v":
        wgrid, current_w = move_down_wide(wgrid, rnum_w, cnum_w, current_w)
    elif direction == "<":
        wgrid, current_w = move_left_wide(wgrid, rnum_w, cnum_w, current_w)
    else: #there are some \n characters that I didn't filter out...
        continue
print(partTwo(wgrid))
