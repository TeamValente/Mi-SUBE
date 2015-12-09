//
//  SaldoViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class SaldoViewController: UIViewController {

    @IBOutlet weak var aliasTarjeta: UITextField!
    @IBOutlet weak var movimientos: UITextView!
    
    
    //MARK: Variables de la clase
    var miTarjeta: Tarjeta!
    var managerModelo: ModelService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        miTarjeta = ModelService().getTarjeta()
        managerModelo = ModelService()
        aliasTarjeta.text = "$\(miTarjeta.saldo)"
    
        cargoMovimientos(miTarjeta)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agregoCredito(sender: UIButton) {
    
        let miMov = Movimiento()
        let monto = sender.titleLabel?.text
        miMov.valorMovimiento = Double(monto!)!
        
        managerModelo.actualizarSaldo(miMov)
        aliasTarjeta.text = "$\(managerModelo.getTarjeta().saldo)"
    
        cargoMovimientos(managerModelo.getTarjeta())
    
    }

    @IBAction func sacarCredito(sender: UIButton) {
    
        let miMov = Movimiento()
        let monto = sender.titleLabel?.text
        miMov.valorMovimiento = Double(monto!)!
        
        managerModelo.actualizarSaldo(miMov)
        aliasTarjeta.text = "$\(managerModelo.getTarjeta().saldo)"
    
        cargoMovimientos(managerModelo.getTarjeta())
        
    }
    
    func cargoMovimientos(tarjeta: Tarjeta)
    {
    
        movimientos.text = "Movimientos: \n"
        var salida = movimientos.text
        for mov in tarjeta.movimientos
        {
            salida = "\(salida) fecha: \(mov.fechaMovimiento) monto: \(mov.valorMovimiento) \n"
        }
        
        movimientos.text = salida
    }
    


}
