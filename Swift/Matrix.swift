import Foundation

// I wanted to write Matix multiplication without ever using a loop
// or an index

typealias Vector = [Double]
typealias Matrix = [Vector]

infix operator ++

func *(lhs: Vector, rhs: Vector) -> Double {
    return zip(lhs, rhs).reduce(0) { $0 + $1.0 * $1.1 }
}

func ++(lhs: Matrix, rhs: Vector) -> Matrix {
    return zip(lhs, rhs).map { $0 + [$1] }
}

extension Array where Element == Vector {
    
    static func of(length: Int) -> Matrix {
        return (0..<length).map { _ in [] }
    }
    
    func transposed() -> Matrix {
        guard let count = first?.count else { return [] }
        return reduce(.of(length: count)) { $0 ++ $1 }
    }
    
}

func *(lhs: Matrix, rhs: Matrix) -> Matrix {
    let rhs = rhs.transposed()
    return lhs.reduce([]) { matrix, vector in
        return matrix + [rhs.map { $0 * vector }]
    }
}

let a = [
    [2.0, 3.0],
    [4.0, 5.0]
]

let b = [
    [2.0, 3.0],
    [4.0, 5.0]
]

a * b
