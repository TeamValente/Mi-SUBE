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
    @IBOutlet weak var menuUbicarme: UIView!
    
    @IBOutlet weak var constraintMenuUbicarme: NSLayoutConstraint!
    
    
    //MARK: Variables de la clase
    var manager: CLLocationManager!
    var miUbicacion:MiUbicacion?
    
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Activo el Manager
        manager = CLLocationManager()
        //Arranca con el menu oculto
        self.constraintMenuUbicarme.constant = self.menuUbicarme.frame.height * -1
        
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
        //En este punto cargo los centro que vienen por defecto
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
            self.miUbicacion = MiUbicacion(lat: location.coordinate.latitude,lon: location.coordinate.longitude)
            obtenerPuntosDeCargas()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    //MARK: Gestos
    @IBAction func tabMenuUbicar(sender: AnyObject){
        self.manejarMenuUbicarme()
    }
    
    //MARK: Botonera Ubicarme
    
    @IBAction func buscarmeEnElMundo() {
        manager.startUpdatingLocation()
        
    }
    
    
    //MARK: Funciones de Mapa
    func marcarPuntoEnMapa(miPunto: PuntoCarga){
        
//        let dropPin = MKPointAnnotation()
//        dropPin.coordinate = CLLocationCoordinate2D(latitude: miPunto.latitude, longitude: miPunto.longitude)
//        dropPin.title = miPunto.address
//        dropPin.subtitle = String(miPunto.detalleParaMapa())
//        mapa.addAnnotation(dropPin)
        
        let pinFactory = MarketFactory()
        mapa.addAnnotation(pinFactory.makeCustomMarker(miPunto))
        
    }
    
    //MARK: Funciones generales
    
    func manejarMenuUbicarme()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            if self.constraintMenuUbicarme.constant != 0{
                self.constraintMenuUbicarme.constant = 0
                
            }else
            {
                self.constraintMenuUbicarme.constant = self.menuUbicarme.frame.height * -1
            }
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func obtenerPuntosDeCargas(){
        let servidorDePuntos = DondeCargoService()
        servidorDePuntos.obtenerPuntosPOST(self.miUbicacion){(puntoCargo) -> () in
            if let misPuntos = puntoCargo{
                //Borro todos los puntos para volver a cargarlos
                self.mapa.removeAnnotations(self.mapa.annotations)
                for miPunto in misPuntos{
                    self.marcarPuntoEnMapa(miPunto)
                }
            }
        }
    }
}

