import Foundation

struct position: Hashable {
    var x: Int
    var y: Int
    var dir: Character
}

let velocity: [Character: (Int, Int)] = [
    "^": (-1, 0),
    ">": (0, 1),
    "V": (1, 0),
    "<": (0, -1),
]

let rotate: [Character: Character] = [
    "^": ">",
    ">": "V",
    "V": "<",
    "<": "^",
]

func day6() {
    print("Day 6")
    let map = getMap(filepath: "Sources/inputs/day6/input.txt")
    part1(map: map)
    part2(map: map)
}

func getMap(filepath: String) -> [[Character]] {
    let input = try! String(contentsOfFile: filepath)
    let map = input.components(separatedBy: .newlines).map { Array($0) }
    return map
}

func findGuard(map: [[Character]]) -> position {
    for y in 0..<map.count {
        for x in 0..<map[0].count {
            if ["^", ">", "V", "<"].contains(map[y][x]) {
                return position(x: x, y: y, dir: map[y][x])
            }
        }
    }
    return position(x: -1, y: -1, dir: " ")
}

func part1(map: [[Character]]) {
    // var MapForTracking = map
    var MapForMoving = map
    var pos = findGuard(map: MapForMoving)
    while true {
        pos = moveGuard(map: &MapForMoving, pos: pos)
        if pos.x == -1 {
            break
        }
    }
    let count = MapForMoving.reduce(0) { acc, row in
        acc + row.filter { $0 == "X" }.count
    }
    print("Part 1 answer: \(count)")
}

func markVisited(map: inout [[Character]], pos: position) {
    map[pos.y][pos.x] = "X"
}

func canMoveOnSpace(map: inout [[Character]], pos: position) -> Bool {
    return map[pos.y][pos.x] == "." || map[pos.y][pos.x] == "X"
}

func isInBounds(pos: position, map: [[Character]]) -> Bool {
    return pos.x >= 0 && pos.x < map[0].count && pos.y >= 0 && pos.y < map.count
}

func moveGuard(
    map: inout [[Character]], pos: position
) -> (position) {
    let (yChange, xChange) = velocity[pos.dir]!
    let nextPos = position(x: pos.x + xChange, y: pos.y + yChange, dir: pos.dir)

    if !isInBounds(pos: nextPos, map: map) {
        markVisited(map: &map, pos: pos)
        return position(x: -1, y: -1, dir: " ")
    }

    if canMoveOnSpace(map: &map, pos: nextPos) {
        markVisited(map: &map, pos: pos)
        return nextPos
    } else {
        let rotatedPos = position(x: pos.x, y: pos.y, dir: rotate[pos.dir]!)
        return rotatedPos
    }
}

func isStuckInLoop(map: inout [[Character]], startingPos: position) -> Bool {
    var visited: Set<(position)> = []
    var pos = findGuard(map: map)
    while !visited.contains(pos) {
        visited.insert(pos)
        pos = moveGuard(map: &map, pos: pos)
        if pos.x == -1 {  // left map
            return false
        }
    }
    return true
}

func part2(map: [[Character]]) {
    var loopCount = 0
    let startingPos = findGuard(map: map)
    for y in 0..<map.count {
        for x in 0..<map[0].count {
            var newMap = map
            guard newMap[y][x] == "." else {
                continue
            }
            newMap[y][x] = "#"
            if isStuckInLoop(map: &newMap, startingPos: startingPos) {
                loopCount += 1
            }
        }
    }
    print("Part 2 answer: \(loopCount)")
}
