import os

list1 = []
list2 = []
total_dist = 0

with open('day1.txt', 'r') as f:
    for line in f:
        list1.append(int(line.split('   ')[0]))
        list2.append(int(line.split('   ')[1]))

def score(n, num_list):
    return len([x for x in num_list if x == n])

score_list = [score(x, list2) for x in list1]


L = len(list1)
i = 0

similarity_score = sum([list1[i]*score_list[i] for i in range(L)])

while i<L:
    m1 = min(list1)
    m2 = min(list2)
    list1.remove(m1)
    list2.remove(m2)
    total_dist += abs(m1-m2)
    i += 1

print(total_dist)
print(similarity_score)






