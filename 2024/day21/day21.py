dirs = {'<': (-1, 0), '^': (0, 1), '>': (1, 0), 'v': (0, -1)}
board1 = {(-2, 3):'7', (-1, 3):'8', (0, 3):'9',
          (-2, 2):'4', (-1, 2):'5', (0, 2):'6',
          (-2, 1):'1', (-1, 1):'2', (0, 1):'3',
          (-2, 0):'x', (-1, 0):'0', (0, 0):'A'}
board2 = {(-2, 0):'x', (-1, 0):'^', (0, 0):'A',
          (-2, -1):'<', (-1, -1):'v', (0, -1):'>'}
invdirs = {dirs[k]:k for k in dirs.keys()}
invb1 = {board1[k]:k for k in board1.keys()}
invb2 = {board2[k]:k for k in board2.keys()}

def generate(n0, c0, n1, c1):
    if n0==0 and n1==0:
        return []
    else:
        return list(set([(c0*n0)+(c1*n1), (c1*n1)+(c0*n0)]))

def validate(sequence, start, board):
    current = start
    valid = True
    for i in sequence:
        (dx, dy) = dirs[i]
        current = (current[0]+dx, current[1]+dy)
        if board[current]=='x':
            valid = False
            break
    return valid

def valid_moves(start, end, board):
    (x0, y0) = start
    (x1, y1) = end
    sequences = []
    if x0>x1 and y0>y1:
        sequences = generate(x0-x1, '<', y0-y1, 'v')
    elif x0<=x1 and y0>y1:
        sequences = generate(x1-x0, '>', y0-y1, 'v')
    elif x0>x1 and y0<=y1:
        sequences = generate(x0-x1, '<', y1-y0, '^')
    else:
        sequences = generate(x1-x0, '>', y1-y0, '^')
    temp = ([x for x in sequences if validate(x, start, board)])
    if board == board2:
        if set(temp) == set(['<v', 'v<']):#A to v
            return ['<v']
        elif set(temp) == set(['^<', '<^']):#> to ^
            return ['<^']
        elif set(temp) == set(['v>', '>v']):#^ to >
            return ['v>']
        elif set(temp) == set(['>^', '^>']):#v to A
            return ['^>']
    if temp == []:
        return ['']
    return temp

def key_sequence(string, board):
    all_paths = []
    cur = (0, 0)
    if board == board1:
        for i in range(len(string)):
            nex = invb1[string[i]]
            if cur != nex:
                if all_paths == []: all_paths = valid_moves(cur, nex, board)
                else: all_paths = [x+y for x in all_paths for y in valid_moves(cur, nex, board)]
            all_paths = [x+'A' for x in all_paths]
            cur = nex
    elif board == board2:
        for i in range(len(string)):
            nex = invb2[string[i]]
            if cur != nex:
                if all_paths == []: all_paths = valid_moves(cur, nex, board)
                else: all_paths = [x+y for x in all_paths for y in valid_moves(cur, nex, board)]
            all_paths = [x+'A' for x in all_paths]
            cur = nex
    else:
        all_paths = []
    if all_paths == []:#in case I need to stay at A itself, the previous thing yields []
        return ['A']
    else:
        return all_paths

def convert_to_dict(string):
    seen = {}
    pieces = []
    current = 0
    for i in range(len(string)):
        if string[i] == 'A':
            pieces.append(string[current:i+1])
            current = i+1
    for s in pieces:
        if s in seen.keys():
            seen[s] += 1
        else:
            seen[s] = 1
    return seen

def update_dict(string_dict):
    new_dict = {}
    for s in string_dict.keys():
        best_move = convert_to_dict((key_sequence(s, board2)[0]))
        for t in best_move.keys():
            if t in new_dict.keys():
                new_dict[t] += best_move[t]*string_dict[s]
            else:
                new_dict[t] = best_move[t]*string_dict[s]
    return new_dict

def part_one(string):
    first_bot = key_sequence(string, board1)
    second_bot = [x for y in first_bot for x in key_sequence(y, board2)]
    third_bot = [x for y in second_bot for x in key_sequence(y, board2)]
    return (int(string[:-1])*min([len(x) for x in third_bot]))

def part_two(string, layers):
    first_bot = key_sequence(string, board1)
    lengths = []
    for best in first_bot:#going through all because I don't know how else to handle it
        first_dict = convert_to_dict(best)
        for i in range(layers):
            first_dict = update_dict(first_dict)
        lengths.append((int(string[:-1]))*sum([len(k)*first_dict[k] for k in first_dict.keys()]))
    return min(lengths)
input_ = []
print(sum([part_one(i) for i in input_]))
print(sum([part_two(i, 25) for i in input_]))
    
##second_layer_distances = {'^':3, '>':2, 'v':4, '<':7, 'A':0}
##
##
##def entropy(string):
##    return sum([1 for i in range(len(string)-1) if string[i]!= string[i+1]])

#only for board2
##def total_dist(string):
##    score = 0
##    for i in string:
##        score += second_layer_distances[i]
##    return score
##    
##    (cx, cy) = (0, 0)
##    score = 0
##    for i in string:
##        (nx, ny) = invb2[i]
##        dist = abs(cx-nx)+abs(cy-ny)#+second_layer_distances[i]
##        score += dist
##        (cx, cy) = (nx, ny)
##    return score

##def reduce(list_of_strings):#, start, board):
##    current_min = float('inf')
##    min_valid = []
##    for x in list_of_strings:
##        if entropy(x)<current_min:
##            current_min = entropy(x)
##            min_valid = [x]
##        elif entropy(x)==current_min:
##            min_valid.append(x)
##        else:
##            pass
##    min_valid = [x for x in min_valid if validate(x, start, board)]
##    if len(min_valid) == 2:
##        if total_dist(min_valid[0])<=total_dist(min_valid[1]):
##            return [min_valid[0]]
##        else:
##            return [min_valid[1]]
##    else:
##        return min_valid
##    return min_valid

##def replace(num, length, c0, c1):
##    seed = bin(num)[2:]
##    to_replace = '0'*(length-len(seed))+seed
##    result = ""
##    for c in to_replace:
##        if c=='0':
##            result += c0
##        else:
##            result += c1
##    return result