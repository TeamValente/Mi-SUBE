//
//  MiSUBEModel.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import RealmSwift

// Person model
class Tarjeta: Object {
    dynamic var alias = "Tarjeta"
    dynamic var id = 0
    let movimientos = List<Movimiento>()
    dynamic var saldo:Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// Dog model
class Movimiento: Object {
    dynamic var fechaMovimiento = NSDate()
    dynamic var valorMovimiento: Double = 0
    // Properties can be optional
}
