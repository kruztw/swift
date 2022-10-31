import Foundation

@_silgen_name("add")
func myAdd(a:Int32,b:Int32) -> Int32

let ret = myAdd(a:10,b:20)
print("ret = \(ret)")
