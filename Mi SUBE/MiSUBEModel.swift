//
//  MiSUBEModel.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import RealmSwift

class MiSUBEModel: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

}

// Person model
class Tarjeta: Object {
    dynamic var alias = ""
    dynamic var numero = ""
    let movimientos = List<Movimiento>()
}

// Dog model
class Movimiento: Object {
    dynamic var fechaMovimiento = ""
    dynamic var tipoMovimiento = "C"
    dynamic var valorMovimiento: Double = 0
    
    // Properties can be optional
}
