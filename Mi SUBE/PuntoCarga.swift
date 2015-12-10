//
//  PuntoCarga.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import CoreLocation

//En el caso de los tipos de Comercio son los siguientes
//[{"id":"1","name":"Comercio"},{"id":"2","name":"Centro de carga"},{"id":"3","name":"Terminal Autom\u00e1tica"},{"id":"4","name":"Estaci\u00f3n de Tren"},{"id":"5","name":"Estaci\u00f3n de Subte"}]

enum EstadoNegocio
{
    case Abierto
    case Cerrado
    case Indeterminado
}


class PuntoCarga{

    var idPunto:Int
    var address:String
    var latitude: Double
    var longitude: Double
    var type: String
    var icon:String
    var cost:String
    var hourOpen:Int
    var hourClose:Int
    var flagSeller:Int
    var flagInvalid:Int?
    var idType:Int?
    var coordinate: CLLocationCoordinate2D

    
    init(idPunto:Int,address:String,latitude: Double,longitude: Double,type: String,icon:String,cost:String,hourOpen:Int,hourClose:Int,flagSeller:Int,flagInvalid:Int){
        
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
        coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
    
    init(idPunto:Int,address:String,latitude: Double,longitude: Double,type: String,icon:String, cost: String,hourOpen:Int,hourClose:Int, flagSeller: Int){
        
        self.idPunto = idPunto
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.icon = icon 
        self.hourOpen = hourOpen
        self.hourClose = hourClose
        self.cost = cost
        self.flagSeller = flagSeller
        coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude

        
    }
    
    init(idPunto:Int,address:String,latitude: Double,longitude: Double,type: String,icon:String, cost: String,hourOpen:Int,hourClose:Int, flagSeller: Int, idType: Int ){
        
        self.idPunto = idPunto
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.icon = icon
        self.hourOpen = hourOpen
        self.hourClose = hourClose
        self.cost = cost
        self.idType = idType
        self.flagSeller = flagSeller
        coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
        
        
    }
    
    func estaAbierto() -> EstadoNegocio {
        //Get Current Date
        let currentDate = NSDate()
        
        if self.hourClose + self.hourOpen == 0{
            //Sin horario determinado devuelvo false
            return EstadoNegocio.Indeterminado
        }
        if currentDate.hour() >= self.hourOpen && currentDate.hour() < self.hourClose
        {
            return EstadoNegocio.Abierto
        }else if self.hourOpen >= self.hourClose
        {
            return EstadoNegocio.Abierto
        }else
        {
            return EstadoNegocio.Cerrado
        }
    
    }
    
    func detalleParaMapa() -> String {
            return "\(self.type)"
    }
    
    func getHorarioDeAtencion() ->String
    {
        if self.hourClose + self.hourOpen != 0{
            let apertura = "\(self.hourOpen):00"
            let cierre = "\(self.hourClose):00"
            return "\(apertura) - \(cierre) Hs"
        }else //En caso de que no tenga horario cargado muestro solo el tipo
        {
            return "Sin horario cargado"
        }
    }
    
    func vendeSube() -> Bool {
        if self.flagSeller == 0 {
            return false
        }
        return true
    }
    
    func cobraPorCargar() ->Bool{
        if self.cost == "0"{
            return false
        }
        return true
    
    }
    
    

}