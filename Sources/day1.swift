import Foundation

public func day1() {

    let filePath = "Sources/inputs/day1/part1.txt"
    let (list1, list2) = getInput(filePath: filePath)

    part1(list1: list1, list2: list2)
    part2(list1: list1, list2: list2)

}

func part1(list1: [Int], list2: [Int]) {
    let sortedList1 = list1.sorted(), sortedList2 = list2.sorted()
    guard list1.count == list2.count else {
        print("The two lists do not have the same number of elements!\nlist1 count: \(list1.count) list2 count: \(list2.count)")
        exit(1)
    }
    var totalDistance = 0
    for index in 0..<list1.count {
        let distance = abs(sortedList1[index] - sortedList2[index])
        totalDistance += distance
    }
    print("Part 1 answer: \(totalDistance)")
}

func part2(list1: [Int], list2: [Int]) {
    let list2Counts: [Int: Int] = getCounts(list: list2)
    var totalSimilarityScore = 0
    for n in list1 {
        let occurrences = list2Counts[n] ?? 0
        let similarityScore = n * occurrences 
        totalSimilarityScore += similarityScore
    }
    print("Part 2 answer: \(totalSimilarityScore)")
}

func getCounts(list: [Int]) -> [Int: Int] {
    var counts: [Int: Int] = [:]
    for n in list {
        counts[n, default: 0] += 1
    }
    return counts
}

func getInput(filePath: String) -> ([Int], [Int]) {
    var list1: [Int] = []
    var list2: [Int] = []
    if let contents = try? String(contentsOfFile: filePath, encoding: .utf8) {
        let lines = contents.components(separatedBy: .newlines)
        for line in lines {
            let parts = line.split(whereSeparator: \.isWhitespace)
            guard parts.count == 2 else {
                print("A line in the input contains the wrong number of items!")
                exit(1)
            }
            let num1 = Int(parts[0])!
            let num2 = Int(parts[1])!
            list1.append(num1)
            list2.append(num2)
        }
    }
    return (list1, list2)
}
