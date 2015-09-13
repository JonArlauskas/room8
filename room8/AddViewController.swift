//
//  AddTaskController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import Parse

class AddViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    //---------------------------------
    // MARK: IBOutlets
    //---------------------------------
    
    @IBOutlet var actionPicker: UIPickerView!
    
    @IBOutlet var fieldOne: UITextField!

    @IBOutlet var fieldTwo: UITextField!
    
    @IBOutlet var fieldThree: UITextField!
    
    @IBOutlet var fieldFour: UITextField!
    
    @IBOutlet var labelOne: UILabel!
    
    @IBOutlet var labelTwo: UILabel!
    
    @IBOutlet var labelThree: UILabel!
    
    @IBOutlet var labelFour: UILabel!
    
    
    
    //---------------------------------
    // MARK: Global Variables
    //---------------------------------
    
    let pickerData = [ "Inventory", "Bills", "Food", "Tasks"]
    var currentSelection : String = "Inventory"

    //---------------------------------
    // MARK: Actions
    //---------------------------------
    
    func loadLabels(pickerName: String){
        
        switch pickerName {
            
        case "Inventory":
            self.labelOne.text = "Item Name"
            self.labelTwo.text = "Expiry Date"
            self.labelThree.text = "Buyer"
            self.fieldFour.hidden = true
            self.labelFour.hidden = true
            currentSelection = "Inventory"
  
        case "Bills":
            self.labelOne.text = "Bill Name"
            self.labelTwo.text = "Due Date"
            self.labelThree.text = "Bill Amount"
            self.labelFour.text = "Roomate to Pay"
            self.fieldFour.hidden = false
            self.labelFour.hidden = false
            currentSelection = "Bills"

        case "Food":
            self.labelOne.text = "Food Item"
            self.labelTwo.text = "Expiry Date"
            self.labelThree.text = "Amount"
            self.fieldFour.hidden = true
            self.labelFour.hidden = true
            currentSelection = "Food"

        case "Tasks":
            self.labelOne.text = "Task Name"
            self.labelTwo.text = "Roomate Responsible"
            self.labelThree.text = "Deadline"
            self.fieldFour.hidden = true
            self.labelFour.hidden = true
            currentSelection = "Tasks"

        default:
            return
        }
    }
    
    
    @IBAction func addAction(sender: AnyObject) {
        
        let query = PFQuery(className: "Apartments")
        query.limit = 1

        var obj = query.findObjects()!.first as! PFObject
        
        switch currentSelection {
            
        case "Inventory":
            var relation = obj.relationForKey("tasks")
            var object = PFObject(className: "Tasks")
            object.setObject(labelTwo.text!, forKey: "username")
            object.setObject(labelOne.text!, forKey: "taskName")
            relation.addObject(object)
            
        case "Bills":
            var relation = obj.relationForKey("tasks")
            var object = PFObject(className: "Tasks")
            object.setObject(labelTwo.text!, forKey: "username")
            object.setObject(labelOne.text!, forKey: "taskName")
            relation.addObject(object)
            
        case "Food":
            var relation = obj.relationForKey("tasks")
            var object = PFObject(className: "Tasks")
            object.setObject(labelTwo.text!, forKey: "username")
            object.setObject(labelOne.text!, forKey: "taskName")
            relation.addObject(object)
            
        case "Tasks":
           
            var object = PFObject(className: "Tasks")
            object.setObject(fieldOne.text!, forKey: "taskName")
            object.setObject(fieldTwo.text!, forKey: "username")
            object.saveInBackground()
            
            var relation = obj.relationForKey("tasks")
            relation.addObject(object)
            obj.saveInBackground()

        default:
            return
        }
    }
    
    
//    func selfAssign() {
//        
//        let query = PFQuery(className: "Apartments")
//        query.limit = 1
//        query.selectKeys(["tasks"])
//        var obj = query.findObjects()!.first as! PFObject
//        var relation = obj.relationForKey("tasks")
//        
//        var object = PFObject(className: "Tasks")
//        object.setObject(PFUser.currentUser()!.username!, forKey: "username")
//        object.setObject(taskName.text, forKey: "taskName")
//        
//        relation.addObject(object)
//  
//    }
    
    //---------------------------------
    // MARK: View delegates
    //---------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        actionPicker.delegate = self
        actionPicker.dataSource = self
        
        loadLabels("Inventory")
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //---------------------------------
    // MARK: Picker Wheel delegate methods
    //---------------------------------

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadLabels(pickerData[row])
    }

    
}
