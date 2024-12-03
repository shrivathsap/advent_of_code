lines = []

#read the text file and get lines
with open("day2.txt", "r") as f:
    lines = f.read().splitlines()

L = len(lines)

#break up into individual numbers and convert from char to int
for i in range(L):
    lines[i] = [int(x) for x in lines[i].split(' ')]

def is_decreasing(num_list):
    for i in range(len(num_list)-1):
        if num_list[i] <= num_list[i+1]:
            return False
    return True

def is_increasing(num_list):
    for i in range(len(num_list)-1):
        if num_list[i] >= num_list[i+1]:
            return False
    return True

#assumes list is already either sctrictly decreasing or increasing
#so difference is at least one, need it to be <= 3
def gradual_change(num_list):
    for i in range(len(num_list)-1):
        if abs(num_list[i]-num_list[i+1])>3:
            return False
    return True

def positive(num_list):
    return gradual_change(num_list) and (is_decreasing(num_list) or is_increasing(num_list))

#first check if removing the head makes it positive, then remove other elements one by one till a success
def positive_lenient(num_list):
    if positive(num_list[1:]):
        return True
    else:
        for i in range(len(num_list)-1):
            if positive(num_list[:i+1]+num_list[i+2:]):
                return True
    return False

def score(list_of_lists):
    return len([x for x in list_of_lists if positive(x)])

def score_lenient(list_of_lists):
    return len([x for x in list_of_lists if positive_lenient(x)])

print(score(lines))
print(score_lenient(lines))
##for l in lines:
##    print(l, is_increasing_lenient(l))
    
        
