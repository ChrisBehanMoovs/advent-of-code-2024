
func day2(){
    let filepath = "Sources/inputs/day2/input.txt"
    let reports = getReports(filepath: filepath)
    print("Day 2")
    part1(reports: reports)
    part2(reports: reports)
}

func part1(reports: [[Int]]) {
    var safeCount = 0
    var unsafeCount = 0
    for r in reports {
        
        let safe = isSafeReport(report: r)
        if safe {
            safeCount += 1
        } else {
            unsafeCount += 1
        }
    }
    print("Part 1 answer: \(safeCount)")
}

func isSafeReport(report: [Int]) -> Bool{
     var safe = true
        for index in 1..<report.count{
            let diff = abs(report[index - 1] - report[index])
            if !(diff == 1  || diff == 2 || diff == 3) {
                safe = false
                break
            }
        }
        if !allAscendingOrDescending(nums: report) {
            safe = false
        }
    return safe
}

func allAscendingOrDescending(nums: [Int]) -> Bool {
    if nums == nums.sorted() {
        return true
    } else if nums == nums.sorted(by: >) {
        return true
    } else {
        return false
    }
}

func getReports(filepath: String) -> [[Int]] {
    var reports: [[Int]] = []
    if let contents = try? String(contentsOfFile: filepath, encoding: .utf8) {
        let lines = contents.components(separatedBy: .newlines)
        for l in lines {
            let nums = l.components(separatedBy: .whitespaces).compactMap{str in return Int(str)}
            reports.append(nums)

        }
    }
    return reports
}

func part2(reports: [[Int]]) {
    var safeCount = 0
    for r in reports {
        let reportPermutations = permutations(report: r)
        let safeReport = reportPermutations.contains(where:isSafeReport(report:))
        if safeReport {
            safeCount += 1
        }
    }
    print("Part 2 answer: \(safeCount)")

}

func permutations(report: [Int]) -> [[Int]] {
    var permutations: [[Int]] = []
    for i in 0..<report.count{
        var temp = report
        temp.remove(at: i)
        permutations.append(temp)
    }
    return permutations
}