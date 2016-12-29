//
//  HelperMofiler.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 29/12/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import Mofiler

public class HelperMofiler {
    
    let debugModeMofiler: Bool
    
    init(debugFlag: Bool) {
        self.debugModeMofiler = debugFlag
        
    }
    
    func setValue(newValue:String, valueDictionary: [String: Any], chekKey:String) {
        let mof = Mofiler.sharedInstance
        mof.injectValue(newValue: [newValue: valueDictionary.description])
        mof.flushDataToMofiler()
        
    }
    
}
