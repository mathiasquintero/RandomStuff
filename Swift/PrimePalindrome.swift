import Foundation

extension String {

    var isPalindrome: Bool {
        if characters.count < 2 {
            return true
        }
        if characters.first != characters.last {
            return false
        }
        let range = index(after: startIndex)..<index(before: endIndex)
        return substring(with: range).isPalindrome
    }

}

extension Int {

    var isPrime: Bool {
        let bound = Int(sqrt(Double(self))) + 1
        return (2...bound)
            .filter { self % $0 == 0 }
            .isEmpty
    }

    var isPalindrome: Bool {
        return description.isPalindrome
    }

}

// Task: Find the biggest number that's a prime and a palindrome under 1000

let last = (2...1000)
    .filter { $0.isPalindrome && $0.isPrime }
    .last

print(last)
