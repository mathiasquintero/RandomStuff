import Foundation

extension String {
    
    var occurenceMap: [UnicodeScalar : Int] {
        return unicodeScalars.reduce([:]) { dictionary, scalar in
            var dictionary = dictionary
            dictionary[scalar] = dictionary[scalar].map { $0 + 1 } ?? 1
            return dictionary
        }
    }
    
}

func distance(lhs: String, rhs: String) -> Int {
    let lhs = lhs.occurenceMap
    let rhs = rhs.occurenceMap
    let keys = Set(lhs.keys).union(rhs.keys)
    return keys.reduce(0) { sum, scalar in
        let left = lhs[scalar] ?? 0
        let right = rhs[scalar] ?? 0
        return sum + abs(left - right)
    }
}

guard let first = readLine(),
    let second = readLine() else {
    
    fatalError()
}

let result = distance(lhs: first, rhs: second)
print(result)



