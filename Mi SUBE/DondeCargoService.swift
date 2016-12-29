//
//  DondeCargoService.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 5/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation



class DondeCargoService {
    
    
    var miFiltro: Filtro!
    
    
    func generarURLValida(_ url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    fileprivate func generarBodyParaAgregarPuntoCarga(_ nuevoPunto: PuntoCarga) -> String {
        
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
    
    fileprivate func generarBodyDenunciarPuntoCarga(_ nuevoPunto: PuntoCarga) -> String {
        
        var resultado:String
        var parametro0:String
        
        parametro0 = ("params[id]=\(nuevoPunto.idPunto)")
        resultado = ("session=1390472&\(parametro0)")
        
        
        return resultado
        
        
        
    }
    
    fileprivate func generarBodyObtenerPuntosPOST(_ miUbicacion: MiUbicacion) -> String {
        
        var resultado:String
        var parametro0:String
        var parametro1:String
        
        parametro0 = ("params[lat]=\(miUbicacion.latitude)")
        parametro1 = ("params[lng]=\(miUbicacion.longitude)")
        resultado = ("session=1390472&\(parametro0)&\(parametro1)")
        
        
        return resultado
        
    }
    
    
    
    func agregarPuntoCarga(_ puntoNuevo: PuntoCarga, completionHandler: @escaping (_ response: Bool) -> ()) {
        
        let urlString: String = generarURLValida("http://dondecargolasube.com.ar/core/?query=addPoint")
        //urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=addPoint")
        
        if let url = URL(string: urlString) {
            
            //let request = NSMutableURLRequest(url: url)
            var request = URLRequest(url: url)
            let bodyData = self.generarBodyParaAgregarPuntoCarga(puntoNuevo)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            request.httpMethod = "POST"

            // let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    completionHandler(false)
                }
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("data: \(responseString)")
                
                if responseString! == "\"OK\"" {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
            
            task.resume()
        }
        
    }
    
    func denunciarPuntoCarga(_ puntoDenunciado: PuntoCarga, completionHandler: @escaping (_ response: Bool) -> ()) {
        //var urlString: String
        let urlString = generarURLValida("http://dondecargolasube.com.ar/core/?query=addFlagInvalid")
        
        if let url = URL(string: urlString) {
            
            //let request = NSMutableURLRequest(url: url)
            var request = URLRequest(url: url)
            let bodyData = self.generarBodyDenunciarPuntoCarga(puntoDenunciado)
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            request.httpMethod = "POST"
            
            // let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    completionHandler(false)
                }
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("data: \(responseString)")
                
                if responseString! == "\"OK\"" {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
                
            task.resume()
        }
        
    }
    
    
    func obtenerPuntosPOST(_ dondeEstoy: MiUbicacion?, callback: @escaping ([PuntoCarga]?) -> ()) {
        // var urlString: String
        let urlString = self.generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints")
        
        if let url = URL(string: urlString) {
            
            // DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async { // deprecated in IOS 8.0
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                //let request = NSMutableURLRequest(url: url)
                var request = URLRequest(url: url)
                
                if dondeEstoy != nil{
                    let bodyData = self.generarBodyObtenerPuntosPOST(dondeEstoy!)
                    request.httpBody = bodyData.data(using: String.Encoding.utf8)
                }
                
                request.httpMethod = "POST"
                
                //let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        DispatchQueue.main.async{
                            callback(nil)
                        }
                    }
                    
                    if let payload = data {
                        do {
                            let jsonDictionary = try JSONSerialization.jsonObject(with: payload, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                            DispatchQueue.main.async{
                                callback(self.desempaquetarPayLoad(jsonDictionary))
                            }
                        } catch {
                            DispatchQueue.main.async{
                                callback(nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async{
                            callback(nil)
                        }
                    }
                }
                
                task.resume()
            }
        }
    }
    
    
    fileprivate func desempaquetarPayLoad(_ jsonDictionaryArray: NSArray) -> [PuntoCarga] {
        
        var listadoPuntos = [PuntoCarga]()
        var horaApertura = 0
        var horaCierre = 0
        var cost = 0
        var flagSeller = 0
        
        for index in 0...jsonDictionaryArray.count - 1 {
            let item : AnyObject? = jsonDictionaryArray[index] as AnyObject?
            let punto = item as! Dictionary<String, AnyObject>
            if let puntoId = punto["id"] as? String {
                if let direccion = punto["address"] as? String {
                    if let latitud = punto["latitude"] as? String {
                        if let longitud = punto["longitude"] as? String {
                            if let tipo = punto["type"] as? String {
                                if let icono = punto["icon"] as? String {
                                    if let hourOpen = punto["hopen"] as? String {
                                        horaApertura = Int(hourOpen)!
                                    }
                                    if let hourClose = punto["hclose"] as? String {
                                        horaCierre = Int(hourClose)!
                                    }
                                    if let costoCarga = punto["cost"] as? Int {
                                        cost = costoCarga
                                    }
                                    if let fSeller = punto["flag_seller"] as? String {
                                        flagSeller = Int(fSeller)!
                                    }
                                    // Cargo el punto
                                    let nuevoPunto = PuntoCarga(idPunto: Int(puntoId)!, address: direccion.htmlDecoded(), latitude: Double(latitud)!, longitude: Double(longitud)!, type: tipo, icon: icono,cost: cost, hourOpen: horaApertura, hourClose: horaCierre, flagSeller: flagSeller)
                                    
                                    if aplicarFiltro(nuevoPunto) {
                                        listadoPuntos.append(nuevoPunto)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return listadoPuntos
        
    }
    
    
    func aplicarFiltro(_ miPunto: PuntoCarga) -> Bool {
    
        if miFiltro.ocultarCerrados {
            if miPunto.estaAbierto() == EstadoNegocio.cerrado {
                return false
            }
            
        }
        
        if miFiltro.ocultarCobraCarga {
            if miPunto.cobraPorCargar() == true {
                return false
            }
        
        }
        
        if miFiltro.ocultarNoVendeSUBE {
            if miPunto.vendeSube() == false {
                return false
            }
        
        }
        
        if miFiltro.ocutarHorarioSinIndicar {
            if miPunto.estaAbierto() == EstadoNegocio.indeterminado {
                return false
            }
        }
    
        return true
    }
}
