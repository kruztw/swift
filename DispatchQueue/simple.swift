import Foundation

let globalQueue = DispatchQueue.global()

func task(id number: Int) {
    print("task \(number) , current task \(Thread.current)")
    sleep(UInt32.random(in: 1...3))
    print("task \(number) completed")
}

print("------Start execute Serially------")
for i in 1...5 {
    globalQueue.sync {
        task(id: i)
    }
}

print("------Start execute Concurrently------")
for i in 1...5 {
    globalQueue.async {
        task(id: i)
    }
}
