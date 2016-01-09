//
//  ConfigTableViewController.swift
//  Mi SUBE
//
//  Created by Mariano Molina on 12/17/15.
//  Copyright © 2015 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class ConfigTableViewController: UITableViewController {

    
    // MARK: Outlets
    @IBOutlet weak var switchDelete: UISwitch!
    
    
    // MARK: View Events
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(animated: Bool) {
         switchDelete.setOn(true, animated: true)
         UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // MARK: Actions
    @IBAction func deleteCard(sender: AnyObject) {
        
        // set alertController
        let alertMessage = UIAlertController(title: "Cuidado", message: "Estas seguro que quieres eliminar todos los datos de tu tarjeta SUBE", preferredStyle: .Alert)
        
        // add delete Action
        alertMessage.addAction(UIAlertAction(title: "Continuar", style: .Default, handler: { Void in
            // remove all data from the DB
            let modelManager = TarjetaSUBEService()
            modelManager.removeTarjeta()
        }))
        
        // add cancel Action
        alertMessage.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: { Void in
            // set switch on
             self.switchDelete.setOn(true, animated: true)
        }))
        
        //show the alert
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
       

    
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
