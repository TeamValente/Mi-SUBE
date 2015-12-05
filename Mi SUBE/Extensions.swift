//
//  Extensions.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

//Con esta extension para String se hace el decode de los caracteres HTML
extension String {
    func htmlDecoded()->String {
        
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
            "&aacute;"  : "á",
            "&eacute;"  : "é",
            "&iacute;"  : "í",
            "&oacute;"  : "ó",
            "&uacute;"  : "ú",
            "&ntilde;"  : "ñ"
        ]
        
        for (name,value) in entities {
            newStr = newStr.stringByReplacingOccurrencesOfString(name, withString: value)
        }
        return newStr
    }
}