import Foundation

struct Foo: Codable {
    var a: Int
    var b: String
}

let foo: Foo = Foo(a: 1, b: "b")
let encoder: JSONEncoder = JSONEncoder()
let encoded = try? encoder.encode(foo)
        
let decoder: JSONDecoder = JSONDecoder()
let decoded = try? decoder.decode(Foo.self, from: encoded!)

print(type(of: encoded), encoded! as NSData)
print(type(of: decoded), decoded ?? "")
