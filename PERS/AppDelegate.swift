//
//  AppDelegate.swift
//  PERS
//
//  Created by Buzzware Tech on 09/06/2021.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey("AIzaSyCjS8sP6t2b0fKNmFJgvgtiOF4_v0fwnRc")
        //AIzaSyANXhKsyGxYbtDWK9B0J9nxFz4iGL2ffAw
        //NewKey: AIzaSyCjS8sP6t2b0fKNmFJgvgtiOF4_v0fwnRc
        //FirebaseApp.configure()
        checkUserAlreadyLogin()
        return true
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
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }
    
    func checkUserAlreadyLogin() {
        var storyboard :UIStoryboard!
        if UIDevice.current.userInterfaceIdiom == .phone{
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        else{
            storyboard = UIStoryboard(name: "Ipad", bundle: nil)
        }
        if (CommonHelper.getCachedUserData()?.email != nil){
            
            let controller = storyboard.instantiateViewController(identifier: "Tabbar")
            self.window?.rootViewController = controller
        }else{
            let controller = storyboard.instantiateViewController(identifier: "LoginVC")
            self.window?.rootViewController = controller
        }
        self.window?.makeKeyAndVisible()
    }
}

