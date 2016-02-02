//
//  Filtro.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 1/2/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class Filtro {

    var verCobraCarga = true
    var verCerrados = true
    var verVendeSUBE = true
    
    
    init(){}
    
    init(verCobraCarga: Bool, verCerrados: Bool, verVendeSUBE: Bool)
    {
        //Siempre se reciben
        self.verCobraCarga = verCobraCarga
        self.verCerrados = verCerrados
        self.verVendeSUBE   = verVendeSUBE
    }
    
    
    
}