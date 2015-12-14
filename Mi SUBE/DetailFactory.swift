//
//  DetailFactory.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 13/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import Foundation

class DetailFActory{


    private let datos: PuntoCarga
    
    init(datos: PuntoCarga){
    
        self.datos = datos
    
    }
    
    func getDireccion()->String
    {
        return datos.address
    
    }
    
    func getDistancia(miUbicacion: MiUbicacion)->String
    {
        let distancia = miUbicacion.getDistanciaAPuntoCarga(datos)
        return "\(distancia.valorString) \(distancia.unidad)"
    }
    
    func getHorario()->String
    {
        if datos.estaAbierto() == EstadoNegocio.Abierto
        {
            return  "\(datos.getHorarioDeAtencion()), Abierto ahora"
        } else if datos.estaAbierto() == EstadoNegocio.Cerrado
        {
            return "\(datos.getHorarioDeAtencion()), Cerrado"
        }else
        {
            return "Sin horario cargado"
        }
    }
    
    func getVendeSube()->String
    {
        if datos.vendeSube() {
            return "Si"
        } else {
            return "No"
        }
    
    }
    
    func getCobraCarga()->String{
        if datos.cobraPorCargar(){
            return "Si"
        } else {
            return "No"
            
        }
    
    }
    
    func getTipoPunto()->String{
    
        return datos.type
    
    }



}