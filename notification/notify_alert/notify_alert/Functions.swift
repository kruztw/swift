import Cocoa
import Foundation
import UserNotifications


// Base64 content
func base64String(stringContent: String) -> String {
    return stringContent.data(using: String.Encoding.utf8)!.base64EncodedString()
}

// Logout user, prompting to save
func handler() {
    shell("open http://www.example.com")
}

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

// Request authorisation
func requestAuthorisation () -> Void {
    if #available(macOS 10.15, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        if !granted {
            NSLog("ERROR: Authorisation not granted, exiting...")
            exit(1)
        }
      }
    }
}

// Process userinfo for UNNotification
@available(macOS 10.14, *)
func handleUNNotification(forResponse response: UNNotificationResponse) {
    let userInfo = response.notification.request.content.userInfo
    var messageDismissed = true
   
    if response.actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier" {
        if userInfo["messageAction"] != nil {
            if (userInfo["messageAction"] as? String) == "logout" {
                handler()
            }
            
            messageDismissed = false
        }
    } else if response.actionIdentifier == "com.apple.UNNotificationDismissActionIdentifier" {
        // need to capture this, but we don't want to do anything
    } else {
        if userInfo["messageButtonAction"] != nil {
            if (userInfo["messageButtonAction"] as? String) == "logout" {
                handler()
                messageDismissed = false
            }
        }
    }
    if messageDismissed {
        NSLog("Notifier Log: alert - message - dismissed by user")
    }

    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
    sleep(1)
    exit(0)
}

// Process userinfo for NSUserNotification
func handleNSUserNotification(forNotification notification: NSUserNotification) {
    let center =  NSUserNotificationCenter.default
    let userInfo = notification.userInfo
    var messageDismissed: Bool = true

    switch (notification.activationType) {
    case .none:
        exit(0)
        
    case .contentsClicked:
        if userInfo?["messageAction"] != nil {
            if (userInfo?["messageAction"] as? String) == "logout" {
                handler()
            }
            messageDismissed = false
        }
        
    case .actionButtonClicked:
        if userInfo?["messageButtonAction"] != nil {
            if (userInfo?["messageButtonAction"] as? String) == "logout" {
                handler()
            }
            messageDismissed = false
        }
    case .replied:
        exit(0)
    case .additionalActionClicked:
        exit(0)
    @unknown default:
        exit(0)
    }
    
    if messageDismissed {
        print("Notifier Log: alert - message - dismissed by user")
    } else {
        print("Notifier Log: alert - OK")
    }
    
    center.removeAllDeliveredNotifications()
    sleep(3)
    
    exit(0)
}
