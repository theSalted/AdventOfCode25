import Foundation

let puzzlePath = "./input"
let url = URL(fileURLWithPath: puzzlePath)

struct Instruction {
    enum OP: String {
        case right = "R"
        case left = "L"

        func effect() -> Int {
            switch self {
            case .right:
                return 1
            case .left:
                return -1
            }
        }
    }

    let op: OP
    let step: Int

    init(rawString input: String) {
        let opString = String(input.prefix(1))
        guard let op = OP(rawValue: opString), let step = Int(input.dropFirst()) else {
            fatalError("Invalid instruction format: \(input)")
        }
        self.op = op
        self.step = step
    }
}

class Safe {
    private var dial = 50
    public private(set) var countOfZero = 0

    public func advance(_ instruction: Instruction) {
        let op = instruction.op.effect() * instruction.step

        dial = (dial + op + 1000) % 100
        if dial == 0 {
            countOfZero += 1
        }
    }
}

guard let puzzle = try? String(contentsOf: url, encoding: .utf8) else {
    fatalError("Error reading file")
}

let instructions: [Instruction] = puzzle.split(separator: "\n").map {
    Instruction(rawString: String($0))
}

let safe = Safe()

for instruction in instructions {
    safe.advance(instruction)
}

print(safe.countOfZero)
