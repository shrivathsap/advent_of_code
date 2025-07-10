'''same as 2015 day04'''
import hashlib

def md5(string):
    return hashlib.md5(string.encode('utf-8')).hexdigest()

start = "input"#goes here
count = 0

#part one
for i in range(10000000):
    if md5(start+str(i))[:5]=='00000':
        print(i, md5(start+str(i)))
        count += 1
    if count == 8:
        break

#part two
used = []
count = 0
for i in range(50000000):
    h = md5(start+str(i))
    if h[:5]=='00000' and (h[5] in "01234567") and (h[5] not in used):
        used += h[5]
        print(i, md5(start+str(i)), used)
        count += 1
    if count == 8:
        break

