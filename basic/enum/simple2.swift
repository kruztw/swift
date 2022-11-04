enum Items {
   case A(price: Int)
   case B(color: String)
   case C

   init(msg: String?) {
	print(msg ?? "")
	self = .A(price: 100)
   }
}

func foo(item name: Items) {
	switch name {
	case .A(price: let p) where p > 10:
		print("\(p) is too expensive")
	case .B(color: let c):
		print("B's color is \(c)")
        case .C:
		print("C")
	default:
		print("default")
	}
}

foo(item: .A(price: 100))
foo(item: .A(price: 1))
foo(item: .B(color: "blue"))
foo(item: .C)
foo(item: Items(msg: "\nhello world"))
