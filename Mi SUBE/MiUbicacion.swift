//
//  MiUbicacion.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import CoreLocation

class MiUbicacion{

    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D


    init(lat: Double,lon: Double)
    {
        self.latitude = lat
        self.longitude = lon
        coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = lat
        self.coordinate.longitude = lon
    }
    
    //Devuelve la distancia en metros
    func getDistanciaAPuntoCarga(_ punto: PuntoCarga) -> Distancia
    {
    
        let metro = CLLocation(latitude: self.coordinate.latitude , longitude: self.coordinate.longitude)
        let valorMetros = metro.distance(from: CLLocation(latitude: punto.latitude,longitude: punto.longitude))
        var retDistancia: Distancia
        var unidadRet = "metros"
        if valorMetros >= 1000{
            let valorEnKm = valorMetros/1000
            
            if valorEnKm == 1
            {
                unidadRet = "kilometro"
            }else{
                unidadRet = "kilometros"
            }
            
            retDistancia = Distancia(valorNum: valorEnKm,valorStr: String(format: "%.2f", valorEnKm), unidad: unidadRet)
        }else{
            if valorMetros == 1
            {
                unidadRet = "metro"
            }
            retDistancia = Distancia(valorNum: valorMetros,valorStr: String(format: "%.0f", valorMetros), unidad: unidadRet)
        }
        
        return retDistancia
        
    
    
    }
    
    
}
