var var1 = 1
var result: String

if var1 > 2 {
    result = "greater"
} else {
    result = "less"
}

print(result)

let result2 = var1 > 2 ? "greater" : "less"
print(result2)


// Optional variable (see variable)
let var2: String? = nil
if let name = var2 {
    print("Hi, \(name)")
}
