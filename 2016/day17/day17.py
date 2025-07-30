import hashlib

seed = "lpvhkcbi"
end = (3, 3)
start = [[((0, 0), "")]]

def md5(string):
    return hashlib.md5(string.encode('utf-8')).hexdigest()

def is_wall(x, y):
    return(x<0 or x>3 or y<0 or y>3)

def generate(visited, part):
    last_gen = visited[-1]
    next_gen = []
    for x in last_gen:
        coord = x[0]
        path = x[1]
        if (part != 2) or (coord != end):
            doors = (md5(seed+path))[0:4]
            if (doors[0] in ['b', 'c', 'd', 'e', 'f']) and not(is_wall(coord[0], coord[1]-1)):
                next_gen.append(((coord[0], coord[1]-1), path+'U'))
            if (doors[1] in ['b', 'c', 'd', 'e', 'f']) and not(is_wall(coord[0], coord[1]+1)):
                next_gen.append(((coord[0], coord[1]+1), path+'D'))
            if (doors[2] in ['b', 'c', 'd', 'e', 'f']) and not(is_wall(coord[0]-1, coord[1])):
                next_gen.append(((coord[0]-1, coord[1]), path+'L'))
            if (doors[3] in ['b', 'c', 'd', 'e', 'f']) and not(is_wall(coord[0]+1, coord[1])):
                next_gen.append(((coord[0]+1, coord[1]), path+'R'))
    return (visited+[next_gen])

def part_one():
    start = [[((0, 0), "")]]
    while end not in [x[0] for x in start[-1]]:
        start = generate(start, 1)

    for x in start[-1]:
        if x[0] == end:
            print(x[1])
            print(len(x[1]))

def part_two():
    start = [[((0, 0), "")]]
    while start[-1] != []:
        start = generate(start, 2)
    joined = [x for y in start for x in y] #there may be longer paths that end in a deadend somewhere else in the grid
    goals = [x for x in joined if x[0]==end]
    print(max([len(x[1]) for x in goals]))

part_one()
part_two()

