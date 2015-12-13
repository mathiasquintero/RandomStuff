//: Playground - noun: a place where people can play
import Foundation

enum GraphExceptions: ErrorType {
    case InvalidEdgeArray
}

class Node {
    internal var proximity: Int?
}

class Graph {
    
    private var edges: [Int]
    
    private var previousNodeFor = [Int]()
    
    private var nodes = [Node]()
    
    init(edges: [Int]) throws {
        let numberOfNodes = sqrt((Double) (edges.count))
        self.edges = edges
        for _ in 1...(Int)(numberOfNodes) {
            previousNodeFor.append(-1)
            nodes.append(Node())
        }
        if numberOfNodes % 1 != 0 {
            throw GraphExceptions.InvalidEdgeArray
        }
    }
    func getEdgeWeight(from: Int, to: Int) -> Int {
        return edges[from + nodes.count * to]
    }
    func getShortesPath(from: Int, to: Int) -> [Int]? {
        djikstra(from)
        if nodes[to].proximity == nil {
            return nil
        }
        var current = to
        var path = [Int]()
        while current != from {
            path.append(current)
            current = previousNodeFor[current]
        }
        path.append(from)
        return path.reverse()
    }
    
    func djikstra(from: Int) {
        var queue = [Int]()
        var done = [Bool]()
        for i in 0...(previousNodeFor.count-1) {
            previousNodeFor[i] = -1
            nodes[i].proximity = nil
            done.append(false)
        }
        previousNodeFor[from] = from
        nodes[from].proximity = 0
        queue.append(from)
        while !queue.isEmpty {
            queue.sortInPlace() { (first,second) in
                return nodes[first].proximity > nodes[second].proximity
            }
            if let currentNode = queue.popLast() {
                done[currentNode] = true
                for i in 0...(nodes.count-1) {
                    let weightOfEdge = getEdgeWeight(currentNode, to: i)
                    if weightOfEdge != 0 && !done[i] {
                        let candidateForProximity = nodes[currentNode].proximity! + weightOfEdge
                        if let pathWeight = nodes[i].proximity {
                            if pathWeight > candidateForProximity{
                                nodes[i].proximity = candidateForProximity
                                previousNodeFor[i] = currentNode
                            }
                        } else {
                            nodes[i].proximity = candidateForProximity
                            previousNodeFor[i] = currentNode
                        }
                    }
                    if !queue.contains(i) && !done[i] {
                        queue.append(i)
                    }
                }
            }
        }
    }
}

let array = [0,0,0,2,0,0,9,3,0]

do {
    let algorithm = try Graph(edges: array)
    algorithm.djikstra(0)
    algorithm.previousNodeFor
    algorithm.getShortesPath(0, to: 2)
} catch {
    
}


