//
//  RouteViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 12/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import MapKit
import KYCircularProgress

class RouteViewController: UIViewController, MKMapViewDelegate {

    //MARK: Property
    var puntoDestino:PuntoCarga!
    var miUbicacion: MiUbicacion!
    
    // progress
    @IBOutlet weak var circularProgress: KYCircularProgress!
    @IBOutlet weak var progressOverlay: UIVisualEffectView!
    private var progress: UInt8 = 0
    
    //MARK: Outlet
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let mapaServicio = MapaService()
        //mapaServicio.calculateSegmentDirections(miUbicacion!, puntoDestino: puntoDestino, mapa: mapa, layoutProgress: progressOverlay )
        
        configureFourColorCircularProgress()
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // NavigationController Visible
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        if let puntoDestino = self.puntoDestino {

            let pinFactory = MarkerFactory()
            mapa.addAnnotation(pinFactory.makeCustomMarker(puntoDestino))
            mapa.showsUserLocation = true
            mapa.delegate = self
            
            let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
            let region = MKCoordinateRegion(center: miUbicacion.coordinate, span: span)
            mapa.showsUserLocation = true
            mapa.setRegion(region, animated: false)
            
            let mapaServicio = MapaService()
            mapaServicio.calculateSegmentDirections(miUbicacion!, puntoDestino: puntoDestino, mapa: mapa, layoutProgress: progressOverlay)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: MKMapViewDelegate
    //Seteo el color de la linea del mapa
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor(rgba: "#02BB4F").colorWithAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    
    //Dibujo los puntos que vinieron
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
    
    
    private func configureFourColorCircularProgress() {
        circularProgress.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        //view.addSubview(circularProgress)
    }
    
    func updateProgress() {
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / 255.0
        circularProgress.progress = normalizedProgress
    }

}
