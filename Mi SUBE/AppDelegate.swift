//
//  AppDelegate.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 4/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Mofiler
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MofilerDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        /**
         Mofiler SDK integration
         */
        let mof = Mofiler.sharedInstance
        
        // DeviceINFO
        let curDevice = UIDevice.current
        
        // TEST
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            let strIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            
            mof.initializeWith(appKey: "1076019287", appName: "MiSube", identity: ["advertisingIdentifier" : strIDFA])
        } else {
            mof.initializeWith(appKey: "1076019287", appName: "MiSube", identity: ["name" : curDevice.name])
        }
        
        mof.delegate = self
        mof.url = "mofiler.com"
        mof.useLocation = false
        mof.useVerboseContext = true
        
        let deviceInformation: [String:Any] = [
            "deviceName": curDevice.name,
            "systemName": curDevice.systemName,
            "systemVersion": curDevice.systemVersion,
            "deviceModel": curDevice.model,
            "deviceLocalizedModel": curDevice.localizedModel,
            "deviceInterfaceIdiom": curDevice.userInterfaceIdiom,
            "deviceOrientation": curDevice.orientation,
            "deviceBatteryLevel": curDevice.batteryLevel,
            "deviceIsBatteryMonitoringEnabled": curDevice.isBatteryMonitoringEnabled,
            "deviceBatteryState": curDevice.batteryState,
            "deviceIsProximityMonitoringEnabled": curDevice.isProximityMonitoringEnabled,
            "deviceProximityState": curDevice.proximityState
        ]
        // print("DEVICE INFO: \(deviceInformation)")
        mof.injectValue(newValue: ["deviceInformation" : deviceInformation.description])
        mof.flushDataToMofiler()
        
        
        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // # MARK: - MofilerDelegate
    public func responseValue(key: String, identityKey: String, identityValue: String, value: [String : Any]) {
        print("MofilerDelegate: \(value)")
    }
    
    func errorOcurred(error: String, userInfo: [String : String]) {
        print("MofilerDelegate: \(error)")
    }
}

