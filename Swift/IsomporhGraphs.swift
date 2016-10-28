import Foundation

struct Node<T: Hashable> {
    let name: T
    var neighbours: [Node<T>]

    var degree: Int {
        return neighbours.count
    }
}

struct Graph<T: Hashable>: Equatable {
    var nodes: [Node<T>]

    var edgeCount: Int {
        return nodes.reduce(0) { $0 + $1.degree }
    }

    init(with: [(T, [Bool])]) {
        nodes = with.map { Node(name: $0.0, neighbours: []) }
        for i in 0..<with.count {
            let neighbours = with[i].1
            for j in 0..<neighbours.count where neighbours[j] {
                nodes[i].neighbours.append(nodes[j])
            }
        }
    }
}

struct Bijketion<T: Hashable, V: Hashable> {
    let to: [T:V]
    let from: [V:T]

    func functionBy(mapping a: T, to b: V) -> Bijketion<T, V> {
        var to = self.to
        var from = self.from
        to[a] = b
        from[b] = a
        return Bijketion(to: to, from: from)
    }

    func functionBy(mapping: Node<T>, to: Node<V>) -> Bijketion<T, V> {
        return functionBy(mapping: mapping.name, to: to.name)
    }
}

func ==<T: Hashable,V: Hashable>(_ a: Graph<T>, _ b: Graph<V>) -> Bool {
    return equals(a, b)
}

func equals<T: Hashable, V: Hashable>(_ a: Graph<T>, _ b: Graph<V>, f: Bijketion<T,V> = Bijketion(to: [:], from: [:]), index: Int = 0) -> Bool {
    if a.edgeCount != b.edgeCount || a.nodes.count != b.nodes.count {
        return false
    }
    if index >= a.nodes.count {
        return true
    }
    let node = a.nodes[index]
    let possibleContraNodes = b.nodes.filter({ $0.degree == node.degree && f.from[$0.name] == nil })
    for other in possibleContraNodes {
        let expected = node.neighbours.map({ f.to[$0.name] }).flatMap { $0 }
        let real = other.neighbours.map({ $0.name }).flatMap { $0 }
        if expected.filter({ !real.contains($0) }).isEmpty {
            let copy = f.functionBy(mapping: node, to: other)
            if equals(a, b, f: copy, index: index + 1) {
                return true
            }
        }
    }
    return false
}

let g = [
    (1, [false, true, true, true]),
    (2, [true, false, true, true]),
    (3, [true, true, false, true]),
    (4, [true, true, true, false]),
]

let h = [
    ("Eins", [false, true, true, true]),
    ("Two", [true, false, true, true]),
    ("Trois", [true, true, false, true]),
    ("Cuatro", [true, true, true, false]),
]

let areEqual = Graph(with: g) == Graph(with: h)
print(areEqual)
