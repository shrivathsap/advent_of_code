states = {}
generations = 10000000
(x, y) = (0, 0)
(dx, dy) = (-1, 0)
infections = 0
lines = []

with open("day22.txt", 'r') as f:
    for line in f:
        if line[-1]=='\n':
            line = line[:-1]
        lines.append(line)

rows = len(lines)
cols = len(lines[0])
rshift = rows//2
cshift = cols//2

for r in range(rows):
    for c in range(cols):
        if lines[r][c]=='#':
            states[(r-rshift, c-cshift)] = 'I'

for i in range(generations):
    if i%10000 == 0:
        print(i, len(states.keys()))
    if (x,y) in states.keys():
        if states[(x,y)] == 'W':
            states[(x,y)] = 'I'
            infections += 1
        elif states[(x,y)] == 'I':
            states[(x,y)] = 'F'
            (dx,dy) = (dy,-dx)
        else:
            del states[(x,y)]
            (dx,dy) = (-dx,-dy)
    else:
        states[(x,y)] = 'W'
        (dx,dy) = (-dy,dx)
    (x,y) = (x+dx, y+dy)

print(infections)
