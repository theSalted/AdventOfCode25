import std/strutils
import std/sequtils
import std/tables

proc extractBinaryFromTarget(target: string): (int, int) =
    if target.len < 2:
        return (0, 0)
    let inner = target[1..target.len - 2]
    let length = inner.len
    for i, c in inner:
        if c == '#':
            result[0] = result[0] or (1 shl i)
    result[1] = length

proc extractIndices(input: string): seq[int] =
    input[1..input.len - 2].split(",").mapIt(it.parseInt())

proc makeBinary(length: int, indices: seq[int]): int =
    var x = 0
    for i in indices:
        x = x or (1 shl i)
    x

proc meetInTheMiddle(target: int, switches: seq[int]): int =
    let n = switches.len
    let mid = n div 2

    var firstHalf = initTable[int, int]()
    for mask in 0 ..< (1 shl mid):
        var xorResult = 0
        var ops = 0
        for i in 0 ..< mid:
            if (mask and (1 shl i)) != 0:
                xorResult = xorResult xor switches[i]
                ops += 1
        if xorResult notin firstHalf or firstHalf[xorResult] > ops:
            firstHalf[xorResult] = ops

    result = high(int)
    let secondLen = n - mid
    for mask in 0 ..< (1 shl secondLen):
        var xorResult = 0
        var ops = 0
        for i in 0 ..< secondLen:
            if (mask and (1 shl i)) != 0:
                xorResult = xorResult xor switches[mid + i]
                ops += 1
        let needed = target xor xorResult
        if needed in firstHalf:
            result = min(result, ops + firstHalf[needed])

    if result == high(int):
        result = -1

let manual = readFile("input").splitLines().mapIt(it.split(" "))

var totalOperations = 0
for line in manual[0..manual.len - 2]:
    let (target, length) = extractBinaryFromTarget(line[0])
    let switches = line[1..line.len - 1].mapIt(makeBinary(length, extractIndices(it)))
    let minOps = meetInTheMiddle(target, switches)
    if minOps >= 0:
        totalOperations += minOps

echo "Total: ", totalOperations
