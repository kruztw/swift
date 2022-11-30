import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        NSLog("call applicationDidFinishLaunching")
        
        let actionIdentifier = "alert"
        var notificationString = ""

        guard !NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.notificationcenterui").isEmpty else {
            NSLog("ERROR: Notification Center is not running...")
            exit(1)
        }

        requestAuthorisation()
        NSLog("Authenticated")
        
        let ncCenter =  UNUserNotificationCenter.current()
        let ncContent = UNMutableNotificationContent()

        ncCenter.delegate = self
        ncCenter.removeAllDeliveredNotifications()
        ncCenter.removeAllPendingNotificationRequests()
        
        sleep(1)
    
        ncContent.body = "body"
        notificationString += ncContent.body
            
        ncContent.userInfo["messageAction"] = "logout"
        notificationString += "logout"
        notificationString += actionIdentifier
                        
        let actionTitle = "logout"
        let ncAction = UNNotificationAction(identifier: "messagebutton", title: actionTitle, options: .init(rawValue: 0))
        let ncCategory = UNNotificationCategory(identifier: actionIdentifier, actions: [ncAction], intentIdentifiers: [], options: .customDismissAction)
                
        ncCenter.setNotificationCategories([ncCategory])
        ncContent.categoryIdentifier = actionIdentifier
                    
        ncContent.userInfo["messageButtonAction"] = "logout"
        notificationString += "logout"
                            
        ncContent.subtitle = "subtitle"
        notificationString += ncContent.subtitle
    
        ncContent.title = "title"
        notificationString += ncContent.title
                        
        let ncContentbase64 = base64String(stringContent: notificationString)
                    
        let ncTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let ncRequest = UNNotificationRequest(identifier: ncContentbase64, content: ncContent, trigger: ncTrigger)
        
        NSLog("add request")
        //ncCenter.add(ncRequest)
        ncCenter.add(ncRequest, withCompletionHandler: errorHandler)
        ncCenter.getDeliveredNotifications(completionHandler: listHandler)
        ncCenter.getPendingNotificationRequests(completionHandler: pendingHandler(notifications:))
    }
    
    func errorHandler(err: Error?) {
        print("error = ", err ?? "")
    }
    
    func listHandler(notifications: [UNNotification]) {
        print("delivered notifications = ", notifications)
    }
    
    func pendingHandler(notifications: [UNNotificationRequest]) {
        print("pending notifications = ", notifications)
    }

    // Insert code here to tear down your application
    func applicationWillTerminate(_ aNotification: Notification) {
    }

    // NSUser - Respond to click
    @available(macOS, obsoleted: 10.15)
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        handleNSUserNotification(forNotification: notification)
    }

    // NSUser  - Ensure that notification is shown, even if app is active
    @available(macOS, obsoleted: 10.15)
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    // NSUser - Get value of the otherButton, used to mimic single button UNUser alerts
    @available(macOS, obsoleted: 10.15)
    @objc
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDismissAlert notification: NSUserNotification){
        center.removeDeliveredNotification(notification)
        exit(0)
    }

    // UNUser - Respond to click
    @available(macOS 10.14, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification") , object: nil, userInfo: response.notification.request.content.userInfo)
        handleUNNotification(forResponse: response)
    }

    // UNUser - Ensure that notification is shown, even if app is active
    @available(macOS 10.14, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

@available(macOS 10.15, *)
    extension AppDelegate: UNUserNotificationCenterDelegate {
}
