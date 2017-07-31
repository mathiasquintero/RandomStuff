
import Foundation

// This is FizzBuzz. The Overengineered Way

func +(lhs: String?, rhs: String) -> String {
    return lhs.map { "\($0)\(rhs)" } ?? rhs
}

func fizzbuzz(of number: Int, using items: (Int, String)...) -> String {
    return items.reduce(nil) { number % $1.0 == 0 ? $0 + $1.1 : $0 } ?? String(number)
}

func play(until limit: Int) {
    (0..<limit).forEach { n in
        let output = fizzbuzz(of: n, using: (3, "Fizz"), (5, "Buzz"))
        print(output)
    }
}

play(until: 100)
