enum card: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    func name() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

let one = card.ace
print(one)

let poke = card(rawValue: 3) 
let name = poke?.name()
print(name ?? "")




enum ServerResponse {
    case result(Int, String)
    case failure(Int, String)
}

let success = ServerResponse.result(200, "OK")
let failure = ServerResponse.failure(404, "Not Found")

switch success {
case let .result(code, info):
    print("Success: \(code) \(info)")
case let .failure(code, info):
    print("Fail: \(code) \(info)")
}
