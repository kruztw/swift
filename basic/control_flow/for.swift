let elements = [1, 2, 3, 4]
for e in elements {
    print(e, terminator: " ")
}
print()

let total = 5
// [1, total] 
for i in 1...total {
    print(i, terminator: " ")
}
print()

// [1, total)
for i in 1..<total {
    print(i, terminator: " ")
}
print()
