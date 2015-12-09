//
//  SaldoViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 8/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import RealmSwift

class SaldoViewController: UIViewController {

    @IBOutlet weak var txtConTarjetas: UITextView!
    @IBOutlet weak var aliasTarjeta: UITextField!
    @IBOutlet weak var numeroTarjeta: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func agregarTarjeta() {
        
        var resultado:String = ""
        
        let miTarjeta = Tarjeta()
        miTarjeta.alias = aliasTarjeta.text!
        miTarjeta.numero = numeroTarjeta.text!
        
    
        let realm = try! Realm()
        // You only need to do this once (per thread)
        
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.add(miTarjeta)
        }
        
        let tarjetas = realm.objects(Tarjeta)
        
        for t in tarjetas{
             resultado = "\(resultado) \(t.numero)"
        }
        
        txtConTarjetas.text = resultado
    }

}
