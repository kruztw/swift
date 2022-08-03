import Foundation

let file = "a" 
let text = "some text"

// macro paths can find in "https://developer.apple.com/documentation/foundation/filemanager/searchpathdirectory/documentdirectory"
if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

    let fileURL = dir.appendingPathComponent(file)
    print("fileURL = ", fileURL)

    //reading
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        print(content)
    }
    catch {/* error handling here */}
}
