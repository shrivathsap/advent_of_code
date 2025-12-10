import matplotlib.pyplot as plt

xcoords = []
ycoords = []

with open ("day09.txt", 'r') as f:
    lines = f.read().split('\n')

for l in lines:
    x = [int(y) for y in l.split(',')]
    xcoords.append(x[0])
    ycoords.append(x[1])

plt.plot(xcoords, ycoords)
plt.show()
