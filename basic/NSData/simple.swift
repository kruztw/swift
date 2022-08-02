import Foundation

var cwd = FileManager.default.currentDirectoryPath
let url = URL(fileURLWithPath: cwd + "/simple.swift")
let data = NSData(contentsOf: url)
let hex_content = data?.debugDescription

print(hex_content ?? "")

