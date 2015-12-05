//
//  ViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 4/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    
    //MARK: Variables de la clase
    var manager: CLLocationManager!
    
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Activo el Manager
        manager = CLLocationManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
        }
        /* Pinpoint our location with the following accuracy:
        *
        *     kCLLocationAccuracyBestForNavigation  highest + sensor data
        *     kCLLocationAccuracyBest               highest
        *     kCLLocationAccuracyNearestTenMeters   10 meters
        *     kCLLocationAccuracyHundredMeters      100 meters
        *     kCLLocationAccuracyKilometer          1000 meters
        *     kCLLocationAccuracyThreeKilometers    3000 meters
        */
        
        if CLLocationManager.locationServicesEnabled() {
            
            //Distancia accuracy
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            /* Notify changes when device has moved x meters.
            * Default value is kCLDistanceFilterNone: all movements are reported.
            * Se setea en metros la distancia con la que se va a activar el movimiento
            */
            manager.distanceFilter = 10 //Metros
            manager.startUpdatingLocation()
        }
        manager.delegate = self
        
        self.obtenerPuntosDeCargas()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() //Parar de buscar la ubicacion
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapa.userLocation.title = "Te encontre"
            mapa.showsUserLocation = true
            mapa.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    //MARK: Funciones de Mapa
    func marcarPuntoEnMapa(miPunto: PuntoCarga){
    
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2D(latitude: miPunto.latitude, longitude: miPunto.longitude)
        dropPin.title = miPunto.address
        dropPin.subtitle = String(miPunto.detalleParaMapa())
        mapa.addAnnotation(dropPin)
    
    }
    
    //MARK: Funciones generales
    func obtenerPuntosDeCargas(){
        let servidorDePuntos = DondeCargoService()
        
        servidorDePuntos.obtenerPuntos{ (puntoCargo) -> () in
            if let misPuntos = puntoCargo{
                
                for miPunto in misPuntos{
                    self.marcarPuntoEnMapa(miPunto)
                }
                
            }
        }
    }
    
    
}

