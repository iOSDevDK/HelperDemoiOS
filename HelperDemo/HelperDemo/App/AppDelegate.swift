//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD
//import UserNotifications
//import UserNotificationsUI
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hudProgress: MBProgressHUD!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isStatusBarHidden = false
        UINavigationBar.appearance().barTintColor = kColorRoyalBlue //appBgColor
        UINavigationBar.appearance().tintColor = kColorWhite
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:kColorWhite]
        UITabBar.appearance().tintColor = kColorOrange
        UITabBar.appearance().backgroundColor = kColorRoyalBlue
        IQKeyboardManager.sharedManager().enable = true
    
        
        //GMSPlacesClient.provideAPIKey(kGooglePlacesAPIKey)
        //GMSServices.provideAPIKey(kGooglePlacesAPIKey)
        
        /*
        if #available(iOS 10.0, *) {
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
         */
        
        //setAppFlow()
        
        return true
    }

    func setAppFlow() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            // User is logged In.
            
            if UserDefaults.standard.integer(forKey: "kUserType") == 1 {
                let objNavHome = mainStoryBoard.instantiateViewController(withIdentifier: kNavHomeVCIdentifier) as! UINavigationController
                window!.rootViewController = objNavHome
                
            } else {
                let objNavHome = mainStoryBoard.instantiateViewController(withIdentifier: kTabHomeIdentifier) as! UITabBarController
                window!.rootViewController = objNavHome
            }
            
        } else {
            // User is not logged In. Display LoginScreen.
            let objNavLogin = mainStoryBoard.instantiateViewController(withIdentifier: kNavLoginVCIdentifier) as! UINavigationController
            window!.rootViewController = objNavLogin
        }
        window!.makeKeyAndVisible()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    /*
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("\("app delegate application openURL called ") url=\(url.absoluteString)")
        if LISDKCallbackHandler.shouldHandleUrl(url) {
            return LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }*/
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        print(deviceTokenString)

        UserDefaults.standard.set(deviceTokenString, forKey: "keyDeviceToken")
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
         UserDefaults.standard.set("", forKey: "keyDeviceToken")
         UserDefaults.standard.synchronize()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print(userInfo)
        /*
         let alertValue = userInfo["aps"]!["badge"]! as! NSNumber
         print("my message-- ",alertValue);
         UIApplication.sharedApplication().applicationIconBadgeNumber = Int(alertValue)
         */
        if application.applicationState == UIApplicationState.active {
            /*
             let dictAlert = userInfo["aps"] as! [String:AnyObject]
             let title = dictAlert["alert"]?["title"]! as! String
             let message = dictAlert["alert"]?["body"]! as! String
             let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
             self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
             */
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        //UIApplication.shared.applicationIconBadgeNumber = Int(alertValue)

        if application.applicationState == UIApplicationState.active {
            /*
             let dictAlert = userInfo["aps"] as! [String:AnyObject]
             let title = dictAlert["alert"]?["title"]! as! String
             let message = dictAlert["alert"]?["body"]! as! String
             let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
             self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
             */
            
        } else {
            completionHandler(UIBackgroundFetchResult.newData)
        }
        
    }
    
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "HelperDemo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("HelperDemo.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

extension AppDelegate: MBProgressHUDDelegate {
    
    func removeDefaultsData() {
        let arrRemKeys = ["fName","Description"]
        for key in arrRemKeys {
            if UserDefaults.standard.object(forKey: key) != nil {
                removeDefaults(key)
            }
        }
    }

    
    func showProgress() {
        if hudProgress == nil {
            hudProgress = MBProgressHUD.showAdded(to: self.window!, animated: true)
            hudProgress.delegate = self
            
            appDel.window!.isUserInteractionEnabled = false
        }
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            if self.hudProgress != nil {
                self.hudProgress.isHidden = true
                self.hudProgress.hide(animated: true)
                self.hudProgress.removeFromSuperview()
                self.hudProgress = nil
                appDel.window!.isUserInteractionEnabled = true
            }}
    }
    
    // MARK: - MBProgressHUDDelegate
    
    func hudWasHidden(_ hud: MBProgressHUD) {
        // Remove HUD from screen when the HUD was hidded
        hud.removeFromSuperview()
    }
    
}
