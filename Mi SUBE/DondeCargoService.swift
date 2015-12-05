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
    
    func obtenerPuntos(callback: [PuntoCarga]? ->()){
        
        let urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints")
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