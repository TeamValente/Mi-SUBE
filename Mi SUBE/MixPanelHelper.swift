//
//  MixPanelHelper.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 6/2/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import Mixpanel

class MixPanelHelper {
    
    let mixpanel = Mixpanel.sharedInstanceWithToken("b1863723d9deb1ab20aab4ee221f549f")
    
    func track(event: String) {
        mixpanel.track(event)
    }
    
    func track(event: String, properties: [NSObject : AnyObject]) {
        mixpanel.track(event, properties: properties)
    }
    
}