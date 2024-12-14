import re
def movie(positions, cols, rows, seconds):
    return [((c[0]+seconds*c[2])%cols, (c[1]+seconds*c[3])%rows) for c in positions]

def character(num):#to draw the tree
    if num>0:
        return '#'
    else:
        return '.'

with open("day14.txt", "r") as f:
    lines = f.read().split("\n")
pos_vel = [list(map(int, re.findall(r"\d+|-\d+", l))) for l in lines]

length = 101
height = 103
steps = 100

final_config = [((c[0]+steps*c[2])%length, (c[1]+steps*c[3])%height) for c in pos_vel]

first = [p for p in final_config if p[0]<(length-1)/2 and p[1]<(height-1)/2]
second = [p for p in final_config if p[0]>(length-1)/2 and p[1]<(height-1)/2]
third = [p for p in final_config if p[0]<(length-1)/2 and p[1]>(height-1)/2]
fourth = [p for p in final_config if p[0]>(length-1)/2 and p[1]>(height-1)/2]
print(len(first)*len(second)*len(third)*len(fourth))

to_check = movie(pos_vel, length, height, 1)
time_passed = 1571#starting from here because my input has two times where the robots occupy unique spaces
while len(set(to_check)) < len(to_check):
   time_passed += 1
   to_check = movie(pos_vel, length, height, time_passed)
grid = [[0 for _ in range(length)] for _ in range(height)]
for pos in to_check:
    grid[pos[1]][pos[0]] += 1

modified_grid = [[character(x) for x in r] for r in grid]
for r in modified_grid:
    print("".join(r))
print(time_passed)
