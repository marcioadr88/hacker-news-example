//
//  AppDelegate.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // print("Using realm file \(Realm.Configuration().fileURL!)")
        
        return true
    }
}

