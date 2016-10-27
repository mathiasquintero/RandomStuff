import Foundation

struct Queen {
    let x: Int
    let y: Int

    func canAttack(_ other: Queen) -> Bool {
        if other.x == x || other.y == y {
            return true
        }
        if abs(other.x - x) == abs(other.y - y) {
            return true
        }
        return false
    }
}

extension Collection where Iterator.Element == Queen {

    func fits(x: Int, y: Int) -> Bool {
        let queen = Queen(x: x, y: y)
        return filter { $0.canAttack(queen) }
            .isEmpty
    }

}

func board(_ current: [Queen] = [], y: Int = 0) -> [Queen]? {
    if current.count == 8 {
        return current
    }
    for x in 0..<8 where current.fits(x: x, y: y) {
        var copy = current
        copy.append(Queen(x: x, y: y))
        if let newBoard = board(copy, y: y + 1) {
            return newBoard
        }
    }
    return nil
}

// Task: Find a configuration of 8 Queens in a chess board
// where no queen can Attack another one

let result = board()?.map { (x: $0.x, y: $0.y) } ?? []

print(result)
