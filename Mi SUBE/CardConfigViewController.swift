//
//  CardConfigViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 29/12/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class CardConfigViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func deleteCardData() {
        
        // set alertController
        let alertMessage = UIAlertController(title: "Cuidado", message: "Estas seguro que quieres eliminar todos los datos de tu tarjeta SUBE", preferredStyle: .Alert)
        
        // add delete Action
        alertMessage.addAction(UIAlertAction(title: "Continuar", style: .Default, handler: { Void in
            // remove all data from the DB
            let modelManager = TarjetaSUBEService()
            modelManager.removeTarjeta()
        }))
        // add cancel Action
        alertMessage.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        //show the alert
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
}
