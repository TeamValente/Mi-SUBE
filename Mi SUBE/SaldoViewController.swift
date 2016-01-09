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
    
    @IBOutlet weak var button_ok: UIButton!
    @IBOutlet weak var position_ok: NSLayoutConstraint!
    
    @IBOutlet weak var buttonDelete: UIButton!
    
    
    func switchButtonState(enabled:Bool) {
    
        switch enabled {
        case true:
                UIView.animateWithDuration(0.5, animations: {
                    self.button_ok.alpha = 1
                    self.position_ok.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
        case false:
                UIView.animateWithDuration(0.35, animations: {
                    self.button_ok.alpha = 0
                    self.position_ok.constant = -8
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @IBAction func agregarMovimiento() {
        
        
        if let input = monto.text {
            if let valorDecimal = Double(input.stringByReplacingOccurrencesOfString(",", withString: ".")) {
                let managerModelo = TarjetaSUBEService()
                miTarjeta = managerModelo.getTarjeta()
                switch segmentAction.selectedSegmentIndex {
                case 0:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = NSDate()
                    miMovimiento.valorMovimiento = valorDecimal - (valorDecimal*2)
                    managerModelo.actualizarSaldo(miMovimiento)
                    switchButtonState(false)
                case 1:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = NSDate()
                    miMovimiento.valorMovimiento = valorDecimal
                    managerModelo.actualizarSaldo(miMovimiento)
                    switchButtonState(false)
                default:
                    break
                }
                loadSaldo()
                monto.text = ""
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        button_ok.alpha = 0
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        loadSaldo()
        
        if monto.text?.characters.count > 0 {
            buttonDelete.highlighted = false
           
        } else {
            buttonDelete.highlighted = true
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
                switchButtonState(false)
            }
        case ",":
            if preMonto.rangeOfString(",") == nil {
                preMonto = "\(preMonto)\(input)"
            }
        default:
            switchButtonState(true)
            preMonto = "\(preMonto)\(input)"
        }
        
        monto.text = "\(preMonto)"
        if monto.text?.characters.count > 0 {
            buttonDelete.highlighted = false
            
        } else {
            buttonDelete.highlighted = true
            
        }
        
    }
    
    func loadSaldo() {
        
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
        
        if miTarjeta.saldo < 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.cardView.backgroundColor = UIColor(rgba: "#E8573C")
            }, completion: nil)
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.cardView.backgroundColor = UIColor(rgba: "#3C83E9")
            }, completion: nil)
        }
        labelSaldo.text = "\(miTarjeta.saldo)"
        if managerModelo.getUltimoMovimiento().isEmpty {
            labelLastUpdate.text = "No hay movientos registrados."
        } else {
            labelLastUpdate.text = "Actualizado hace \(managerModelo.getUltimoMovimiento())."
        }

    }
    
    
    
}
