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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        switchDelete.setOn(true, animated: true)
        
        if let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "v\(versionNumber)"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // MARK: Actions
    @IBAction func deleteCard(sender: AnyObject) {
        
        // set alertController
        let alertMessage = UIAlertController(title: "Cuidado", message: "Seguro que quieres eliminar todos los datos de tu tarjeta SUBE", preferredStyle: .Alert)
        
        // add delete Action
        alertMessage.addAction(UIAlertAction(title: "Continuar", style: .Default, handler: { Void in
            // remove all data from the DB
            let modelManager = TarjetaSUBEService()
            modelManager.removeTarjeta()
            Answers.logCustomEventWithName("Remove Card", customAttributes: ["Removio": "SI"])
        }))
        
        // add cancel Action
        alertMessage.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: { Void in
            // set switch on
             self.switchDelete.setOn(true, animated: true)
            Answers.logCustomEventWithName("Remove Card", customAttributes: ["Removio": "NO"])

        }))
        
        //show the alert
        self.presentViewController(alertMessage, animated: true, completion: nil)    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 {
            let APP_ID = 1076019287
            rateApp(APP_ID)
        }
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func rateApp(APP_ID: Int) {
        let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(APP_ID)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
}
