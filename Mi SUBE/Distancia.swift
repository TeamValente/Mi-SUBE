//
//  Distancia.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class Distancia {
    
    var valorNumerico: Double
    var unidad: String
    var valorString: String
    
    init(valorNum: Double, valorStr: String, unidad: String)
    {
        //Siempre se reciben
        self.valorNumerico = valorNum
        self.unidad = unidad
        self.valorString   = valorStr
    }
}