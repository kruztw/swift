class parent {
    init(name: String) { // constructor
        print("parent constructor")
        self.name = name
    }

    deinit { // destructor
    }

    func sayHi() {
	let me = whoami()
        print("\(me): Hi I am \(name)")
    }

    func whoami() -> String {
        return "parent"
    }

    var name: String
}

var p = parent(name: "parent")
p.sayHi()


class child: parent { // Inheritance

   init() {
       super.init(name: "child") // call parent init
   }

    override func whoami() -> String{
        return "child"
    }
}

var c = child()
c.sayHi()



class getter_setter {
    var x: Int = 2
    var times: Int = 3
    
    var xtimes: Int {
        get {
            return x * times
        }
        set {
            times = newValue/x   // newValue is a key word
        }
    }
}

var gs = getter_setter()
gs.xtimes = 12
print(gs.x, gs.times, gs.xtimes)


class will_did {
    var x: Int = 0 {
        willSet {
            print("set x = \(newValue)")
        }
        didSet {
            print("now x is not \(oldValue)")
        }
    }
}

var wd = will_did()
wd.x = 1

let optional_wd :will_did? = will_did()
optional_wd?.x = 10
let x = optional_wd?.x

// print x  if x != nil else 0
print(x ?? 0)



