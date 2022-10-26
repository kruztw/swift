import Foundation
import Cocoa

var image:NSImage!

let userPicture = "/Library/User Pictures/Flowers/Poppy.tif"
let picURL = URL(fileURLWithPath: userPicture)
let picData = NSData(contentsOf: picURL)
image = NSImage(data: Data(referencing: picData!))
print(image ?? "")
