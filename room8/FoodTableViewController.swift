//
//  FoodTableViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class FoodTableViewController: UITableViewController {
    
    //---------------------------------
    // MARK: Global Variables
    //---------------------------------

    var apt : String?
    var food : Food?
    var foodList : [Food] = []
    
    //---------------------------------
    // MARK: Data source
    //---------------------------------
    
    func foodQuery() {
        let foodQ = PFQuery(className: "Apartments")
        foodQ.whereKey("name", equalTo: apt!)
        let obj = foodQ.findObjects()!.first as! PFObject
        
        let foods = obj.objectForKey("food") as! PFRelation
        let relationF = foods.query()!
        
        let fList = relationF.findObjects() as! [PFObject]
        
        for f in fList {
            
            food = Food()
            food!.foodItem = f.objectForKey("foodItem") as! String
            food!.amount = f.objectForKey("amount") as! String
            food!.expiry = f.objectForKey("expiry") as! String
            
            self.foodList.append(food!)
        }
    }

    //---------------------------------
    // MARK: View functions
    //---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 38/255, green: 1/255, blue: 38/255, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //---------------------------------
    // MARK: Table view delegates
    //---------------------------------
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier("food") as! FoodTableViewCell

        
        var nameIndex = foodList[indexPath.row]
        tableCell.foodName.text = nameIndex.foodItem

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
