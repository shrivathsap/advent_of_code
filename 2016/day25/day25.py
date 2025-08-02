base = 365*7

def check(num):
    s = bin(num)[2:]
    if num<2:
        return False
    elif num==2:
        return True
    elif s[-2:]=='10':
        return check(((num//2)-1)//2)
    else:
        return False

for x in range(0, 1000):
    if check(base+x):
        print(x)
        break
