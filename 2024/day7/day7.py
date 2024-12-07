import time
def prod(list_of_nums):
    if list_of_nums == []:
        return 1
    return list_of_nums[0]*prod(list_of_nums[1:])

def concat(num1, num2):
    return int(str(num1)+str(num2))

def deconcat(num1, num2):
    str1 = str(num1)
    str2 = str(num2)
    l1 = len(str1)
    l2 = len(str2)
    if l1<l2:
        return '-1'
    elif str1[l1-l2:] == str2:
        return str1[:l1-l2]
    else:
        return '-1'

def computes(num, list_of_nums):
    if num != int(num) or num<0:
        return False
    elif len(list_of_nums) == 1:
        return (num == list_of_nums[0])
    else:
        last = list_of_nums[-1]
        removed = deconcat(int(num), last)
        if removed == '':
            return True
        else:
            removed = int(removed)
        return (computes(num/last, list_of_nums[:-1])) or (computes(num-last, list_of_nums[:-1])) or (computes(removed, list_of_nums[:-1]))

def all_possible(list_of_nums):
    if len(list_of_nums) == 1:
        return list_of_nums
    else:
        last = list_of_nums[-1]
        return [x+last for x in all_possible(list_of_nums[:-1])]+[x*last for x in all_possible(list_of_nums[:-1])]+[concat(x, last) for x in all_possible(list_of_nums[:-1])]

def pruned_possible(target, nums):
    if nums == []:
        return False
    else:
        possibilities = [nums[0]]
        for i in range(1, len(nums)):
            smaller_sums = [x+nums[i] for x in possibilities if x+nums[i]<= target]
            smaller_prods = [x*nums[i] for x in possibilities if x*nums[i]<= target]
            smaller_concats = [concat(x, nums[i]) for x in possibilities if concat(x, nums[i])<=target]
            possibilities = smaller_sums+smaller_prods+smaller_concats
        if target in possibilities:
            return True
        else:
            return False

with open("day7.txt", "r") as f:
    lines = f.read().split("\n")


to_test = [[int(x.split(":")[0]), [int(y) for y in (x.split(":")[1]).split(" ")[1:]]] for x in lines]

start1 = time.time()
does_compute1 = [x[0] for x in to_test if computes(x[0], x[1])]
print("first", time.time()-start1)

start2 = time.time()
does_compute2 = [x[0] for x in to_test if x[0] in all_possible(x[1])]
print("second", time.time()-start2)

start3 = time.time()
does_compute3 = [x[0] for x in to_test if pruned_possible(x[0], x[1])]
print("does_compute3", time.time()-start3)

print(sum(does_compute1))
print(sum(does_compute2))
print(sum(does_compute3))
