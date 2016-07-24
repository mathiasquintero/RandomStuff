import sys

filename = sys.argv[1]
file = open(filename, 'r')
content = file.read()
h = []

for i in range(0, 10):
    h.append(0)

for i in range(0, len(content)):
    try:
        h[int(content[i])] += 1
    except Exception:
        continue

for i in range(0, 10):
    print("h_" + str(i) + ": " + str(h[i]))

res = 0
np = 1000000/10
for i in range(0, 10):
    item = h[i] - np
    item = item * item
    res += item / np

print("Result T: " + str(res))
