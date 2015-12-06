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
    
    
}