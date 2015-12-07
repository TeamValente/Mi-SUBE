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
    
    private func generarBodyParaAgregarPuntoCarga(nuevoPunto: PuntoCarga) ->String{
        
        var resultado:String
        var parametro0:String
        var parametro1:String
        var parametro2:String
        var parametro3:String
        var parametro4:String
        var parametro5:String
        var parametro6:String
        var parametro7:String
        
        
        
        parametro0 = ("params[0][name]=address&params[0][value]=\(nuevoPunto.address)")
        parametro1 = ("params[1][name]=type&params[1][value]=\(nuevoPunto.idType!)")
        parametro2 = ("params[2][name]=hour_from&params[2][value]=\(nuevoPunto.hourOpen)")
        parametro3 = ("params[3][name]=hour_to&params[3][value]=\(nuevoPunto.hourClose)")
        parametro4 = ("params[4][name]=cost&params[4][value]=\(nuevoPunto.cost)")
        parametro5 = ("params[5][name]=seller&params[5][value]=\(nuevoPunto.flagSeller)")
        parametro6 = ("params[6][name]=lat&params[6][value]=\(nuevoPunto.latitude)")
        parametro7 = ("params[7][name]=lng&params[7][value]=\(nuevoPunto.longitude)")
        
        
        resultado = ("session=1390472&\(parametro0)&\(parametro1)&\(parametro2)&\(parametro3)&\(parametro4)&\(parametro5)&\(parametro6)&\(parametro7)")
        
        
        return resultado
        
        
        
    }
    
    func agregarPuntoCarga(puntoNuevo: PuntoCarga, completionHandler: (response: Bool) -> ())
    {
        var urlString: String
        urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=addPoint")
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)
            let bodyData = self.generarBodyParaAgregarPuntoCarga(puntoNuevo)
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPMethod = "POST"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
                if error != nil {
                    print("error=\(error)")
                    completionHandler(response: false)
                }
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("data: \(responseString)")
                
                if responseString! == "\"OK\""
                {
                    completionHandler(response: true)
                }else
                {
                    completionHandler(response: false)
                }
            }
            task.resume()
        }
        
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
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                }
                request.HTTPMethod = "POST"
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data1, response, error) in
                    if error != nil {
                        //print("error=\(error)")
                        callback(nil)
                    }
                    
                    if let data = data1{
                        var listadoPuntos = [PuntoCarga]()
                        var horaApertura = 0
                        var horaCierre = 0
                        var cost = "0"
                        var flagSeller = 0
                        //Parseo el data
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
                                                        if let costoCarga = punto["cost"] as? String{
                                                            cost = costoCarga
                                                        }
                                                        if let fSeller = punto["flagSeller"] as? String{
                                                            flagSeller = Int(fSeller)!
                                                        }
                                                        //Cargo el punto
                                                        
                                                        listadoPuntos.append(PuntoCarga(idPunto: Int(puntoId)!, address: direccion.htmlDecoded(), latitude: Double(latitud)!, longitude: Double(longitud)!, type: tipo, icon: icono,cost: cost, hourOpen: horaApertura, hourClose: horaCierre, flagSeller: flagSeller))
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
                    }else{
                        dispatch_async(dispatch_get_main_queue()){
                            callback(nil)
                        }
                    }
                }
                
                
                
                task.resume()
            }
        }
    }
    
    //Esta funcion se conecta por GET y trae 299 puntos por defecto NO SE USA MAS
    func obtenerPuntosGET(dondeEstoy: MiUbicacion? , callback: [PuntoCarga]? ->()){
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
            var cost = "0"
            var flagSeller = 0
            
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
                                                if let costoCarga = punto["cost"] as? String{
                                                    cost = costoCarga
                                                }
                                                if let fSeller = punto["flagSeller"] as? String{
                                                    flagSeller = Int(fSeller)!
                                                }
                                                //Cargo el punto
                                                
                                                listadoPuntos.append(PuntoCarga(idPunto: Int(puntoId)!, address: direccion.htmlDecoded(), latitude: Double(latitud)!, longitude: Double(longitud)!, type: tipo, icon: icono,cost: cost, hourOpen: horaApertura, hourClose: horaCierre, flagSeller:flagSeller))
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