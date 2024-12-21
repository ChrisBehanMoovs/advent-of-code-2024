import Foundation

struct Point: Hashable {
    let row: Int
    let col: Int
}

func day4() {
    let filepath = "Sources/inputs/day4/input.txt"
    let grid = getWordSearchInput(filepath: filepath)
    part1(grid:grid)
    part2(grid:grid)
}

func part1(grid: [[String.Element]]) {
    var count = 0
    for row in 0..<grid.count {
        for col in 0..<grid[0].count {
            count += xmassCount(row: row, col: col, grid: grid)
        }
    }
    print(count)
}

func part2(grid: [[String.Element]]) {
    var count = 0
    for row in 0..<grid.count {
        for col in 0..<grid[0].count {
            if isXmass(row: row, col: col, grid: grid) {
                count += 1
            }
        }
    }
    print(count)
}

func getWordSearchInput(filepath: String) -> [[String.Element]] {
    let contents = try! String(contentsOfFile: filepath)
    var input = contents.components(separatedBy: .newlines).map { Array($0) }
    return input
}

func getStraightLineCoords(row: Int, col: Int) -> [[(Int, Int)]] {
    let leftCoords = [(row, col - 1), (row, col - 2), (row, col - 3)]
    let rightCoords = [(row, col + 1), (row, col + 2), (row, col + 3)]
    let upCoords = [(row - 1, col), (row - 2, col), (row - 3, col)]
    let downCoords = [(row + 1, col), (row + 2, col), (row + 3, col)]
    let upLeftDiagonal = [(row - 1, col - 1), (row - 2, col - 2), (row - 3, col - 3)]
    let upRightDiagonal = [(row - 1, col + 1), (row - 2, col + 2), (row - 3, col + 3)]
    let downRightDiagonal = [(row + 1, col + 1), (row + 2, col + 2), (row + 3, col + 3)]
    let downLeftDiagonal = [(row + 1, col - 1), (row + 2, col - 2), (row + 3, col - 3)]
    return [
        leftCoords, rightCoords, upCoords, downCoords, upLeftDiagonal, upRightDiagonal,
        downLeftDiagonal, downRightDiagonal,
    ]
}

func xmassCount(row: Int, col: Int, grid: [[String.Element]]) -> Int {
    let directionCoords = getStraightLineCoords(row: row, col: col)
    var count = 0
    for coords in directionCoords {
        var word = String(grid[row][col])
        for (x, y) in coords {
            if x < 0 || x >= grid.count || y < 0 || y >= grid[0].count {
                break
            }
            word += String(grid[x][y])
        }
        if word == "XMAS" {
            count += 1
        }
    }
    return count
}

func isXmass(row: Int, col: Int, grid: [[String.Element]]) -> Bool {
    let diag1 = [(row - 1, col - 1), (row, col), (row + 1, col + 1)]
    let diag2 = [(row + 1, col - 1), (row, col), (row - 1, col + 1)]
    guard inBounds(coords: diag1, grid: grid) && inBounds(coords: diag2, grid: grid) else {
        return false
    }
    let word1 =  String(grid[diag1[0].0][diag1[0].1]) + String(grid[diag1[1].0][diag1[1].1]) + String(grid[diag1[2].0][diag1[2].1])
    let word2 =  String(grid[diag2[0].0][diag1[0].1]) + String(grid[diag2[1].0][diag2[1].1]) + String(grid[diag2[2].0][diag2[2].1])
    return (word1 == "MAS" || word1 == "SAM") && (word2 == "MAS" || word2 == "SAM")
}

func inBounds(coords: [(Int, Int)], grid: [[String.Element]]) -> Bool {
    for (x, y) in coords {
        if x < 0 || x >= grid.count || y < 0 || y >= grid[0].count {
            return false
        }
    }
    return true
}
