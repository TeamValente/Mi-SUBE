//
//  ConfigTableViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 12/17/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit
import Crashlytics

class ConfigTableViewController: UITableViewController {

    
    // MARK: Outlets
    @IBOutlet weak var switchDelete: UISwitch!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: View Events
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        switchDelete.setOn(true, animated: true)
        
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "v\(versionNumber)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // MARK: Actions
    @IBAction func deleteCard(_ sender: AnyObject) {
        
        // set alertController
        let alertMessage = UIAlertController(title: "Cuidado", message: "Seguro que quieres eliminar todos los datos de tu tarjeta SUBE", preferredStyle: .alert)
        
        // add delete Action
        alertMessage.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { Void in
            // remove all data from the DB
            let modelManager = TarjetaSUBEService()
            modelManager.removeTarjeta()
            Answers.logCustomEvent(withName: "Remove Card", customAttributes: ["Removio": "SI"])
        }))
        
        // add cancel Action
        alertMessage.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { Void in
            // set switch on
             self.switchDelete.setOn(true, animated: true)
            Answers.logCustomEvent(withName: "Remove Card", customAttributes: ["Removio": "NO"])

        }))
        
        //show the alert
        self.present(alertMessage, animated: true, completion: nil)    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            let APP_ID = 1076019287
            rateApp(APP_ID)
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func rateApp(_ APP_ID: Int) {
        let url = URL(string: "itms-apps://itunes.apple.com/app/id\(APP_ID)")!
        UIApplication.shared.openURL(url)
    }
    
}
