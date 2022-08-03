import Foundation

var cwd = FileManager.default.currentDirectoryPath
let url = URL(fileURLWithPath: cwd + "/simple2.swift")
let nsdata = NSData(contentsOf: url)
let data = Data(referencing: nsdata!)
let str = String(decoding: data,as: UTF8.self)

print(str)
