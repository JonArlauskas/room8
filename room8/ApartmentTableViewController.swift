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
    var timer = NSTimer()

    //---------------------------------
    // MARK: Actions
    //---------------------------------
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        timer.invalidate()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
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
                    residents.addObject(PFUser.currentUser()!)
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
    
    @IBAction func addToApt(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Add a Roomate", message: "Type in username (Case sensitive!)", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })


        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            
            let invite = PFObject(className: "Invitations")
            invite.setObject(textField.text, forKey: "username")
            invite.setObject(PFUser.currentUser()!.username!, forKey: "inviter")
            invite.setObject(self.aptNames.first!, forKey: "apartment")
            invite.saveInBackground()
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkForInvite"), userInfo: nil, repeats: true)
    }
    
    //---------------------------------
    // MARK: Actions
    //---------------------------------
    
    func checkForInvite() {
        
        let query = PFQuery(className: "Invitations")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if objects!.count > 0{
                    var sender = objects!.first?.objectForKey("inviter") as! String
                    var apartment = objects!.first?.objectForKey("apartment") as! String
                    
                    
                    var alert = UIAlertController(title: "You have a message", message: "\(sender) wants you to join \(apartment)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                        (action) -> Void in
                        
                        let currentUser = PFUser.currentUser()
                        currentUser?.addUniqueObject(apartment, forKey: "aptList")
                        currentUser!.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                                // Add apartment object to the apartments class, with relations
                                let aptAdd = PFObject(className: "Apartments")
                                
                                let residents = aptAdd.relationForKey("residents")
                                residents.addObject(PFUser.currentUser()!)
                                aptAdd.relationForKey("inventory")
                                aptAdd.relationForKey("bills")
                                aptAdd.relationForKey("tasks")
                                aptAdd.relationForKey("food")
                                aptAdd.setObject(apartment, forKey: "name")
                                
                                
                                // Set the read and write permissions
                                let aptACL = PFACL(user: PFUser.currentUser()!)
                                aptACL.setPublicReadAccess(true)
                                aptACL.setPublicWriteAccess(true)
                                aptAdd.ACL = aptACL
                                aptAdd.saveInBackground()
                                
                                // Remove the invitation
                                objects!.first?.deleteInBackground()
                                
                            } else {
                                println(error)
                            }
                        }
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Decline", style: .Destructive, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    self.timer.invalidate()
                }
            } else {
                println(error)
            }
        }
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
            let nav0 = tabBar.viewControllers!.first as! UINavigationController
            let nav1 = tabBar.viewControllers![1] as! UINavigationController
            let nav2 = tabBar.viewControllers![2] as! UINavigationController
            let nav3 = tabBar.viewControllers![3] as! UINavigationController
            let nav4 = tabBar.viewControllers![4] as! UINavigationController

            
            let moveVC0 = nav0.topViewController as! InventoryTableViewController
            let moveVC1 = nav1.topViewController as! BillTableViewController
            let moveVC2 = nav2.topViewController as! FoodTableViewController
            let moveVC3 = nav3.topViewController as! TaskTableViewController
            let moveVC4 = nav4.topViewController as! AddViewController
            
            if let selectedPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                moveVC0.apt = aptNames[selectedPath.row]
                moveVC1.apt = aptNames[selectedPath.row]
                moveVC2.apt = aptNames[selectedPath.row]
                moveVC3.apt = aptNames[selectedPath.row]
                moveVC4.apt = aptNames[selectedPath.row]
            }
        }
    }
}
