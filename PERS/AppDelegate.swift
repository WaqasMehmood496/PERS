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
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyANXhKsyGxYbtDWK9B0J9nxFz4iGL2ffAw")
        return true
    }
}

