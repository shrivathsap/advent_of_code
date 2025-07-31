def part2(num):
    x = list(range(1, num + 1))
    while len(x) > 1:
        x = x[:len(x)//2] + x[len(x)//2+1:]
        x = x[1:]+x[:1]
    return x[0]


for num in range(2, 100):
    print(num, part2(num))
