//
//  ShopTableViewController.swift
//  Habits
//
//  Created by Emily Chin on 8/4/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import UIKit

class ShopTableViewController: UITableViewController {
    @IBOutlet var shopTableView: UITableView!

    @IBAction func unwindToShopTableViewController(_ segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = CoreDataHelper.retrieveGeneral()
        let general = list[0]
        
        if indexPath.row == 0 {
            general.points -= 15
            if general.points < 0 {
                let alert = UIAlertController(title: "", message: "Not enough points!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil) } ) )
                self.present(alert, animated: true, completion: nil)
                general.points += 15
            } else {
            general.rows += 1
            CoreDataHelper.saveGeneral()
            }
        }
        if indexPath.row == 1 {
            general.points -= 35
            if general.points < 0 {
                let alert = UIAlertController(title: "", message: "Not enough points!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil) } ) )
                self.present(alert, animated: true, completion: nil)
                general.points += 35
            } else {
            general.rows += 3
            CoreDataHelper.saveGeneral()
            }
        }
        if indexPath.row == 2 {
            general.points -= 60
            if general.points < 0 {
                let alert = UIAlertController(title: "", message: "Not enough points!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil) } ) )
                self.present(alert, animated: true, completion: nil)
                general.points += 60
            } else {
            general.rows += 5
            CoreDataHelper.saveGeneral()
            }
        }
        
        self.tableView.reloadData()
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
