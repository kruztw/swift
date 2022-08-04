func return_nil() -> String? {
    return nil
}

func _guard() { // more reedable
    guard let res = return_nil() else {
        print("invalid")
        return
    }

    print("res: \(String(describing: res))")
}

func _if() {
    let res = return_nil()
    if res == nil {
        print("invalid")
        return
    }

    print("res: \(String(describing: res))")
}

_guard()
_if()
