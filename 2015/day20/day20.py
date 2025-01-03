import math
input_num = 6000#input goes here
target = input_num//10
target_two = input_num//11

div_sum = {1:1, 2:3}

for i in range(3, target):
   if i%10000==0:print(i)
   p = [x for x in range(2, math.ceil(math.sqrt(i))+1) if i%x==0]
   if p==[]:
       div_sum[i] = i+1
   else:
       exps = [j for j in range(math.ceil(math.log2(i))+1) if i%(p[0]**j) == 0]
       div_sum[i] = div_sum[i//((p[0])**(exps[-1]))]*(sum([(p[0]**x) for x in exps]))
   if div_sum[i]>target:
       print("part one: ", i)
       break       
    

for i in range(2, target_two):
    new_sum = sum([i//x for x in range(1, 51) if i%x==0])
    if new_sum > target_two:
        print("part two: ", i)
        break