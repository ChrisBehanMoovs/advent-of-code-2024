import Foundation

typealias Rules = [Int: Set<Int>]

public func day5() {
    let (rules, updates) = getRulesAndUpdates(path: "Sources/inputs/day5/input.txt")
    // print(rules)
    part1(rules:rules, updates:updates) 
    part2(rules: rules, updates:updates)
}
func part1(rules: Rules, updates: [[Int]]) {
    var ans = 0
    for update in updates {
        let inOrder = isUpdateInOrder(update: update, rules: rules)
        if inOrder {
            ans += getMiddle(nums: update)
        }
    }
}

func part2(rules: Rules, updates: [[Int]]) {
    var outOfOrder: [[Int]] = []
    for update in updates {
        if !isUpdateInOrder(update: update, rules: rules) {
            outOfOrder.append(update)
        }
    }
    let ordered = orderUpdates(updates: outOfOrder, rules: rules)
    var ans = 0
    for o in ordered {
        ans += getMiddle(nums: o)
    }
    print(ans)
}

func getRulesAndUpdates(path: String) -> (Rules, [[Int]]) {
    let content = try! String(contentsOfFile: path, encoding: .utf8)
    let parts = content.components(separatedBy: "\n\n")

    let ruleString = parts[0]
    let rules = ruleString.components(separatedBy: "\n")
        .map { rule in
            let parts = rule.components(separatedBy: "|")
            let before = parts[0]
            let after = parts[1]
            return (before, after)
        }
    var ruleMap: Rules = [:]
    for (before, after) in rules {
        ruleMap[Int(before)!, default: Set()].insert(Int(after)!)
    }

    let updateString = parts[1]
    let updates = updateString.components(separatedBy: "\n").map { update in
        let numsString = update.components(separatedBy: ",")
        return numsString.map { Int($0)! }
    }
    return (ruleMap, updates)
}

func isUpdateInOrder(update: [Int], rules: Rules) -> Bool {
    for (index, num) in update.enumerated() {
        if index == update.count-1 {
            break
        } 
        let remaining = update[(index+1)...]
        for r in remaining {
            if rules[r, default: Set()].contains(num) {
                return false
            }
        }
    }
    return true
}

func getMiddle(nums: [Int]) -> Int {
    let mid = nums.count / 2
    return nums[mid]
}

func orderUpdates(updates: [[Int]], rules: Rules) -> [[Int]] {
    var orderedUpdates: [[Int]] = []
    for u in updates {
        orderedUpdates.append(sort(nums:u, rules:rules))
    }
    return orderedUpdates
}

// [97: Set([61, 47, 53, 29, 75, 13]), 
// 29: Set([13]), 61: Set([53, 13, 29]), 
// 53: Set([29, 13]), 
// 75: Set([13, 53, 61, 29, 47]),
// 47: Set([61, 29, 53, 13])]

func sort(nums: [Int], rules: Rules) -> [Int] {
    var sorted = nums
    for i in 0..<sorted.count {
        for j in i+1..<sorted.count {
            let currentNum = sorted[i]
            let shouldSwap = rules[sorted[j], default: Set()].contains(currentNum) 
            if shouldSwap {
                sorted.swapAt(i, j)
            } 
        }
    }
    return sorted
}

// 75,97,47,61,53 becomes 97,75,47,61,53
/*
75, 97, 47, 61, 53
97, 75, 47, 61, 53 
*/