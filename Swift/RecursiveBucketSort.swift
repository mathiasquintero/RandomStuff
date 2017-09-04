
import Foundation

infix operator **

func **(lhs: UInt, rhs: UInt) -> UInt {
    return UInt(pow(Double(lhs), Double(rhs)))
}

struct Node {
    let base: UInt
    let depth: UInt
    let digit: UInt
    
    var currentCount: UInt
    
    var children: [UInt : Node]
    
    init(base: UInt, depth: UInt, digit: UInt) {
        self.base = base
        self.depth = depth
        self.digit = digit
        currentCount = 0
        children = [:]
    }
}

extension Node {
    
    var value: UInt {
        return digit * (base ** depth)
    }
    
    var sorted: [UInt] {
        let here = currentCount < 1 ? [] : (0..<currentCount).map { _ in value }
        return here + (0..<base).flatMap { children[$0]?.sorted ?? [] }
                                .map { value + $0 }
    }
    
}

extension Node {
    
    mutating func append(_ element: UInt) {
        guard element > value, depth > 0 else {
            currentCount += 1
            return
        }
        let upper = element % (base ** depth)
        let lower = element % (base ** (depth - 1))
        let digit = (upper - lower) / (base ** (depth - 1))
        var node = children[digit] ?? Node(base: base, depth: depth - 1, digit: digit)
        node.append(upper)
        children[digit] = node
    }
    
}

struct Sorter {
    var negative: Node
    var positive: Node
    
    init(base: UInt, depth: UInt) {
        negative = Node(base: base, depth: depth, digit: 0)
        positive = Node(base: base, depth: depth, digit: 0)
    }
}

extension Sorter {
    
    mutating func append(_ element: Int) {
        if element >= 0 {
            positive.append(UInt(element))
        } else {
            negative.append(UInt(-element))
        }
    }
    
    var sorted: [Int] {
        return negative.sorted.map({ -Int($0) }).reversed() + positive.sorted.map { Int($0) }
    }
    
}

extension Sorter {
    
    static func sort(elements: [Int], using base: UInt = 16, and depth: UInt = 10) -> [Int] {
        var sorter = Sorter(base: base, depth: depth)
        elements.forEach { sorter.append($0) }
        return sorter.sorted
    }
    
}
