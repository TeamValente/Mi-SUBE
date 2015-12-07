//
//  PuntoCarga.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class PuntoCarga{

    var idPunto:Int
    var address:String
    var latitude: Double
    var longitude: Double
    var type: String
    var icon:String
    var cost:Int?
    var hourOpen:Int
    var hourClose:Int
    var flagSeller:Int?
    var flagInvalid:Int?

    
    init(idPunto:Int,address:String,latitude: Double,longitude: Double,type: String,icon:String,cost:Int,hourOpen:Int,hourClose:Int,flagSeller:Int,flagInvalid:Int){
        
        self.idPunto = idPunto
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.icon = icon
        self.cost = cost
        self.hourOpen = hourOpen
        self.hourClose = hourClose
        self.flagSeller = flagSeller
        self.flagInvalid = flagInvalid
    
    }
    
    init(idPunto:Int,address:String,latitude: Double,longitude: Double,type: String,icon:String,hourOpen:Int,hourClose:Int){
        
        self.idPunto = idPunto
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.icon = icon 
        self.hourOpen = hourOpen
        self.hourClose = hourClose

        
    }
    
    func estaAbierto() -> Bool {
        //Get Current Date
        let currentDate = NSDate()
        
        if self.hourClose + self.hourOpen == 0{
            //Sin horario determinado devuelvo false
            return false
        }
        
        if currentDate.hour() >= self.hourOpen && currentDate.hour() < self.hourClose
        {
            return true
        }else if self.hourOpen <= self.hourClose
        {
            return true
        }else{
            return false
        }
    
    }
    
    func detalleParaMapa() -> String {
    
        if self.hourClose + self.hourOpen != 0{
            let apertura = "\(self.hourOpen):00"
            let cierre = "\(self.hourClose):00"
            
            return "\(self.type), atiende de: \(apertura) a \(cierre) Hs."
        }else //En caso de que no tenga horario cargado muestro solo el tipo
        {
            return "\(self.type)"
        }
    }
    
    func vendeSube() -> Bool {
        if self.flagSeller == 0 {
            return false
        }
        return true
    }
    
    

}