// ref: https://medium.com/one-two-swift/swift%E5%9F%BA%E7%A4%8E-%E9%8C%AF%E8%AA%A4%E8%99%95%E7%90%86-try-try-try-1339ab450dc6

enum result: Error {
    case err1
    case err2
}

func wrong() throws {
    throw result.err1
}

func correct() throws -> String {
    return "ok"
}

// try: we can know \(error) if error occurred
do {
    try wrong()
    print("res = \(res)")
} catch {
    print("error occured: \(error)")
}

// try?: we can't know \(error) if error occurred
if (try? wrong()) != nil {
    print("res = \(res)")
} else {
    print("error occured")
}

// try!: crash if error occurred
let res = try! correct()
print("res = \(res)")
