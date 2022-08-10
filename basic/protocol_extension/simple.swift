protocol Number {
    var floatValue: Float { get } // the { get } means that the variable must be read only
}

extension Float: Number {
    var floatValue: Float {
        return self
    }
}

extension Double: Number {
    var floatValue: Float {
        return Float(self)
    }
}

extension Int: Number {
    var floatValue: Float {
        return Float(self)
    }
}

extension UInt: Number {
    var floatValue: Float {
        return Float(self)
    }
}


func +(lhs: Number, rhs: Number) -> Float {
    print("\(lhs) + \(rhs)")
    return lhs.floatValue + rhs.floatValue
}

func -(lhs: Number, rhs: Number) -> Float {
    print("\(lhs) - \(rhs)")
    return lhs.floatValue - rhs.floatValue
}

func *(lhs: Number, rhs: Number) -> Float {
    print("\(lhs) * \(rhs)")
    return lhs.floatValue * rhs.floatValue
}

func /(lhs: Number, rhs: Number) -> Float {
    print("\(lhs) / \(rhs)")
    return lhs.floatValue / rhs.floatValue
}

let x: Double = 1.2345
let y: Int = 5
let q = x / y //compiles properly

print(q)
