def cantor(x,y):
    d = x+y-2
    return (d*(d+1)//2)+y-1

def f(num):
    return (252533*num)%(33554393)

seed = 20151125
x, y = 0,0 #input goes here
for i in range(cantor(x,y)):
    seed = f(seed)
print(seed)
