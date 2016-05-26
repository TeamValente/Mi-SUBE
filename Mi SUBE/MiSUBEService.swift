//
//  MiSUBEService.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 26/5/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import Alamofire

class MiSUBEService {
    
    var mFiltro: Filtro!
    
    func generarURLValida(url: String) -> String {
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    
    func obtenerPuntosPOST(dondeEstoy: MiUbicacion?, callback: [PuntoCarga]? ->()){
        
        let parameters = [
            "session": "1390472",
            "params": [
                "lat": "\(dondeEstoy?.latitude)",
                "lng": "\(dondeEstoy?.longitude)"
            ]
        ]

        Alamofire.request(.POST, self.generarURLValida("http://dondecargolasube.com.ar/core/?query=getNearPoints"), parameters: parameters)
         .validate()
         .responseJSON { response in
             switch response.result {
             case .Success:
                 print("Validation Successful")
             case .Failure(let error):
                 print(error)
             }
         }
        // HTTP body: foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3

    }
    
}