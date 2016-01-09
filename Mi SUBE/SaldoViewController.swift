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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        cardView.layer.cornerRadius = 10;
        cardView.layer.masksToBounds = true;
        
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
        
        if miTarjeta.saldo == 0{
            let miMovimiento = Movimiento()
            miMovimiento.fechaMovimiento = NSDate()
            miMovimiento.valorMovimiento = 100
            managerModelo.actualizarSaldo(miMovimiento)
        }else if miTarjeta.saldo == 100{
            let miMovimiento = Movimiento()
            miMovimiento.fechaMovimiento = NSDate()
            miMovimiento.valorMovimiento = -3.5
            managerModelo.actualizarSaldo(miMovimiento)
        }
        
        //labelSaldo.text = "\(miTarjeta.saldo)"
        //labelLastUpdate.text = "Actualizado hace \(managerModelo.getUltimoMovimiento())."
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeUp(sender: AnyObject) {
        cambiarPosicionTarjeta("Up")
        
    }
    
    @IBAction func swipeDown(sender: AnyObject) {
        cambiarPosicionTarjeta("Down")
    }
    
    func cambiarPosicionTarjeta(swipe: String) {
        self.view.layoutIfNeeded()
        
        if swipe == "Up"{
            UIView.animateWithDuration(0.5, animations: {
                //self.labelTituloTop.constant = -32
                //self.labelTitulo.alpha = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                //self.labelTituloTop.constant = +32
                //self.labelTitulo.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    @IBAction func cambiarSaldo(sender: UISegmentedControl) {
        
        // Creo animacion si "Registrar una carga" fue activado
        //        switch SegmentedController.selectedSegmentIndex {
        //
        //        case 0:
        //            cambiarPosicionTarjeta("Up")
        //            print("Registrar una carga")
        //        case 1:
        //            cambiarPosicionTarjeta("Up")
        //            print("Registrar un viaje")
        //        default:
        //            break
        //        }
        
    }
    
    
    @IBAction func setAmount(sender: UIButton) {
        
        let input: String = sender.titleLabel!.text!
        var preMonto: String = monto.text!
        
        switch input{
        case "Borrar":
            if preMonto.characters.count > 0 {
                preMonto.removeAtIndex(preMonto.endIndex.predecessor())
            }
        case ".":
            if preMonto.rangeOfString(".") == nil{
                preMonto = "\(preMonto)\(input)"
            }
        default:
            
            preMonto = "\(preMonto)\(input)"
            
        }
        
        monto.text = "\(preMonto)"
        
    }
    
    
    
}
