//
//  AppDelegate.swift
//  WorkoutTracker
//
//  Created by Stefan Auvergne on 1/31/16.
//  Copyright © 2016 Stefan Auvergne. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications  

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ref:FIRDatabaseReference!
    var user:FIRUser!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Have a Great Day Demo", size: 18)!], for: .normal) // your textattributes here
        
        FIRApp.configure()
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        return true
    }
    
    func resetBadgeNumber(){
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func setBadgeNumber(_ delta: Int){
        UIApplication.shared.applicationIconBadgeNumber += delta
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        //save to NSUserDefaut
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        setBadgeNumber(-1)
        
        var exerciseDictionary = data["exercise"]! as! [String:Any]
        
        //handle challenge notification
        //save to firebase or nsuserdefault
        DBService.shared.saveChallengeExercise(exerciseDictionary: exerciseDictionary)
        
           let myEx = Exercise()
        myEx.name = exerciseDictionary["name"] as! String
        myEx.exerciseDescription = exerciseDictionary["description"] as! String
        myEx.result = exerciseDictionary["result"] as! String
        myEx.date = exerciseDictionary["date"] as! String
        myEx.exerciseKey = exerciseDictionary["exerciseKey"] as! String
        myEx.client = exerciseDictionary["client"] as! String
        myEx.opponent = exerciseDictionary["opponent"] as! String
        myEx.creatorEmail = exerciseDictionary["creatorEmail"] as! String
        myEx.creatorID = exerciseDictionary["creatorID"] as! String
        myEx.type = exerciseDictionary["type"] as! String
        myEx.category = exerciseDictionary["category"] as! String
        
        DBService.shared.setPassedExercise(exercise:myEx)

        //grab reference to vc on screen. Do not instantiate
        let vc = window?.rootViewController?.presentedViewController?.childViewControllers[0] as! WorkoutInputViewController
        
        vc.fillInExercisePassed()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appEnteredForegroundKey"), object:nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        do{
            try FIRAuth.auth()?.signOut()
        }catch{
            print(error)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(options)
        print(url)
        return false
    }


}

