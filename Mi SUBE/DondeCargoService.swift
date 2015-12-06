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
    
    func obtenerPuntosSUBEOficial(callback: [PuntoCarga]? ->()){
        
    }
    
    //Esta funcion se conecta por POST y pasa las cordenadas que se obtienen del manager location
    func obtenerPuntosPOST(dondeEstoy: MiUbicacion?, callback: [PuntoCarga]? ->()){
        
        var urlString: String
        urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints")
        if let url = NSURL(string: urlString) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
                let request = NSMutableURLRequest(URL: url)
                if dondeEstoy != nil{
                    let bodyData = "session=1390472&params[lat]=\(dondeEstoy!.latitude)&params[lng]=\(dondeEstoy!.longitude)"
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                    
                }
                request.HTTPMethod = "POST"
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                    
                    print("response = \(response)")
                    
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                    var listadoPuntos = [PuntoCarga]()
                    var horaApertura = 0
                    var horaCierre = 0
                    
                    //Parseo el data
                    do{
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                        //print(jsonDictionary.count)
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
                task.resume()
            }
        }
    }
    
    
    //Esta funcion se conecta por GET y trae 299 puntos por defecto
    func obtenerPuntos(dondeEstoy: MiUbicacion? , callback: [PuntoCarga]? ->()){
        var urlString: String
        if let ubicacion = dondeEstoy {
            urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints&session=1390472&&params[lat]=\(ubicacion.latitude)&params[lng]=\(ubicacion.longitude)")
        }else
        {
            urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints")
        }
        let url = NSURL(string: urlString)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
            
            var listadoPuntos = [PuntoCarga]()
            var horaApertura = 0
            var horaCierre = 0
            
            if let data = NSData(contentsOfURL:url!){
                do{
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                    //print(jsonDictionary.count)
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