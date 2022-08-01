struct Card {
    init(rank: Int, suit: String) {
        self.rank = rank
        self.suit = suit
    }

    func info() -> String {
        return "The \(rank) of \(suit)"
    }

    var rank: Int
    var suit: String
}

let threeOfSpades = Card(rank: 3, suit: "spade")
let info = threeOfSpades.info()

print(info)
