lines = []
words = ["XMAS"]
directions = [[1, 0], [-1, 0], [0, 1], [0, -1],
              [1, 1], [1, -1], [-1, 1], [-1, -1]]
with open("day4.txt", "r") as f:
    lines = f.read().split("\n")

height = len(lines)
length = len(lines[0])

def add_vects(vect1, vect2):
    if len(vect1) != len(vect2):
        return False
    else:
        return [vect1[i]+vect2[i] for i in range(len(vect1))]

def scale_vect(scale, vect):
    return [scale*x for x in vect]

def cartesian_prod(vect1, vect2):
    return [[x, y] for x in vect1 for y in vect2]

def within_bounds(position, array):
    return ((position[0] in range(len(array))) and (position[1] in range(len(array[0]))))

def indices(position, direction, word, offset = 0):
    return [add_vects(position, scale_vect(i-offset, direction)) for i in range(len(word))]

def word_check(position, direction, word, array=lines):
    #position = [n, m]
    last_position = add_vects(position, scale_vect(len(word)-1, direction))
    if not within_bounds(last_position, array):
        return False
    else:
        indices_to_check = indices(position, direction, word)
        to_check = ''.join([array[pos[0]][pos[1]] for pos in indices_to_check])
        return to_check == word

def x_word_check(position, word = "MAS", array = lines):
    diag = indices(position, [-1, 1], word, offset = 1)
    anti_diag = indices(position, [-1, -1], word, offset = 1)
    all_pos = diag+anti_diag
    if False in [within_bounds(pos, array) for pos in all_pos]:#that's funny
        return False
    else:
        diag_word = ''.join([array[pos[0]][pos[1]] for pos in diag])
        anti_diag_word = ''.join([array[pos[0]][pos[1]] for pos in anti_diag])
        return ((diag_word == word or diag_word[::-1] == word) and (anti_diag_word == word or anti_diag_word[::-1] == word))
    

all_positions = cartesian_prod(range(height), range(length))
score = 0
x_mas_score = 0

to_highlight = []
to_highlight_two = []

for pos in all_positions:
    for direction in directions:
        if word_check(pos, direction, "XMAS"):
            to_highlight += (indices(pos, direction, "XMAS"))
            score += 1

for pos in all_positions:
    if x_word_check(pos, "MAS", lines):
        to_highlight_two += indices(pos, [-1, 1], "MAS", offset = 1)+indices(pos, [-1, -1], "MAS", offset = 1)
        x_mas_score += 1

print(x_mas_score)
print(score)
for x in range(height):
    line = ""
    for y in range(length):
        if [x, y] in to_highlight_two:
            line += lines[x][y]
        else:
            line+="."
    print(line)
    

#print(lines)

