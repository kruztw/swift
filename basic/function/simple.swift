func add(a: Int, b: Int) -> Int {
    return a + b
}

print(add(a:1, b:2))




func sub(_ a: Int, _ b: Int) -> Int {
    return a - b
}

print(sub(1, 2))




func multi(vals: [Int]) -> Int {
    if vals.count < 2 {
	return -1
    }

    return vals[0] * vals[1]
}

print(multi(vals: [2, 3]))




func div(a: Int, b: Int) -> (quotient: Int, remainder: Int) {
    return (a/b, a%b)
}

let res = div(a:5, b:2)
print(res, res.quotient, res.remainder, res.0, res.1)

let (quo, rem) = div(a:5, b:2)
print(quo, rem)




func nested_add() -> Int {
    var ret = 0
    func add() {
        ret += 1
    }

    add()
    return ret
}

print(nested_add())



// let's say callback has no parameters and return value
func wtf(callback: ()->()) {
    callback()
}

func wtf_callback() {
    print("This is callback")
}

print(wtf(callback: wtf_callback))




var nums = [2, 3, 3]
nums = nums.map({ (x: Int) -> Int in
    let res = 10*x
    return res
})

print(nums)


nums = nums.map({x in 2*x})
print(nums)

