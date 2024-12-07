import Foundation

enum Instruction {
    case `do`
    case dont
}

func day3() {
    print("Day 3")
    let instructions = getMultiplyInstructions(filepath: "Sources/inputs/day3/input.txt")
    // part1(instructions: instructions)
    part2(instructions: instructions)
}

func part1(instructions: String) {
    // let pattern = #"mul\((\d+),(\d+))"#
    let pattern = #"mul\((\d+),(\d+)\)"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(instructions.startIndex..<instructions.endIndex, in: instructions)
    var result = 0

    let matches = regex.matches(in: instructions, range: range)
    for match in matches {
        let firstNumRange = Range(match.range(at: 1), in: instructions)!
        let secondNumRange = Range(match.range(at: 2), in: instructions)!
        let firstNum = Int(instructions[firstNumRange])!
        let secondNum = Int(instructions[secondNumRange])!
        let multiplication = firstNum * secondNum
        result += multiplication
    }
    print("Part 1 answer: \(result)")
}

func part2(instructions: String) {
    let doAndDontRanges = findDoesAndDonts(instructions)
    let multiplicationRanges = findMultiplicationsAndRanges(instructions: instructions)
    let calcArr = constructCalcArr(input: instructions, instructionInfo: doAndDontRanges)
    var ans = 0
    for m in multiplicationRanges {
        if calcArr[m.range.lower] {
            ans += m.result
        }
    }
    print(ans)
}

func findDoesAndDonts(_ input: String) -> [(Instruction, Int)] {
    let pattern = #"(?:do\(\)|don't\(\))"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(input.startIndex..<input.endIndex, in: input)

    let matches = regex.matches(in: input, options: [], range: range)

    return matches.compactMap { match in
        let range = Range(match.range, in: input)!
        let matchedText = String(input[range])
        let index = input.distance(from: input.startIndex, to: range.lowerBound)
        let type = matchedText == "do()" ? Instruction.do : Instruction.dont
        return (type, index)
    }
}

func constructCalcArr(input: String, instructionInfo: [(Instruction, Int)]) -> [Bool] {
    var applyCalc = true
    var result: [Bool] = []
    var curIdx = 0
    for (instruction, idx) in instructionInfo {
        let numBooleansToAdd = idx - curIdx
        result.append(contentsOf: Array(repeating: applyCalc, count: numBooleansToAdd))
        applyCalc = instruction == Instruction.do ? true : false
        curIdx = idx
    }
    let remainingBooleansToAdd = input.count - curIdx
    result.append(contentsOf: Array(repeating: applyCalc, count: remainingBooleansToAdd))
    
    return result
}

func findMultiplicationsAndRanges(instructions: String) -> [(
    result: Int, range: (lower: Int, upper: Int)
)] {
    let pattern = #"mul\((\d+),(\d+)\)"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        print("Invalid regex")
        exit(1)
    }
    let range = NSRange(instructions.startIndex..<instructions.endIndex, in: instructions)

    let matches = regex.matches(in: instructions, range: range)
    return matches.map { match in
        let firstNumRange = Range(match.range(at: 1), in: instructions)!
        let secondNumRange = Range(match.range(at: 2), in: instructions)!
        let firstNum = Int(instructions[firstNumRange])!
        let secondNum = Int(instructions[secondNumRange])!
        let multiplication = firstNum * secondNum

        let matchRange = Range(match.range, in: instructions)!
        let lowerBound = instructions.distance(
            from: instructions.startIndex, to: matchRange.lowerBound)
        let upperBound = instructions.distance(
            from: instructions.startIndex, to: matchRange.upperBound)

        return (result: multiplication, range: (lower: lowerBound, upper: upperBound))
    }
}

func findMultiplications(instructions: String) {
    let pattern = #"mul\((\d+),(\d+)\)"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        print("Invalid regex")
        exit(1)
    }
    let range = NSRange(instructions.startIndex..<instructions.endIndex, in: instructions)
    var result = 0

    let matches = regex.matches(in: instructions, range: range)
    for match in matches {
        let firstNumRange = Range(match.range(at: 1), in: instructions)!
        let secondNumRange = Range(match.range(at: 2), in: instructions)!
        let firstNum = Int(instructions[firstNumRange])!
        let secondNum = Int(instructions[secondNumRange])!
        let multiplication = firstNum * secondNum
        result += multiplication
    }
}

func getMultiplyInstructions(filepath: String) -> String {
    if let contents = try? String(contentsOfFile: filepath, encoding: .utf8) {
        return contents
    }
    return ""
}
