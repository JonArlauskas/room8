//
//  ApartmentTableViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class ApartmentTableViewController: UITableViewController {
    
    //---------------------------------
    // MARK: Global Variables
    //---------------------------------
    var aptNames : [String] = []


    //---------------------------------
    // MARK: Actions
    //---------------------------------
    
    @IBAction func add(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New apartment/residence", message: "Name your home:", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            
            // Update data source, reload
            let currentUser = PFUser.currentUser()
            currentUser?.addUniqueObject(textField.text, forKey: "aptList")
            currentUser!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    
                    // Add apartment object to the apartments class, with relations
                    let aptAdd = PFObject(className: "Apartments")
                    
                    let residents = aptAdd.relationForKey("residents")
                    aptAdd.relationForKey("inventory")
                    aptAdd.relationForKey("bills")
                    aptAdd.relationForKey("tasks")
                    aptAdd.relationForKey("food")
                    aptAdd.setObject(textField.text, forKey: "name")

                    
                    let aptACL = PFACL(user: PFUser.currentUser()!)
                    aptACL.setPublicReadAccess(true)
                    aptACL.setPublicWriteAccess(true)
                    aptAdd.ACL = aptACL
                    
                    aptAdd.saveInBackground()
                } else {
                    println(error)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //---------------------------------
    // MARK: View Methods
    //---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aptQuery()
    }

    //---------------------------------
    // MARK: Data Source
    //---------------------------------
    
    func aptQuery() {
        let queryUser = PFUser.query()
        queryUser?.limit = 1
        queryUser?.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        let obj = queryUser!.findObjects()?.first as! PFObject

        let tempNames = obj.objectForKey("aptList") as! [String]
        for names in tempNames {
            aptNames.append(names)
        }
    }
    //---------------------------------
    // MARK: Table view data source
    //---------------------------------
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return aptNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cell reuse idenifier
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier("apartment") as! ApartmentTableViewCell

        // Set the names in the table from the data source (aptNames)
        var nameIndex = aptNames[indexPath.row]
        tableCell.name.text = nameIndex
        
        return tableCell
    }
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    //---------------------------------
    // MARK: Navigation
    //---------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "toTabs" {
            
            let tabBar = segue.destinationViewController as! UITabBarController
            let nav = tabBar.viewControllers!.first as! UINavigationController
            let moveVC = nav.topViewController as! InventoryTableViewController
            
            if let selectedPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                moveVC.apt = aptNames[selectedPath.row]
            }
        }
    }
}
