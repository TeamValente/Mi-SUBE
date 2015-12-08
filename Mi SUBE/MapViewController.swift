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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var locateButton: UIButton!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var constraintDetalle: NSLayoutConstraint!
    //MARK: OutletsDetail
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectedPointDirection: UILabel!
    @IBOutlet weak var selectedPointDistance: UILabel!
    @IBOutlet weak var selectedPointHours: UILabel!
    @IBOutlet weak var selectedPointSellSube: UILabel!
    @IBOutlet weak var selectedPointType: UILabel!
    @IBOutlet weak var selectedPointCostCharge: UILabel!
    
    
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
        self.closeButton.alpha = 0
        //Los detalles deben arrancar oculto
        self.constraintDetalle.constant = -500
        // let gradientLayerView: UIView = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
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
        }else
        {
            //Pongo coordenadas en el obelisco si no esta activado el GPS
            self.miUbicacion = MiUbicacion(lat: -34.603075,lon: -58.381653)
            self.obtenerPuntosDeCargas()
        }
        
        //Marco los delegates
        manager.delegate = self
        mapa.delegate = self
        //En este punto cargo los centro que vienen por defecto
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() //Parar de buscar la ubicacion
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapa.userLocation.title = "Tu ubicación"
            mapa.showsUserLocation = true
            mapa.setRegion(region, animated: false)
            
            if (self.mapa.annotations.count < 2 || (self.miUbicacion?.coordinate.latitude != location.coordinate.latitude && self.miUbicacion?.coordinate.longitude != location.coordinate.longitude) ){
                self.miUbicacion = MiUbicacion(lat: location.coordinate.latitude,lon: location.coordinate.longitude)
                obtenerPuntosDeCargas()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if !(view.annotation is CustomPointAnnotation) {
            return
        }
        let cpa = view.annotation as! CustomPointAnnotation
        view.image = UIImage(named:cpa.imageSelected)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var fixPoint = CLLocationCoordinate2D(latitude: cpa.coordinate.latitude, longitude: cpa.coordinate.longitude)
        fixPoint.latitude = fixPoint.latitude - abs((fixPoint.latitude * 0.00005)) //Muevo la latitud para que se centre el punto.
        
        let region = MKCoordinateRegion(center: fixPoint, span: span)
        //mapa.setRegion(region, animated: true)
        self.constraintDetalle.constant = 0
        UIView.animateWithDuration(0.5, animations: {
            self.mapa.setRegion(region, animated: true)
            self.view.layoutIfNeeded()
            self.closeButton.alpha = 1
            self.locateButton.alpha = 0
            }, completion: nil)
        
        // seteamos los datos en el detalle
        self.selectedPointDirection.text = cpa.datos.address
        
        let distancia = miUbicacion?.getDistanciaAPuntoCarga(cpa.datos)
        
        self.selectedPointDistance.text = "\(distancia!.valorString) \(distancia!.unidad)"
        
        var stringHorario = cpa.datos.getHorarioDeAtencion()
        
        //Marco el estado
        if cpa.datos.estaAbierto() == EstadoNegocio.Abierto {
            stringHorario = "\(stringHorario), Abierto ahora"
        } else if cpa.datos.estaAbierto() == EstadoNegocio.Cerrado {
            stringHorario = "\(stringHorario), Cerrado"
        }
        self.selectedPointHours.text = "\(stringHorario)"
        
        if cpa.datos.vendeSube() {
            self.selectedPointSellSube.text = "Si"
        } else {
            self.selectedPointSellSube.text = "No"
        }
        
        if cpa.datos.cobraPorCargar(){
            self.selectedPointCostCharge.text = "Si"
        } else {
            self.selectedPointCostCharge.text = "No"
            
        }
        
        self.selectedPointType.text = cpa.datos.type
        
        if !(self.detailView.viewWithTag(3000) is UIVisualEffectView) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            
            blurEffectView.frame = self.mapa.frame
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            blurEffectView.layer.zPosition = -1
            blurEffectView.autoresizesSubviews = true
            blurEffectView.alpha = 0.9
            
            blurEffectView.tag = 3000 //le pongo este tag para no crearlo varias veces
            
            self.detailView.addSubview(blurEffectView)
            
        }
        
        
        //        //Prueba de agregar un punto
        //        let service: DondeCargoService
        //        service = DondeCargoService()
        //
        //        cpa.datos.idType = 1
        //
        //        service.agregarPuntoCarga(cpa.datos, completionHandler: {(response: Bool) -> () in
        //            print("response = \(response)")
        //
        //        })
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if !(view.annotation is CustomPointAnnotation) {
            return
        }
        let cpa = view.annotation as! CustomPointAnnotation
        view.image = UIImage(named:cpa.imageName)
        let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
        let region = MKCoordinateRegion(center: self.miUbicacion!.coordinate, span: span)
        self.constraintDetalle.constant = -500
        UIView.animateWithDuration(0.5, animations: {
            self.mapa.setRegion(region, animated: true)
            self.view.layoutIfNeeded()
            self.closeButton.alpha = 0
            self.locateButton.alpha = 1
            }, completion: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = false
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
        
    }
    //MARK: Cerrar detalle
    @IBAction func closeDetail() {
        self.constraintDetalle.constant = -500
        self.mapa.deselectAnnotation(nil,animated: false)
    }

    //MARK: Botonera Ubicarme
    @IBAction func buscarmeEnElMundo() {
        manager.startUpdatingLocation()
    }
    
    //MARK: Funciones de Mapa
    func marcarPuntoEnMapa(miPunto: PuntoCarga) {
        let pinFactory = MarkerFactory()
        mapa.addAnnotation(pinFactory.makeCustomMarker(miPunto))
    }
    
    //MARK: Funciones generales
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

