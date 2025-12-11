from math import ceil
import time

def generate(length, bounds):
    if length == 0:
        return [[]]
    if length == 1:
        return [[x] for x in range(ceil(bounds[0])+1)]
    else:
        sols = []
        for x in range(ceil(bounds[0])+1):
            for y in generate(length-1, bounds[1:]):
                sols.append([x]+y)
        return sols

def row_swap(matrix, rhs, i, j):
    temp = matrix[i]
    matrix[i] = matrix[j]
    matrix[j] = temp
    temp2 = rhs[i]
    rhs[i] = rhs[j]
    rhs[j] = temp2
    return matrix, rhs

def del_first(matrix):
    return [x[1:] for x in matrix]

def scale_vec(vec, s):
    return [s*x for x in vec]

def add_vecs(vec1, vec2):
    if len(vec1)!= len(vec2):
        return []
    return [vec1[i]+vec2[i] for i in range(len(vec1))]

def dot(vec1, vec2):
    if len(vec1)!=len(vec2):
        print("Error:Trying to dot vectors of different lengths")
        return 0
    else:
        return sum([(vec1[i]*vec2[i]) for i in range(len(vec1))])

def mul(matrix, vec):
    return [dot(x, vec) for x in matrix]

def transpose(matrix):
    return [[x[i] for x in matrix] for i in range(len(matrix[0]))]

def row_clear(matrix, rhs, row_num, col_num):#assume row at row_num has leading nonzero term
    new_matrix = []
    new_rhs = []
    d = matrix[row_num][col_num]
    for i in range(len(matrix)):
        if i == row_num:
            new_matrix.append(scale_vec(matrix[i], (1/d)))
            new_rhs.append((rhs[i]/d))
        else:
            factor = (matrix[i][col_num]/d)
            new_matrix.append(add_vecs(matrix[i], scale_vec(matrix[row_num], -1*factor)))
            new_rhs.append(rhs[i]-(factor*rhs[row_num]))
            
    return new_matrix, new_rhs

    
def row_echelon(matrix, rhs):
    if len(matrix)==1:
        return (matrix, rhs)
    else:
        col = 0
        leading =[i for i in range(len(matrix)) if matrix[i][0]!=0]
        while leading == []:#that column is all zero
            col += 1
            if col>=len(matrix[0]):#matrix is the zero matrix
                return matrix, rhs
##                break
            leading = [i for i in range(len(matrix)) if matrix[i][col]!=0]
        row_to_shift = leading[0]
        cleared_matrix, cleared_rhs = row_clear(matrix, rhs, row_to_shift, col)
        updated_matrix, updated_rhs = row_swap(cleared_matrix, cleared_rhs, row_to_shift, 0)
        sub_matrix, sub_rhs = row_echelon(updated_matrix[1:], updated_rhs[1:])
        return [updated_matrix[0]]+sub_matrix, [updated_rhs[0]]+sub_rhs

def reduced_row_echelon(matrix, rhs): #assumes matrix is wider than it is tall
    e_matrix, e_rhs = row_echelon(matrix, rhs)
    rnum = len(e_matrix)
    cnum = len(e_matrix[0])
    free_cols = [x for x in range(cnum)]
    for i in range(rnum):
        nonzero_cols = [j for j in range(cnum) if e_matrix[i][j]!=0]
        if nonzero_cols == []:#means ith row is zero, which means every row after is also 0
            pass
        else:
            j = nonzero_cols[0]
            e_matrix, e_rhs = row_clear(e_matrix, e_rhs, i, j)
            free_cols.remove(j)
    return e_matrix, e_rhs, free_cols


def solve(matrix, rhs):
    new_matrix, new_rhs, free_cols = reduced_row_echelon(matrix, rhs)
    sub_matrix = [[x[i] for i in free_cols] for x in new_matrix]
    num_vars = len(free_cols)
    M = max(rhs)
    tolerance = 0.01
    smart_bounds = []
    for col in free_cols:
        column = [x[col] for x in matrix] #this is a free column
        nonzero_rows = [i for i in range(len(matrix)) if column[i]!=0]
        smart_bounds.append(min([int(rhs[i]) for i in nonzero_rows]))
    if smart_bounds == []:
        return(sum(new_rhs))
    else:
        to_try = generate(num_vars, smart_bounds)
        current_min = 10000000
        for vec in to_try:
            candidate = add_vecs(new_rhs, scale_vec(mul(sub_matrix, vec), -1))
            if all([(round(x,4)>=0)and(abs(round(x,0)-x)<tolerance) for x in candidate]):
                if sum(candidate)+sum(vec)<current_min:
                    current_min = sum(candidate)+sum(vec)
        if current_min == 10000000:
            print(matrix, rhs)
        return current_min


def parse_light(light):
    trimmed = light[1:-1]
    bulbs = []
    for x in trimmed:
        if x=='.':
            bulbs.append(0)
        else:
            bulbs.append(1)
    return bulbs

def parse_switches(switches, length):
    toggles = []
    for switch in switches:
        trimmed = [int(x) for x in switch[1:-1].split(',')]
        config = []
        for i in range(length):
            if i in trimmed:
                config.append(1)
            else:
                config.append(0)
        toggles.append(config)
    return toggles

def parse_weights(weights):
    trimmed = weights[1:-1]
    return [int(x) for x in trimmed.split(',')]
    
def parse(line):
    words = line.split(' ')
    lights = parse_light(words[0])
    num_lights = len(lights)
    switches = parse_switches(words[1:-1], num_lights)
    weights = parse_weights(words[-1])
    return [lights, switches, weights]

def part_two(lots_of_lights):
    running_sum = 0
    for config in lots_of_lights:
        matrix = transpose(config[1])
        rhs = config[2]
        print(rhs, solve(matrix, rhs))
        running_sum += solve(matrix, rhs)
    return running_sum

all_data = []
with open("day10.txt", 'r') as f:
    for line in f:
        if line[-1]=='\n':
            line = line[:-1]
        all_data.append(parse(line))

start = time.time()
print(part_two(all_data))
print("Time taken:", time.time()-start)
        
