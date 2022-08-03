// declare variables with type
var var1: String
var var2: Int
var var3: Float
var var4: Double

var1 = "this is string"
var2 = 1
var3 = 1.1
var4 = 1.11


// declare variables without type
var var5 = "this is var5"
var var6 = 1

var5 = "can change"
// var6 = "error: cannot assign value of type 'String' to type 'Int'"


// let => constant variable
let var7 = "this is a constant variable"
// var7 = "cannot assign to value: 'var7' is a 'let' constant"

let var8: Double = 70 // tell compiler that var8 is type of Double instead of Int


// implicit type conversion
let var9 = "The width is "
let var10 = 94
let var11 = var9 + String(var10) // without convertion => binary operator '+' cannot be applied to operands of type 'String' and 'Int'
print(var11)

let var12 = 3
let var13 = "I have \(var12) apples."
print(var13)


// three quotation marks => multilines
let var14 = """
line1
line2
"""
print(var14)


// list
print("\n\nlist:")
var var15 = ["a", "b", "c"]
var15[0] = "A"
var15.append("d")
print(var15)
print("sorted big -> small: \(var15.sorted { $0 > $1 })")

var15 = []
print("after clean: \(var15)")



// dictionary
print("\n\ndictionary:")
var var16 = ["a":1, "b":2]
var16["c"] = 3
print(var16)
var16 = [:]
print("after clean: \(var16)")


// string
print("\n\nstring:")
var var17 = "abc"
var var18 = "123"
var var19 = var17 + var18 // concat
var var20 = "\u{1F30A}\u{871C}"

var19.append("ABC")
print("length of \(var19) is \(var19.count)")

print(var19[var19.index(var19.startIndex, offsetBy: 1)])  // O(n) => user unfriendly
print(var19, var19.utf8, var19.utf16, var19.unicodeScalars, var20)

//// substring
let head = var19.index(var19.startIndex, offsetBy: 1)
let tail = var19.index(var19.endIndex, offsetBy: -1)
let var21 = var19[head..<tail]
print(var21)


// NSString (NS: NextStep)
// ref: https://stackoverflow.com/questions/473758/what-does-the-ns-prefix-mean
import Foundation
let nStr: NSString = "🏂 costs ￥"
let sStr: String = nStr as String

print(nStr, sStr)
print(sStr.components(separatedBy: " "))


// Optional variable (add '?' after type, the value of this variable can be nil or something)
print("\n\nOptional variable:")
let var22: Int? = nil
let var23: Int = 100
let var24 = var22 ?? var23 // var24 == var23 if var22 == nil else var23
print(var24)


// get variable type
print(type(of: var24))


// pointer
// TBD
