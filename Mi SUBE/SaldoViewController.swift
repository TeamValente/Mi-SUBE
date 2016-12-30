//
//  SaldoViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 10/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import Spring
import Crashlytics
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SaldoViewController: UIViewController {
    
    //MARK: Variables
    var miTarjeta: Tarjeta!
    
    //MARK: Mofiler Helper
    let hMofiler = HelperMofiler(debugFlag: false)
    
    //MARK: Outelets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var monto: UILabel!
    @IBOutlet weak var segmentAction: UISegmentedControl!
    @IBOutlet weak var labelSaldo: UILabel!
    @IBOutlet weak var labelLastUpdate: UILabel!
    @IBOutlet weak var button_ok: UIButton!
    @IBOutlet weak var position_ok: NSLayoutConstraint!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func viewDidLoad() {
        // navigation controller hidden
        self.navigationController?.isNavigationBarHidden = true
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SaldoViewController.Long)) //Long function will call when user long press on button.
        //tapGesture.numberOfTapsRequired = 1
        buttonDelete.addGestureRecognizer(longGesture)
    }
    
    func Long() {
        
        self.monto.text = ""
    }
    
    func switchButtonState(_ enabled:Bool) {
        
        switch enabled {
        case true:
            UIView.animate(withDuration: 0.5, animations: {
                self.button_ok.alpha = 1
                self.position_ok.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        case false:
            UIView.animate(withDuration: 0.35, animations: {
                self.button_ok.alpha = 0
                self.position_ok.constant = -8
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @IBAction func agregarMovimiento() {
        
        
        if let input = monto.text {
            if let valorDecimal = Double(input.replacingOccurrences(of: ",", with: ".")) {
                let managerModelo = TarjetaSUBEService()
                miTarjeta = managerModelo.getTarjeta()
                switch segmentAction.selectedSegmentIndex {
                case 0:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = Date()
                    miMovimiento.valorMovimiento = valorDecimal - (valorDecimal*2)
                    managerModelo.actualizarSaldo(miMovimiento)
                    switchButtonState(false)
                    Answers.logCustomEvent(withName: "Add Travel", customAttributes: ["Price": valorDecimal])
                    
                    // mofiler track event
                    let valueDictionary: [String:Any] = ["travelAmount": valorDecimal]
                    self.hMofiler.setValue(newValue: "addTravel", valueDictionary: valueDictionary, chekKey: "travelAmount")
                case 1:
                    let miMovimiento = Movimiento()
                    miMovimiento.fechaMovimiento = Date()
                    miMovimiento.valorMovimiento = valorDecimal
                    managerModelo.actualizarSaldo(miMovimiento)
                    switchButtonState(false)
                    Answers.logCustomEvent(withName: "Add Charge", customAttributes: ["Price": valorDecimal])
                    
                    // mofiler track event
                    let valueDictionary: [String:Any] = ["chargeAmount": valorDecimal]
                    self.hMofiler.setValue(newValue: "addCreditToCard", valueDictionary: valueDictionary, chekKey: "chargeAmount")
                default:
                    break
                }
                loadSaldo()
                monto.text = ""
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent

        button_ok.alpha = 0
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        loadSaldo()
        
        if monto.text?.characters.count > 0 {
            buttonDelete.isHighlighted = false
            
        } else {
            buttonDelete.isHighlighted = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigation controller hidden
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func setAmount(_ sender: UIButton) {
        
        let input: String = sender.titleLabel!.text!
        var preMonto: String = monto.text!
        
        switch input{
        case "Borrar":
            if preMonto.characters.count > 0 {
                preMonto.remove(at: preMonto.characters.index(before: preMonto.endIndex))
                
                if preMonto.characters.count == 0 {
                    switchButtonState(false)
                }
            }
        case ",":
            if preMonto.characters.count < 6 {
                if preMonto.range(of: ",") == nil {
                    preMonto = "\(preMonto)\(input)"
                }
            }
        default:
            if preMonto.characters.count < 7 {
                switchButtonState(true)
                preMonto = "\(preMonto)\(input)"
            }
        }
        
        monto.text = "\(preMonto)"
        if monto.text?.characters.count > 0 {
            buttonDelete.isHighlighted = false
            
        } else {
            buttonDelete.isHighlighted = true
        }
        
    }
    
    func loadSaldo() {
        
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
        
        if miTarjeta.saldo < 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.cardView.backgroundColor = UIColor("#E8573C")
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.cardView.backgroundColor = UIColor("#3C83E9")
                }, completion: nil)
        }
        labelSaldo.text = String(format: "%.2f", miTarjeta.saldo)
        if managerModelo.getUltimoMovimiento().isEmpty {
            labelLastUpdate.text = "No hay movientos registrados."
        } else {
            labelLastUpdate.text = "Actualizado hace \(managerModelo.getUltimoMovimiento())."
        }
        
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
}
