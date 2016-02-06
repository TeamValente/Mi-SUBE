//
//  MixPanelHelper.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 6/2/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import Mixpanel

struct MixPanelHelper {
    
    static let mixpanelToken = "b1863723d9deb1ab20aab4ee221f549f"
    
    static let mixpanel = Mixpanel.sharedInstanceWithToken(mixpanelToken)
    
    static func applicationWasClosed() {
        mixpanel.track("app", properties:  ["callback":"closed"])
    }
    
    static func applicationWasOpened() {
        mixpanel.track("app", properties:  ["callback":"opened"])
    }
    
    static func applicationEnteredBackground() {
        mixpanel.track("app", properties:  ["callback":"background"])
    }
    
    static func applicationBecameActive() {
        mixpanel.track("app", properties:  ["callback":"active"])
    }
    
    static func applicationEnteredForeground(){
        mixpanel.track("app", properties:  ["callback":"foreground"])
    }
    
}