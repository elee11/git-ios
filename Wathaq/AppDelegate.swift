//
//  AppDelegate.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/11/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
import GoogleMaps
import FirebaseMessaging
import IQKeyboardManagerSwift




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupLanguage()
        setUpKeyboardManager()

        removeTabBarShadowLine()
        GMSServices.provideAPIKey(Constants.keys.GoogleMapsKey)

        //Firebase
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil
        {
            let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
            
            print(remoteNotif)
            if remoteNotif![AnyHashable("type")]! as! String == "AcceptedRequest"
            {
                // Print full message.
                print(remoteNotif)
                print(remoteNotif![AnyHashable("orderId")]!)
                print(remoteNotif![AnyHashable("lawyerId")]!)
                
                var OrderObj = Orderdata()
                var mawtheqData = MowatheqData()
                
                OrderObj.id = Int(remoteNotif![AnyHashable("orderId")]! as! String)
                mawtheqData.id = Int(remoteNotif![AnyHashable("lawyerId")]! as! String)
                
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let ChatView  = mainStoryboard.instantiateViewController(withIdentifier: "Chat") as! ChatVC
                
                ChatView.OrderObj = OrderObj
                ChatView.MoawtheqObj = mawtheqData
                
                if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    let currentNavigationController = tabBarController.selectedViewController as! UINavigationController
                    currentNavigationController.popToRootViewController(animated: false)
                    currentNavigationController.pushViewController(ChatView)
                }
                
            }
            else
            {
                if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    let currentNavigationController = tabBarController.selectedViewController as! UINavigationController
                    currentNavigationController.popToRootViewController(animated: false)
                }
            }
            
            
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        self.startNetworkListener()
        self.customizeTabBar()
        self.checkifuserLoggedIn()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //When the notifications of this code worked well, there was not yet.
        let firebaseAuth = Auth.auth()
        
        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        Messaging.messaging().apnsToken = deviceToken
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        let FRtoken = Messaging.messaging().fcmToken
        
        
        if FRtoken?.length != 0 && FRtoken != nil
        {
            UserDefaults.standard.set(FRtoken, forKey: "TokenDevice")
        }
        print(FRtoken)
        
    }
    
    func setUpKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        //disable IQKeyboard for those classes
//        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses = [EvaluateCourseViewController.self, AccreditationFormsViewController.self]
    }
    
    func checkifuserLoggedIn()
    {
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        if userObj == nil
     {
        
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = MainStoryBoard.instantiateViewController(withIdentifier: "PhoneEntryController")
        self.window?.rootViewController? = loginViewController
     }
        else if userObj != nil
        {
            if userObj?.isCompleteProfile == false
            {
                let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let CompleteProfileViewController = MainStoryBoard.instantiateViewController(withIdentifier: "CompleteProfileViewController")
                self.window?.rootViewController? = CompleteProfileViewController
            }
        }
    }
    
    func customizeTabBar ()
    {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.deepBlue // Back buttons and such
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.deepBlue,NSAttributedStringKey.font: UIFont(name: Constants.FONTS.FONT_AR, size: 18) as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: Constants.FONTS.FONT_AR, size: 16)!], for: .normal) // your textattributes here
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: Constants.FONTS.FONT_AR, size: 16)!], for: .highlighted) // your textattributes here

        let colorNormal : UIColor = UIColor.lightimpactGray
        let colorSelected : UIColor = UIColor.deepBlue
        let titleFontAll : UIFont = UIFont(name: Constants.FONTS.FONT_AR, size: 11.0)!
        
        let attributesNormal = [
            NSAttributedStringKey.foregroundColor : colorNormal,
            NSAttributedStringKey.font : titleFontAll
        ]
        
        let attributesSelected = [
            NSAttributedStringKey.foregroundColor : colorSelected,
            NSAttributedStringKey.font : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
    }
    
    
    func startNetworkListener() {
        NWConnectivity.sharedInstance.startNetworkReachabilityObserver()
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        debugPrint(remoteMessage.appData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }
    
    func removeTabBarShadowLine() {
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().barTintColor = UIColor.white // your color
    }
    
    func setupLanguage() {
        let df = UserDefaults.standard
        if  df.value(forKey: "LANG") == nil {
            Language.setAppLanguage(lang: Language.getDeviceLanguage())
        }
        Localizer.DoTheExchange()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
        
       if userInfo[AnyHashable("type")]! as! String == "AcceptedRequest"
        {
            // Print full message.
            print(userInfo)
            print(userInfo[AnyHashable("orderId")]!)
            print(userInfo[AnyHashable("lawyerId")]!)
            
            var OrderObj = Orderdata()
            var mawtheqData = MowatheqData()
            
            OrderObj.id = Int(userInfo[AnyHashable("orderId")]! as! String)
            mawtheqData.id = Int(userInfo[AnyHashable("lawyerId")]! as! String)
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ChatView  = mainStoryboard.instantiateViewController(withIdentifier: "Chat") as! ChatVC
            
            ChatView.OrderObj = OrderObj
            ChatView.MoawtheqObj = mawtheqData
            
            if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                let currentNavigationController = tabBarController.selectedViewController as! UINavigationController
                currentNavigationController.popToRootViewController(animated: false)
                currentNavigationController.pushViewController(ChatView)
            }
            
        }
        else
       {
       if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                let currentNavigationController = tabBarController.selectedViewController as! UINavigationController
                currentNavigationController.popToRootViewController(animated: false)
            }
        }
        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

