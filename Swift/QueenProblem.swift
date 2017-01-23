import Foundation

let coordinates = (0..<8).map { item in
    (0..<8).map { (item, $0) }
}

protocol ChessPiece {
    var x: Int { get }
    var y: Int { get }
    var representation: String { get }
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
    
    var representation: String {
        return "Q"
    }
    
    func canAttack(x: Int, y: Int) -> Bool {
        return self.x == x || self.y == y || abs(self.x - x) == abs(self.y - y)
    }
}

extension Collection where Iterator.Element == ChessPiece {
    
    func representation(x: Int, y: Int) -> String {
        return reduce(" ") { ($1.x == x && $1.y == y) ? $1.representation : $0 }
    }
    
    func fits(x: Int, y: Int) -> Bool {
        return reduce(true) { $0 && !$1.canAttack(x: x, y: y) }
    }
    
    func prettyPrint() {
        let string = coordinates.reduce("") { board, row in
            return board + row.reduce("") { row, item in
                return row + "|\(self.representation(x: item.0, y: item.1))"
            } + "|\r\n"
        }
        print(string)
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
                let current = current + [Queen(x: x, y: y) as ChessPiece]
                return results + boards(basedOn: current, y: y + 1)
            }
    
}

// Task: Find all configurations of 8 Queens in a chess board
// where no queen can Attack another one

let result = boards()
print("Finished with \(result.count) possibilities:\n")
result.forEach { $0.prettyPrint() }
