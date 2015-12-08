//
//  Distancia.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class Distancia {
    
    var valor: Double
    var unidad: String
    
    init(valor: Double, unidad: String)
    {
        //Siempre se reciben
        self.valor = valor
        self.unidad = unidad
    }
}