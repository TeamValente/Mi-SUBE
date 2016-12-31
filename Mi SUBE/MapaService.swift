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
import KYCircularProgress
import UIKit

class MapaService {
    
    
    func removeRoute(_ mapa: MKMapView)
    {
        if mapa.overlays.count == 1 {
            mapa.remove(mapa.overlays.first!)
        }
    }
    
    func calculateSegmentDirections(_ puntoFuente: MiUbicacion ,puntoDestino: PuntoCarga, mapa: MKMapView, layoutProgress: UIVisualEffectView) {
        let placemarkSource = MKPlacemark(coordinate: puntoFuente.coordinate, addressDictionary: nil)
        let placermarkerDestination = MKPlacemark(coordinate: puntoDestino.coordinate, addressDictionary: nil)
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source =  MKMapItem(placemark: placemarkSource)
        request.destination = MKMapItem(placemark: placermarkerDestination)
        // 3
        request.transportType = .walking
        // 4
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                if let routeResponse = response?.routes
                {
                    let quickestRouteForSegment: MKRoute =
                        routeResponse.sorted(by: {$0.expectedTravelTime <
                            $1.expectedTravelTime})[0]
                    self.dibujarRuta(quickestRouteForSegment,mapa: mapa)
                    layoutProgress.isHidden = true
                }
            }
        })
    }
    
    fileprivate func dibujarRuta(_ route: MKRoute, mapa: MKMapView) {
        
        // 1
        mapa.add(route.polyline)
        // 2
        if mapa.overlays.count == 1 {
            mapa.setVisibleMapRect(route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
            // 3
        else {
            mapa.remove(mapa.overlays.first!)
            let polylineBoundingRect =  MKMapRectUnion(mapa.visibleMapRect,
                route.polyline.boundingMapRect)
            mapa.setVisibleMapRect(polylineBoundingRect,
                edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
                animated: false)
        }
    }
    
    
    
    
}
