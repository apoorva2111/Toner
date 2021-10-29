//
//  AppDelegate.swift
//  Toner
//
//  Created by Users on 06/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AudioPlayerManager
import AVFoundation
import CoreData
import UserNotifications
//import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var genreData = [TopGenreModel]()
    var cartListModel = [CartListModel]()
    var getStepperUpdate:ChangeValue!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
//        StripeAPI.defaultPublishableKey = "pk_test_51IyKkkGZwms8klUwrCKGzBP0DfyIrmV4YOs1BVSLkqGxsf8Wp22t2knBfCyJkXesUXSglIAL2MixI9bgev71KqSQ00WYyqUxXh"
       
//StripeAPI.defaultPublishableKey = "pk_live_51IyKkkGZwms8klUwXg3n6zSp6EI9A3xfhNx25d5yEK5UgN0QEb2Mb0HBzv8YZxzVJvT32yRhz0HIe13iC3KKJEZd00qNMUhNjC"
        
        print("Document Dir: \(DocumentDirectory)")
        if #available(iOS 10, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            // set the type as sound or badge
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                }else{
                    print("Some Error Occure")
                }
            }
            application.registerForRemoteNotifications()
        }
        
        UserDefaults.standard.fetchCartData()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        
    
        if (UserDefaults.standard.fetchData(forKey: .userId) != ""){
            if  UserDefaults.standard.value(forKey: "userSubscribed") as! Int == 0{
                
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navSub") as! UINavigationController
                self.appD.window?.rootViewController = destination
                
            }else{
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                self.window?.rootViewController = destination
            }
        }else{
            
            let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.window?.rootViewController = destination
        }
        
        
        self.window?.makeKeyAndVisible()
   
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
        } catch {
            debugPrint("Error: \(error)")
        }


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UserDefaults.standard.syncCart()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UserDefaults.standard.fetchCartData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       UserDefaults.standard.syncCart()
    }

    func topViewController() -> UIViewController? {
        if UIApplication.shared.keyWindow != nil
        {
            return self.topViewControllerWithRootViewController(UIApplication.shared.keyWindow!.rootViewController!)
        }
        return nil
    }
    
    func topViewControllerWithRootViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        if rootViewController == nil {
            return nil
        }
        if rootViewController!.isKind(of: UITabBarController.self) {
            let tabBarController: UITabBarController = (rootViewController as? UITabBarController)!
            return self.topViewControllerWithRootViewController(tabBarController.selectedViewController)
        }
        else {
            if rootViewController!.isKind(of: UINavigationController.self) {
                let navigationController: UINavigationController = (rootViewController as? UINavigationController)!
                return self.topViewControllerWithRootViewController(navigationController.visibleViewController)
            }
            else {
                if (rootViewController!.presentedViewController != nil) {
                    let presentedViewController: UIViewController = rootViewController!.presentedViewController!
                    return self.topViewControllerWithRootViewController(presentedViewController)
                }
                else {
                    return rootViewController
                }
            }
        }
    }

    override func remoteControlReceived(with event: UIEvent?) {
//        TonneruAudioManager.shared.remoteControlReceivedWithEvent(event)
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TonneruDownload")
        for description in container.persistentStoreDescriptions {
            print("db location: \(description.url!)")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
