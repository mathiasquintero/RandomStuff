
import Foundation

// Fizzbuzz. The Overengineered Way

func +(lhs: String?, rhs: String) -> String {
    return lhs.map { "\($0)\(rhs)" } ?? rhs
}

func fizzbuzz(of number: Int, using items: (Int, String)...) -> String {
    return items.reduce(nil) { number % $1.0 == 0 ? $0 + $1.1 : $0 } ?? String(number)
}

func play(until limit: Int) -> String {
    return (0..<limit).map { fizzbuzz(of: $0, using: (3, "Fizz"), (5, "Buzz")) }
                      .joined(separator: "\n")
}

let game = play(until: 100)
print(game)
