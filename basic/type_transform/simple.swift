import Foundation

var cwd = FileManager.default.currentDirectoryPath
let url = URL(fileURLWithPath: cwd + "/simple.swift")
let nsdata = NSData(contentsOf: url)

// NSData <-> Data
let data = Data(referencing: nsdata!)
let nsdata2 = NSData(data: data)

// Data <-> NSString
let nsstring:NSString = NSString(data: data, encoding:String.Encoding.utf8.rawValue) ?? ""
let data2:Data = nsstring.data(using:String.Encoding.utf8.rawValue)!

// Data <-> String
let string:String = String(decoding: data,as: UTF8.self)
let data3:Data = string.data(using:String.Encoding.utf8.self)!

// NSString <-> String
let nsstring2:NSString = NSString(string: string)
let string2:String = String(nsstring)
