//
//  AppDelegate.swift
//  NuntiiTheOne
//
//  Created by Julian Angres on 22/01/2022.
//

import Firebase
import FirebaseMessaging
import FirebaseDatabase
import FirebaseAuth
import UIKit
import StripeCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.Message_ID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        
        Messaging.messaging().delegate = self
        
        NetworkMonitor.shared.startMonitoring()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    


}



extension AppDelegate: UNUserNotificationCenterDelegate {
      // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // ...

        // Print full message.
        print(userInfo)
            print("willPresent")
        

        // Change this to your preferred presentation option
        return [[.banner, .sound]]
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
          print("didReceive")
      }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
          
          print("didReceiveRemoteNotification")
          //notification.request.content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "nuntii_jingle.wav"))
           
      //let content = UNMutableNotificationContent()
          
      /*content.title = "My Notification"
      content.body = "Hello, world!"*/
          
      //content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "nuntii_jingle.mp3"))
      //notification.request.content.sound = UNNotificationSoundName(rawValue: "nuntii_jingle.mp3")

      return UIBackgroundFetchResult.newData
    }

    
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        if Auth.auth().currentUser != nil {
            let ownEmail = Auth.auth().currentUser?.email
            let ownNewEmail = ownEmail?.replacingOccurrences(of: ".", with: "__DOT__")
            Database.database().reference().child("userData").child(ownNewEmail!).child("messagingToken").setValue(fcmToken)
        }
        
        
    }

    
}

