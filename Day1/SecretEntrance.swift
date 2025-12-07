import Foundation

let puzzlePath = "./input"
let url = URL(fileURLWithPath: puzzlePath)

struct Instruction {
    enum OP: String {
        case right = "R"
        case left = "L"
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

do {
    let puzzle = try String(contentsOf: url, encoding: .utf8)
    let instruction: [Instruction] = puzzle.split(separator: "\n").map {
        Instruction(rawString: String($0))
    }

    print(instruction)

} catch {
    print("Error reading file: \(error)")
}
