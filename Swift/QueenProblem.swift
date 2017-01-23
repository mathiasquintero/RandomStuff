import Foundation

protocol ChessPiece {
    var x: Int { get }
    var y: Int { get }
    init(x: Int, y: Int)
    func canAttack(x: Int, y: Int) -> Bool
}

extension ChessPiece {
    
    func canAttack(_ other: ChessPiece) -> Bool {
        return canAttack(x: other.x, y: other.y)
    }
    
}

struct Queen: ChessPiece {
    let x: Int
    let y: Int
    
    func canAttack(x: Int, y: Int) -> Bool {
        if self.x == x || self.y == y {
            return true
        }
        if abs(self.x - x) == abs(self.y - y) {
            return true
        }
        return false
    }
}

extension Collection where Iterator.Element == ChessPiece {
    
    func fits(x: Int, y: Int) -> Bool {
        return filter { $0.canAttack(x: x, y: y) }
                .isEmpty
    }
    
}

typealias Board = [ChessPiece]

func boards(basedOn current: Board = [], y: Int = 0) -> [Board] {
    if current.count == 8 {
        return [current]
    }
    return (0..<8)
            .filter { current.fits(x: $0, y: y) }
            .reduce([]) { results, x in
                var current = current
                current.append(Queen(x: x, y: y))
                var results = results
                results.append(contentsOf: boards(basedOn: current, y: y + 1))
                return results
            }
    
}

// Task: Find all configurations of 8 Queens in a chess board
// where no queen can Attack another one

let result = boards()

print("\(result.count) possibilities:")
print(result)
