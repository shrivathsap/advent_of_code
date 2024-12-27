import hashlib

def md5(string):
    return hashlib.md5(string.encode('utf-8')).hexdigest()

start = "input"#goes here
for i in range(10000000):
    if md5(start+str(i))[:6]=='000000':#6 for part 2, 5 for part 1
        print(i)
        break

