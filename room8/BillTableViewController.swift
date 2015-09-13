//
//  BillTableViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class BillTableViewController: UITableViewController {

    //---------------------------------
    // MARK: Global Variables
    //---------------------------------

    var apt : String?
    var bill : Bill?
    var billList : [Bill] = []
    
    //---------------------------------
    // MARK: Data Source
    //---------------------------------
    
    func billQuery() {
        
        let billQuery = PFQuery(className: "Bills")
        billQuery.whereKey("name", equalTo: apt!)
        let obj = billQuery.findObjects()!.first as! PFObject
        
        let bills = obj.objectForKey("bills") as! PFRelation
        let relationBill = bills.query()!
        
        let bList = relationBill.findObjects() as! [PFObject]
        
        for b in  bList {
            
            bill = Bill()
            bill!.billName = b.objectForKey("billNamed") as! String
            bill!.billAmount = b.objectForKey("billAmount") as! String
            bill!.roomatePaying = b.objectForKey("roomatePaying") as! String
            bill!.dueDate = b.objectForKey("dueDate") as! String
            
            self.billList.append(bill!)
        }
    }
    
    
    //---------------------------------
    // MARK: View functions
    //---------------------------------


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 38/255, green: 1/255, blue: 38/255, alpha: 1.0)
        billQuery()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //---------------------------------
    // MARK: Table View data source
    //---------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier("bills") as! BillTableViewCell
        
        var nameIndex = billList[indexPath.row]
        tableCell.billName.text = nameIndex.billName

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
