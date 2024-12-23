import Foundation

struct position {
    var x: Int
    var y: Int
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
    let map = getMap(filepath: "Sources/inputs/day6/input.txt")
    part1(map: map)
}

func getMap(filepath: String) -> [[Character]] {
    let input = try! String(contentsOfFile: filepath)
    let map = input.components(separatedBy: .newlines).map { Array($0) }
    return map
}

func findGuard(map: [[Character]]) -> (position, Character) {
    for y in 0..<map.count {
        for x in 0..<map[0].count {
            if ["^", ">", "V", "<"].contains(map[y][x]) {
                return (position(x: x, y: y), map[y][x])
            }
        }
    }
    return (position(x: -1, y: -1), " ")
}

func part1(map: [[Character]]) {
    var MapForTracking = map
    var MapForMoving = map
    var (pos, dir) = findGuard(map: MapForMoving)
    while true {
        (pos, dir) = moveGuard(map: &MapForMoving, trackMap: &MapForTracking, pos: pos, dir: dir)
        if pos.x == -1 {
            break
        }
    }
    let count = MapForTracking.reduce(0) { acc, row in
        acc + row.filter { $0 == "X" }.count
    }
    print("Part 1 answer: \(count)")
}

func markVisited(map: inout [[Character]], pos: position) {
    map[pos.y][pos.x] = "X"
}

func canMoveOnSpace(map: inout [[Character]], pos: position) -> Bool {
    return map[pos.y][pos.x] == "."
}

func isInBounds(pos: position, map: [[Character]]) -> Bool {
    return pos.x >= 0 && pos.x < map[0].count && pos.y >= 0 && pos.y < map.count
}

func moveGuard(
    map: inout [[Character]], trackMap: inout [[Character]], pos: position, dir: Character
) -> (position, Character) {
    let (yChange, xChange) = velocity[dir]!
    let nextPos = position(x: pos.x + xChange, y: pos.y + yChange)

    if !isInBounds(pos: nextPos, map: map) {
        markVisited(map: &trackMap, pos: pos)
        return (position(x: -1, y: -1), " ")
    }

    if canMoveOnSpace(map: &map, pos: nextPos) {  
        map[pos.y][pos.x] = "."
        trackMap[pos.y][pos.x] = "X"
        map[nextPos.y][nextPos.x] = dir
        return (nextPos, dir)
    } else {  
        let newDir = rotate[dir]!
        map[pos.y][pos.x] = newDir
        return (pos, newDir)
    }
}
