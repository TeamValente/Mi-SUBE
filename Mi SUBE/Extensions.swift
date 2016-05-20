//
//  Extensions.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        //return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
        let range = startIndex.advancedBy(r.startIndex) ..< startIndex.advancedBy(r.endIndex)
        return substringWithRange(Range(range))
    }
}

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 1 { return "\(yearsFrom(date)) años"   }
        if yearsFrom(date)   == 1 { return "\(yearsFrom(date)) año"   }
        if monthsFrom(date)  > 1 { return "\(monthsFrom(date)) meses"  }
        if monthsFrom(date)  == 1 { return "\(monthsFrom(date)) mes"  }
        if weeksFrom(date)   > 1 { return "\(weeksFrom(date)) semanas"   }
        if weeksFrom(date)   == 1 { return "\(weeksFrom(date)) semana"   }
        if daysFrom(date)    > 1 { return "\(daysFrom(date)) días"    }
        if daysFrom(date)    == 1 { return "\(daysFrom(date)) día"    }
        if hoursFrom(date)   > 1 { return "\(hoursFrom(date)) horas"   }
        if hoursFrom(date)   == 1 { return "\(hoursFrom(date)) hora"   }
        if minutesFrom(date) > 1 { return "\(minutesFrom(date)) minutos" }
        if minutesFrom(date) == 1 { return "\(minutesFrom(date)) minuto" }
        if secondsFrom(date) > 1 { return "\(secondsFrom(date)) segundos" }
        return "1 segundo"
    }
    
    
    
}


