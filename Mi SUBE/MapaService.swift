//
//  MapaService.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 9/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapaService {
    
    
    
    
    
    func calculateSegmentDirections(puntoFuente: MiUbicacion ,puntoDestino: PuntoCarga, mapa: MKMapView) {
        let placemarkSource = MKPlacemark(coordinate: puntoFuente.coordinate, addressDictionary: nil)
        let placermarkerDestination = MKPlacemark(coordinate: puntoDestino.coordinate, addressDictionary: nil)
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source =  MKMapItem(placemark: placemarkSource)
        request.destination = MKMapItem(placemark: placermarkerDestination)
        // 3
        request.transportType = .Walking
        // 4
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment: MKRoute =
                routeResponse.sort({$0.expectedTravelTime <
                    $1.expectedTravelTime})[0]
                self.dibujarRuta(quickestRouteForSegment,mapa: mapa)
                
            } else if let _ = error {
                
            }
        })
    }
    
    private func dibujarRuta(route: MKRoute, mapa: MKMapView) {
        
        // 1
        mapa.addOverlay(route.polyline)
        // 2
        if mapa.overlays.count == 1 {
            mapa.setVisibleMapRect(route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
            // 3
        else {
            mapa.removeOverlay(mapa.overlays.first!)
            let polylineBoundingRect =  MKMapRectUnion(mapa.visibleMapRect,
                route.polyline.boundingMapRect)
            mapa.setVisibleMapRect(polylineBoundingRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
    }
    
    
    
    
}