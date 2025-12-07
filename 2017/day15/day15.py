import time

mulA = 16807
mulB = 48271
num = 2147483647
threshold = 2**16
total = 40000000
total2 = 5000000

def part_one(startA, startB, rounds):
    count = 0
    for i in range(rounds):
##        if (i%1000000)==0:
##            print(i)
        startA = (mulA*startA)%num
        startB = (mulB*startB)%num
        if startA%threshold == startB%threshold:
            count += 1
    return count

def part_two(startA, startB, rounds):
    numsA = []
    numsB = []
    while len(numsA)<rounds:
        startA = (mulA*startA)%num
        if startA%4==0:
##            if (len(numsA)%1000000)==0:
##                print(len(numsA))
            numsA.append(startA)
    while len(numsB)<rounds:
        startB = (mulB*startB)%num
        if startB%8==0:
##            if (len(numsB)%1000000)==0:
##                print(len(numsB))
            numsB.append(startB)
    count = 0
    for i in range(rounds):
        if numsA[i]%threshold==numsB[i]%threshold:
            count += 1
    return count

s = time.time()
inputA = 0
inputB = 0
print(part_one(inputA, inputB, total))
print(part_two(inputA, inputB, total2))
print(time.time()-s)