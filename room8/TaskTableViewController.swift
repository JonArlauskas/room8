//
//  TaskTableViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class TaskTableViewController: UITableViewController {

    //---------------------------------
    // MARK: Global Variables
    //---------------------------------
    var apt : String?
    var task : Task?
    var taskList : [Task] = []

    //---------------------------------
    // MARK: Actions
    //---------------------------------

    func taskQuery() {
        
//        let queryUser = PFUser.query()
//        queryUser?.limit = 1
//        queryUser?.whereKey("username", equalTo: PFUser.currentUser()!.username!)
//        let obj = queryUser!.findObjects()?.first as! PFObject
//        
//        let tempNames = obj.objectForKey("aptList") as! [String]
//        for names in tempNames {
//            aptNames.append(names)
//        }
        
        
        let taskQ = PFQuery(className: "Apartments")
        taskQ.whereKey("name", equalTo: apt!)
        let obj = taskQ.findObjects()!.first as! PFObject
        
        let tasks = obj.objectForKey("tasks") as! PFRelation
        let relationQ = tasks.query()!
        
        let tList = relationQ.findObjects() as! [PFObject]
        
        for t in tList {
            
            let task = Task()
            task.job = t.objectForKey("taskName") as! String
            task.responsible = t.objectForKey("username") as! String
            task.deadline = t.objectForKey("deadline") as! String
            
            self.taskList.append(task)
        } 
    }
    
    //---------------------------------
    // MARK: View Functions
    //---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        self.navigationController?.navigationBarHidden = true
        taskQuery()
        dump(taskList)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //---------------------------------
    // MARK: Table view data source
    //---------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return taskList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell reuse idenifier
        let tableCell = self.tableView.dequeueReusableCellWithIdentifier("tasks") as! TaskTableViewCell
        
        var nameIndex = taskList[indexPath.row]
        tableCell.taskName.text = nameIndex.job

        return tableCell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
