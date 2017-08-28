import Foundation

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

struct Contacts {
    let names: [String]
    
    func adding(name: String) -> Contacts {
        return Contacts(names: names + [name])
    }
    
    func find(partial: String) -> [String] {
        let partial = partial.lowercased()
        return names.filter { $0.lowercased().contains(partial) }
    }
    
}

let _ = readLine()
var contacts = Contacts(names: [])
while let command = Command.read() {
    switch command {
        case .add(let name):
            contacts = contacts.adding(name: name)
        case .find(let partial):
            print(contacts.find(partial: partial).count)
    }
}