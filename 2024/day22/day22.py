import time
def xor(string1, string2):
    num1 = int(string1, 2)
    num2 = int(string2, 2)
    res = bin(num1^num2)[2:]
    return ('0'*(24-len(res)))+res

#input is a 24 bit binary string
def get_next(string):
    mul64 = string[6:]+'000000'
    first = xor(string, mul64)#already 24 bits
    div32 = '00000'+first[:-5]
    second = xor(first, div32)
    mul2048 = second[11:]+'0'*11
    third = xor(second, mul2048)
    return third

def generate(num):
    reduced_binary = (bin(num)[2:])[-24:]
    next_ = get_next(('0'*(24-len(reduced_binary)))+reduced_binary)
    return int(next_, 2)

def changes(digits):
    changes = [digits[i]-digits[i-1] for i in range(1, len(digits))]
    return [(changes[i], changes[i+1], changes[i+2], changes[i+3]) for i in range(len(changes)-4)]

def last_digits(num):
    sequence = [num%10]
    for i in range(1999):
        num = generate(num)
        sequence.append(num%10)
    return sequence

def part_one(num_list):
    for i in range(2000):
        num_list = [generate(n) for n in num_list]
    return sum(num_list)

def part_two(num_list):
    frequency = {}
    dict_of_digits = {}
    dict_of_changes = {}
    sums = []
    for n in num_list:
        dict_of_digits[n] = last_digits(n)
        dict_of_changes[n] = changes(dict_of_digits[n])
        for i in range(len(dict_of_changes[n])):
            change = dict_of_changes[n][i]
            if change in frequency.keys():
                if n not in [x[0] for x in frequency[change]]:
                    frequency[change].append([n, i])
            else:
                frequency[change] = [[n, i]]
    print("done computing frequencies")
    for change in frequency.keys():
##        if sum(change)>0:
        running_sum = 0
        for [n, i] in frequency[change]:
            running_sum+=dict_of_digits[n][i+4]
        sums.append(running_sum)   
    return max(sums)
    

with open("day22.txt", "r") as f:
    nums = [int(x) for x in f.read().split("\n")]

s = time.time()
print(part_one(nums))
print(time.time()-s)
s = time.time()
print(part_two(nums))
print(time.time()-s)
