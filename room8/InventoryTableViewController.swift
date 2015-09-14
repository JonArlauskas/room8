//
//  InventoryTableViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class InventoryTableViewController: UITableViewController {

    //---------------------------------
    // MARK: Global Variables
    //---------------------------------
    
    var apt : String?
    private var inventory : Inventory?
    private var itemList : [Inventory] = []

    
    //---------------------------------
    // MARK: Data Source
    //---------------------------------
    
    func itemQuery() {
        
        let itemQ = PFQuery(className: "Apartments")
        itemQ.whereKey("name", equalTo: apt!)
        let obj = itemQ.findObjects()!.first as? PFObject
        
        if obj != nil {
        
            let items = obj!.objectForKey("inventory") as! PFRelation
            let relationI = items.query()!
            
            let iList = relationI.findObjects() as! [PFObject]
            
            for i in iList {
                
                inventory = Inventory()
                inventory?.buyer = i.objectForKey("buyer") as! String
                inventory?.item = i.objectForKey("name") as! String
                inventory?.amount = i.objectForKey("amount") as! String
                
                self.itemList.append(inventory!)
            }
        }
        
    }
    
    
    //---------------------------------
    // MARK: View functions
    //---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        itemQuery()
        self.tableView.backgroundColor = UIColor(red: 38/255, green: 1/255, blue: 38/255, alpha: 1.0)
    }
    
    
    //---------------------------------
    // MARK: Table view data sources
    //---------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return itemList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier("inventory") as! InventoryTableViewCell
        
        var nameIndex = itemList[indexPath.row]
        tableCell.itemName.text = nameIndex.item

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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
