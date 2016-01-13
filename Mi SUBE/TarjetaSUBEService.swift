//
//  ModelService.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Results.Generator.Element] {
        return map { $0 }
    }
}

class TarjetaSUBEService{
    
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
    
    func listadoDeMovimientos(orderBy: String)->[Movimiento]
    {
        
        //ManagerRealm
        let realm = try! Realm()
        var order = true
        
        if orderBy == "desc"
        {
           order = false
        }
        
        let  movimientos = realm.objects(Movimiento).sorted("fechaMovimiento", ascending: order)
        return movimientos.toArray()
        
    }
    
    func getTarjeta()->Tarjeta
    {
        return miTarjeta
    }
    
    func removeTarjeta()
    {
        //ManagerRealm
        let realm = try! Realm()
        //Traigo las tarjeta debe venir solo una
        let tarjetas = realm.objects(Tarjeta).filter("id = 1")
        if tarjetas.count != 0{
            try! realm.write {
                realm.delete(tarjetas[0])
            }
            
        }
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
    
    func getUltimoMovimiento()->String
    {
        
        let realm = try! Realm()
        var retorno:String = ""
        if miTarjeta.movimientos.count > 0
        {
            if let ultimoMov = realm.objects(Movimiento).last
            {
                let fechaUltimoMov: NSDate = ultimoMov.fechaMovimiento
                print(retorno)
                
                retorno = NSDate().offsetFrom(fechaUltimoMov)
                print(NSDate().offsetFrom(fechaUltimoMov))
                
            }
            
        }
        
        return retorno
        
    }
    
    
    
}