def best_comb(tup1, tup2, target):
    x1, y1 = tup1[0], tup1[1]
    x2, y2 = tup2[0], tup2[1]
    x3, y3 = target[0]+10000000000000, target[1]+10000000000000
    det = x1*y2-x2*y1
    scaled_a = y2*x3-x2*y3
    scaled_b = -y1*x3+x1*y3
    if (det == 0):
        print("to do")
        return (0, 0)
    elif (det*scaled_a<0) or (det*scaled_b<0) or (scaled_a%det != 0) or (scaled_b%det != 0):
        return (0, 0)
    else:
        return (scaled_a//det, scaled_b//det)
    

with open("day13.txt", "r") as f:
    lines = f.read().split("\n")

machines = [lines[i:i+3] for i in range(0, len(lines), 4)]#ignore empty lines separating machines
data = []
for machine in machines:
    Abutton = (int(machine[0].split("+")[1].split(",")[0]), int(machine[0].split("+")[-1]))
    Bbutton = (int(machine[1].split("+")[1].split(",")[0]), int(machine[1].split("+")[-1]))
    prize = (int(machine[2].split("=")[1].split(",")[0]), int(machine[2].split("=")[-1]))
    data.append([Abutton, Bbutton, prize])

results = [best_comb(m[0], m[1] ,m[2]) for m in data]
print(sum([3*c[0]+c[1] for c in results]))
