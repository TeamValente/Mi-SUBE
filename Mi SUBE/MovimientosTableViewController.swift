//
//  MovimientosTableViewController.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 12/1/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class MovimientosTableViewController: UITableViewController {

    //MARK: Variables
    var miTarjeta: Tarjeta!
    let managerModelo = TarjetaSUBEService()
    
    @IBOutlet var tablaMovimientos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.isNavigationBarHidden = false
        let managerModelo = TarjetaSUBEService()
        miTarjeta = managerModelo.getTarjeta()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
        
        tablaMovimientos.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return managerModelo.listadoDeMovimientos("desc").count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovimientoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovimientoTableViewCell

        let mov = managerModelo.listadoDeMovimientos("desc")[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .short
        
        cell.labelFecha.text = formatter.string(from: mov.fechaMovimiento)
        if mov.valorMovimiento > 0{
            cell.labelMonto.textColor = UIColor("#4CAF50")
            cell.imgOperation.image = UIImage(named: "ic_local_atm")
            cell.imgOperation.image = cell.imgOperation.image?.withRenderingMode(.alwaysTemplate)
            cell.imgOperation.tintColor = UIColor("#4CAF50")
        } else {
            cell.labelMonto.textColor = UIColor("#E8573C")
            cell.imgOperation.image = UIImage(named: "ic_directions_bus")
            cell.imgOperation.image = cell.imgOperation.image?.withRenderingMode(.alwaysTemplate)
            cell.imgOperation.tintColor = UIColor("#E8573C")
        }
        
        cell.labelMonto.text = String(format: "%.2f",mov.valorMovimiento)
        
        // Configure the cell...
        return cell
    }


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
