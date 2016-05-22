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
import Crashlytics

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!

    //MARK: Outlet backdrop
    
    @IBOutlet weak var backdropView: UIView!
    
    //MARK: Outlets detailView
    @IBOutlet weak var selectedPointDistance: UILabel!
    
    @IBOutlet weak var detailView: UIVisualEffectView!
    @IBOutlet weak var constraintDetalle: NSLayoutConstraint!

    
    //MARK: Outlets filterView
    @IBOutlet weak var filterView: UIVisualEffectView!
    @IBOutlet weak var constrainFiltro: NSLayoutConstraint!
    
    //MARK: OutletsDetail
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectedPointDirection: UILabel!
    @IBOutlet weak var selectedPointHours: UILabel!
    @IBOutlet weak var selectedPointSellSube: UILabel!
    @IBOutlet weak var selectedPointType: UILabel!
    @IBOutlet weak var selectedPointCostCharge: UILabel!
    
    
    @IBOutlet weak var switchCerrado: UISwitch!
    
    @IBOutlet weak var switchCobraCarga: UISwitch!
    
    @IBOutlet weak var switchVendeSUBE: UISwitch!
    
    //MARK: Variables de la clase
    var manager: CLLocationManager!
    @IBOutlet weak var switchHorarioSinIndicar: UISwitch!
    var miUbicacion: MiUbicacion!
    var miFiltro: Filtro!
    
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //Activo el Manager
        manager = CLLocationManager()
        
        //Cargo un filtro para probar
        miFiltro = Filtro()
        
        self.backdropView.alpha = 0
        
        //Arranca con el menu oculto
        self.closeButton.alpha = 0
        
        //Arranca con boton de filtro oculto
        self.filterButton.alpha = 0
        
        //Los detalles deben arrancar oculto
        self.constraintDetalle.constant = -500
        self.constrainFiltro.constant = -500
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        //Pido Request del Location
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            //Distancia accuracy
            if miUbicacion == nil {
                manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                manager.distanceFilter = 10 //Metros
                manager.startUpdatingLocation()
            }

        }
        //Marco los delegates
        manager.delegate = self
        mapa.delegate = self
        //En este punto cargo los centro que vienen por defecto
    }
    
    override func viewWillAppear(animated: Bool) {
        // navigation controller hidden
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapViewToRouteView" {
            if let routeController = segue.destinationViewController as? RouteViewController {
                if mapa.selectedAnnotations.count == 1 {
                    let puntoSeleccionado = mapa.selectedAnnotations[0]
                    if !(puntoSeleccionado is CustomPointAnnotation) {
                        return
                    }
                    let cpa = puntoSeleccionado as! CustomPointAnnotation
                    routeController.puntoDestino = cpa.datos
                    routeController.miUbicacion = miUbicacion!
                }
            }
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
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
           
            
            //Pido Request si se movio el usuario o si no se cargaron puntos.
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
        //self.detailView.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.mapa.setRegion(region, animated: true)
            self.view.layoutIfNeeded()
            self.closeButton.alpha = 1
            self.locateButton.alpha = 0
            self.filterButton.alpha = 0
            }, completion: nil)
        
        // seteamos los datos en el detalle
        let factoryDetalles = DetailHelper(datos: cpa.datos)
        self.selectedPointDirection.text = factoryDetalles.getDireccion()
        //self.selectedPointDistance.setTitle(factoryDetalles.getDistancia(miUbicacion), forState: .Normal)
        self.selectedPointDistance.text = factoryDetalles.getDistancia(miUbicacion)
        self.selectedPointHours.text = factoryDetalles.getHorario()
        self.selectedPointSellSube.text = factoryDetalles.getVendeSube()
        self.selectedPointCostCharge.text = factoryDetalles.getCobraCarga()
        self.selectedPointType.text = factoryDetalles.getTipoPunto()
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if !(view.annotation is CustomPointAnnotation) {
            return
        }
        let cpa = view.annotation as! CustomPointAnnotation
        view.image = UIImage(named:cpa.imageName)
        let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
        let region = MKCoordinateRegion(center: self.miUbicacion!.coordinate, span: span)
        
        //Se cierra el detalle cuando se saca el foco de un punto.
        
        self.cerrarDetalle()
        UIView.animateWithDuration(0.5, animations: {
            self.mapa.setRegion(region, animated: true)
            self.view.layoutIfNeeded()
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
    
    
    //MARK: BTN Detail
    @IBAction func closeDetail() {
        self.cerrarDetalle()
        self.mapa.deselectAnnotation(nil,animated: false)
    }
    
    func cerrarDetalle() {
    
        UIView.animateWithDuration(0.5, animations: {
            self.backdropView.alpha = 0
            self.constraintDetalle.constant = -500
            self.constrainFiltro.constant = -500
            self.closeButton.alpha = 0
            self.locateButton.alpha = 1
            self.filterButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    
    @IBAction func selectedPointDistanceButton(sender: AnyObject) {
        // TODO: Add tracking event
        // Answers.logCustomEventWithName("Open Route View", customAttributes: ["destinationPoin": ])
        performSegueWithIdentifier("mapViewToRouteView", sender: self)
    }
    
    //MARK: BTN Location
    @IBAction func buscarmeEnElMundo() {
        manager.startUpdatingLocation()
    }
    
    
    @IBAction func openFilterView() {
        UIView.animateWithDuration(0.5, animations: {
            self.backdropView.alpha = 1
            self.constrainFiltro.constant = 0
            self.closeButton.alpha = 1
            self.locateButton.alpha = 0
            self.filterButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: Show Filter Button
    func mostrarFiltro() {
        UIView.animateWithDuration(0.25, animations: {
            self.filterButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    //MARK: Funciones Filtrado
    @IBAction func verCerrados(sender: AnyObject) {
        miFiltro.ocultarCerrados = self.switchCerrado.on
        obtenerPuntosDeCargas()
    }
    
    @IBAction func verCobroCarga(sender: AnyObject){
        miFiltro.ocultarCobraCarga = switchCobraCarga.on
        obtenerPuntosDeCargas()
    }
    
    @IBAction func verVendeSUBE(sender: AnyObject) {
        miFiltro.ocultarNoVendeSUBE = switchVendeSUBE.on
        obtenerPuntosDeCargas()
    }
    
    @IBAction func verHorarioSinIndicar(sender: AnyObject) {
        miFiltro.ocutarHorarioSinIndicar = switchHorarioSinIndicar.on
        obtenerPuntosDeCargas()
    }
    
    
    //MARK: Funciones de Mapa
    func marcarPuntoEnMapa(miPunto: PuntoCarga) {
        let pinFactory = MarkerFactory()
        mapa.addAnnotation(pinFactory.makeCustomMarker(miPunto))
    }
    
    //MARK: Funciones generales
    func obtenerPuntosDeCargas(){
        let servidorDePuntos = DondeCargoService()
        servidorDePuntos.miFiltro = self.miFiltro
        servidorDePuntos.obtenerPuntosPOST(self.miUbicacion){(puntoCargo) -> () in
            if let misPuntos = puntoCargo{
                //Borro todos los puntos para volver a cargarlos
                self.mapa.removeAnnotations(self.mapa.annotations)
                for miPunto in misPuntos{
                    self.marcarPuntoEnMapa(miPunto)
                }
                //Muestro boton de filtro
                self.mostrarFiltro()
            }
        }
    }

}

