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
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var monto: UILabel!
    @IBOutlet weak var segmentAction: UISegmentedControl!
    @IBOutlet weak var labelSaldo: UILabel!
    @IBOutlet weak var labelLastUpdate: UILabel!
    
    
    @IBAction func agregarMovimiento() {
        
        
        if let input = monto.text{
            if let valorDecimal = Double(input.stringByReplacingOccurrencesOfString(",", withString: "."))
            {
                let managerModelo = TarjetaSUBEService()
                miTarjeta = managerModelo.getTarjeta()
                switch segmentAction.selectedSegmentIndex {
                case 0:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = NSDate()
                    miMovimiento.valorMovimiento = valorDecimal - (valorDecimal*2)
                    managerModelo.actualizarSaldo(miMovimiento)
                case 1:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = NSDate()
                    miMovimiento.valorMovimiento = valorDecimal
                    managerModelo.actualizarSaldo(miMovimiento)
                default:
                    break
                }
                miTarjeta = managerModelo.getTarjeta()
                labelSaldo.text = "\(miTarjeta.saldo)"
                labelLastUpdate.text = "Actualizado hace \(managerModelo.getUltimoMovimiento())."
                monto.text = ""
            }
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
  
        cardView.layer.cornerRadius = 10;
        cardView.layer.masksToBounds = true;
        
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
        labelSaldo.text = "\(miTarjeta.saldo)"
        if managerModelo.getUltimoMovimiento().isEmpty {
            labelLastUpdate.text = "No hay movientos registrados."
        } else {
        labelLastUpdate.text = "Actualizado hace \(managerModelo.getUltimoMovimiento())."
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setAmount(sender: UIButton) {
        
        let input: String = sender.titleLabel!.text!
        var preMonto: String = monto.text!
        
        switch input{
        case "Borrar":
            if preMonto.characters.count > 0 {
                preMonto.removeAtIndex(preMonto.endIndex.predecessor())
            }
        case ",":
            if preMonto.rangeOfString(",") == nil{
                preMonto = "\(preMonto)\(input)"
            }
        default:
            preMonto = "\(preMonto)\(input)"
        }
        
        monto.text = "\(preMonto)"
        
    }
    
    
    
}
