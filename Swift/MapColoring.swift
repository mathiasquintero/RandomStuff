import Foundation

enum Color {
    static let colors: [Color] = [.red, .blue, .green]
    case red, blue, green
}

class State {
    let name: String
    var neighbours = [State]()
    var color: Color?

    init(name: String) {
        self.name = name
    }

    func canPaint(_ color: Color) -> Bool {
        return neighbours
            .filter { $0.color == color }
            .isEmpty
    }
}

typealias Country = [State]

func getColors(states: [State], index: Int = 0) -> [State]? {
    if index >= states.count {
        return states
    }
    let state = states[index]
    if state.color != nil {
        return getColors(states: states, index: index + 1)
    }
    for color in Color.colors where state.canPaint(color) {
        state.color = color
        if let result = getColors(states: states, index: index + 1) {
            return result
        }
    }
    return nil
}

var australia: Country {
    let wa = State(name: "West Australia")
    let nt = State(name: "Northern Territory")
    let sa = State(name: "South Australia")
    let q = State(name: "Queensland")
    let nsw = State(name: "New South Wales")
    let v = State(name: "Victoria")
    let t = State(name: "Tasmania")

    wa.neighbours = [nt, sa]
    nt.neighbours = [wa, sa, q]
    sa.neighbours = [wa, nt, q, nsw, v]
    q.neighbours = [nt, sa, nsw, v]
    nsw.neighbours = [q, sa, v]
    v.neighbours = [sa, nsw]

    return [wa, nt, sa, q, nsw, v, t]
}

extension State {

    var descriptionWithColoring: String {
        if let color = color {
            return "\(name): \(String(describing: color))"
        }
        return name
    }

}

let coloredMap = getColors(states: australia)?.map { $0.descriptionWithColoring } ?? []
print(coloredMap)
