//
//  MarketFactory.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 6/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import MapKit

class MarketFactory{


    private func makeMarkerOpen()->CustomPointAnnotation
    {
        
        let point = CustomPointAnnotation()
        point.imageName = "flag.png"
        return point
        
    }
    
    private func makeMarkerClose()->CustomPointAnnotation
    {
        
        let point = CustomPointAnnotation()
        point.imageName = "flag.png"
        return point
        
    }
    
    
    func makeCustomMarker(miPunto: PuntoCarga)->CustomPointAnnotation
    {
        var puntoRetorno: CustomPointAnnotation
        
        if miPunto.estaAbierto()
        {
            puntoRetorno =  makeMarkerOpen()
        }else
        {
            puntoRetorno =  makeMarkerClose()
        }
        puntoRetorno.title = miPunto.address
        puntoRetorno.subtitle = miPunto.detalleParaMapa()
        //point.index = miPunto.idPunto
        puntoRetorno.coordinate = CLLocationCoordinate2D(latitude: miPunto.latitude, longitude: miPunto.longitude)
    
        return puntoRetorno
    }



}