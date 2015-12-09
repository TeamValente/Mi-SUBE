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
    
    
    //MARK: Variables de la clase
    var miTarjeta: Tarjeta!
    var managerModelo: ModelService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        miTarjeta = ModelService().getTarjeta()
        managerModelo = ModelService()
        aliasTarjeta.text = "$\(miTarjeta.saldo)"
        
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
        
    
    }

    @IBAction func sacarCredito(sender: UIButton) {
    
        let miMov = Movimiento()
        let monto = sender.titleLabel?.text
        miMov.valorMovimiento = Double(monto!)!
        
        managerModelo.actualizarSaldo(miMov)
        aliasTarjeta.text = "$\(managerModelo.getTarjeta().saldo)"
    
    }
    


}
