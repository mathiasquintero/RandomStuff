import Foundation

// You might remember this from before
enum MatchedArray<Value> {
    case some(head: Value, tail: [Value])
    case empty
}

extension Array {
    
    func match() -> MatchedArray<Element> {
        guard let first = self.first else {
            return .empty
        }
        return .some(head: first, tail: Array(self.dropFirst()))
    }
    
}

class Node {
    var inside = 0
    var nodes = [UnicodeScalar : Node]()
}

extension Node {
    
    var count: Int {
        return nodes.reduce(inside) { $0 + $1.value.count }
    }
    
}

extension Node {
    
    func add(_ scalars: [UnicodeScalar]) {
        guard case .some(let head, let tail) = scalars.match() else {
            inside += 1
            return
        }
        nodes[head] = nodes[head] ?? Node()
        nodes[head]?.add(tail)
    }
    
    func find(_ scalars: [UnicodeScalar]) -> Node? {
        guard case .some(let head, let tail) = scalars.match() else {
            return self
        }
        return nodes[head]?.find(tail)
    }
    
}

class Contacts {
    let node = Node()
}

extension Contacts {
    
    func add(name: String) {
        node.add(Array(name.lowercased().unicodeScalars))
    }
    
    func find(partial: String) -> Int {
        let partial = partial.lowercased()
        return node.find(Array(partial.unicodeScalars))?.count ?? 0
    }
    
}

enum Command {
    case add(name: String)
    case find(partial: String)
}

extension Command {
    
    static func read() -> Command? {
        guard let line = readLine() else { return nil }
        let parts = line.components(separatedBy: " ").filter { $0 != "" }
        switch (parts.first, parts.last) {
        case (.some("add"), .some(let name)):
            return .add(name: name)
        case (.some("find"), .some(let partial)):
            return .find(partial: partial)
        default:
            return nil
        }
    }
    
}

func readInt() -> Int? {
    guard let line = readLine() else {
        return nil
    }
    return Int(line)
}

let lines = readInt()
let contacts = Contacts()
lines.map({ (0..<$0) })?.forEach { _ in

    guard let command = Command.read() else {
        return
    }
    switch command {
        case .add(let name):
            contacts.add(name: name)
        case .find(let partial):
            print(contacts.find(partial: partial))
    }
}
