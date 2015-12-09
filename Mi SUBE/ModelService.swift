//
//  ModelService.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import RealmSwift

class ModelService{

    private var miTarjeta:Tarjeta
    //Creo una tarjeta de cero si no existen
    init()
    {
    
        //ManagerRealm
        let realm = try! Realm()
        
        
        //Traigo las tarjeta debe venir solo una
        let tarjetas = realm.objects(Tarjeta).filter("id = 1")
        if tarjetas.count == 0{
            miTarjeta = Tarjeta()
            try! realm.write {
                self.miTarjeta.id = 1
                realm.add(self.miTarjeta)
            }
        }else
        {
            miTarjeta = tarjetas[0]
        }
    }

    func listadoDeMovimientos()->List<Movimiento>
    {
        return miTarjeta.movimientos
    }
    
    func getTarjeta()->Tarjeta
    {
        return miTarjeta
    }
    
    func actualizarSaldo(nuevoMovimiento: Movimiento)
    {
        
        //ManagerRealm
        let realm = try! Realm()
        let nuevoSaldo:Double = miTarjeta.saldo + nuevoMovimiento.valorMovimiento
        try! realm.write {
            self.miTarjeta.saldo = nuevoSaldo
            self.miTarjeta.movimientos.append(nuevoMovimiento)
            realm.add(self.miTarjeta , update: true)
        }
        
        
    
    }



}