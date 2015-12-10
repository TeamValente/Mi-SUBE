//
//  SaldoViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 10/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class SaldoViewController: UIViewController {
    
    
    //MARK: Variables
    var miTarjeta: Tarjeta!
    
    //MARK: Outelets
    
    @IBOutlet weak var labelSaldo: UILabel!

    @IBOutlet weak var labelLastUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
        
        if miTarjeta.saldo == 0{
            let miMovimiento = Movimiento()
            miMovimiento.fechaMovimiento = NSDate()
            miMovimiento.valorMovimiento = 100
            managerModelo.actualizarSaldo(miMovimiento)
        }
        
        labelSaldo.text = "\(miTarjeta.saldo)"
        labelLastUpdate.text = "\(managerModelo.getUltimoMovimiento())"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
