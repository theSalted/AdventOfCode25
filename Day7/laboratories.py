from itertools import count
from string import printable

diagram = None

with open("input") as f:
    diagram = f.read()

print(diagram.count("^"))
lines = diagram.splitlines()

# print(lines)
scanner = lines.pop(0)
scanner = scanner.replace(".", "0")
scanner = scanner.replace("S", "1")
scanner = [int(ch) for ch in scanner]


counter = 0
for line in lines:
    line = [ch for ch in line]
    # print(line)
    for index, char in enumerate(line):
        if char == "^" and scanner[index] == 1:
            counter += 1
            scanner[index] = 0
            if index - 1 >= 0:
                scanner[index - 1] = 1
            if index + 1 < len(scanner):
                scanner[index + 1] = 1

print(counter)
