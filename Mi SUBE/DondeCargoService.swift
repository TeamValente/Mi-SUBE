//
//  DondeCargoService.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class DondeCargoService{
    
    func generarURLValida(url: String) -> String {
        
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
    }
    
    //Esta funcion se conecta por POST y pasa las cordenadas que se obtienen del manager location
    func obtenerPuntosCercanos(lat:String,lng: String, callback: [PuntoCarga]? ->()){
        
        var urlString: String
        urlString = generarURLValida("http://dondecargolasube.com.ar/core/")
        if let url = NSURL(string: urlString) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
                let request = NSMutableURLRequest(URL: url)
                let bodyData = "query=getNearPoints&params[lat]=\(lat)&params[lng]=\(lng)"
                request.HTTPMethod = "POST"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
                    if data != nil {
                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    }
                }
                task.resume()
            }
        }
    }
    
    
    //Esta funcion se conecta por GET y trae 299 puntos cercanos al obelisco
    func obtenerPuntos(dondeEstoy: MiUbicacion? , callback: [PuntoCarga]? ->()){
        
        var urlString: String
        
        if dondeEstoy != nil{
        urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints")
        }else
        {
        urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints&params[lat]=\(dondeEstoy?.longitude)&params[lng]=\(dondeEstoy?.latitude)")
        }
        
        let url = NSURL(string: urlString)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
            
            var listadoPuntos = [PuntoCarga]()
            var horaApertura = 0
            var horaCierre = 0
            
            if let data = NSData(contentsOfURL:url!){
                do{
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                    for index in 0...jsonDictionary.count-1{
                        let item : AnyObject? = jsonDictionary[index]
                        let punto = item as! Dictionary<String, AnyObject>
                        if let puntoId = punto["id"] as? String{
                            if let direccion = punto["address"] as? String{
                                if let latitud = punto["latitude"] as? String{
                                    if let longitud = punto["longitude"] as? String{
                                        if let tipo = punto["type"] as? String{
                                            if let icono = punto["icon"] as? String{
                                                if let hourOpen = punto["hopen"] as? String{
                                                    horaApertura = Int(hourOpen)!
                                                }
                                                if let hourClose = punto["hclose"] as? String{
                                                    horaCierre = Int(hourClose)!
                                                }
                                                //Cargo el punto
                                                
                                                listadoPuntos.append(PuntoCarga(idPunto: Int(puntoId)!, address: direccion.htmlDecoded(), latitude: Double(latitud)!, longitude: Double(longitud)!, type: tipo, icon: icono, hourOpen: horaApertura, hourClose: horaCierre))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        callback(listadoPuntos)
                    }
                }catch{
                    //No logro parsear el JSON
                    dispatch_async(dispatch_get_main_queue()){
                        callback(nil)
                        
                    }
                }
                
            }
            
        }
    }
    
}