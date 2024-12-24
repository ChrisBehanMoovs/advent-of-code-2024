func day7() {
    print("Day 7")
    let equations = getEquations(filepath: "Sources/inputs/day7/input.txt")
    part1(equations)
}

func part1(_ equations: [(Int, [Int])]) {
    var resultSum = 0
    for (result, nums) in equations {
        let results = possibleResults(nums: nums)
        if results.contains(result) {
            resultSum += result
        }
    }
    print("Part 1 ans: \(resultSum)")
}

func getEquations(filepath: String) -> [(Int, [Int])] {
    let input = try! String(contentsOfFile: filepath)
    let equationStrings = input.components(separatedBy: .newlines)
    let equations = equationStrings.map { line in
        let parts = line.components(separatedBy: ":")
        let result = Int(parts[0])!
        let nums = parts[1].trimmingCharacters(in: .whitespaces).components(
            separatedBy: .whitespaces
        ).map { Int($0)! }
        return (result, nums)
    }
    return equations
}

func possibleResults(nums: [Int]) -> Set<Int> {
    var results: Set<Int> = []
    func recurse(cur: Int, nums: [Int]) {
        if nums.isEmpty {
            results.insert(cur)
            return
        }
        recurse(cur: cur + nums[0], nums: Array(nums.dropFirst()))
        recurse(cur: cur * nums[0], nums: Array(nums.dropFirst()))
    }
    recurse(cur: 0, nums: nums)
    return results
}
