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
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        //return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
        let range = characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)
        return substring(with: Range(range))
    }
}

extension Date
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: self)
        let hour = components.hour
        
        //Return Hour
        return hour!
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.minute, from: self)
        let minute = components.minute
        
        //Return Minute
        return minute!
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    func offsetFrom(_ date:Date) -> String {
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


