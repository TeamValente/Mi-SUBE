//
//  Filtro.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 1/2/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class Filtro {

    var ocultarCobraCarga = false
    var ocultarCerrados = false
    var ocultarNoVendeSUBE = false
    var ocutarHorarioSinIndicar = false
    
    
    init(){}
    
    init(ocultarCobraCarga: Bool, ocultarCerrados: Bool, ocultarNoVendeSUBE: Bool, ocutarHorarioSinIndicar: Bool)
    {
        //Siempre se reciben
        self.ocultarCobraCarga = ocultarCobraCarga
        self.ocultarCerrados = ocultarCerrados
        self.ocultarNoVendeSUBE   = ocultarNoVendeSUBE
        self.ocutarHorarioSinIndicar = ocutarHorarioSinIndicar
    }
    
    
    
}