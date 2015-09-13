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
    var apt : String?

    //---------------------------------
    // MARK: Actions
    //---------------------------------
    
    func loadLabels(pickerName: String){
        
        switch pickerName {
            
        case "Inventory":
            self.labelOne.text = "Item Name"
            self.labelTwo.text = "Buyer"
            self.labelThree.text = "Amount"
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

        switch currentSelection {
            
        case "Inventory":
            var object = PFObject(className: "Inventory")
            object.setObject(labelOne.text!, forKey: "name")
            object.setObject(labelTwo.text!, forKey: "buyer")
            object.setObject(labelThree.text!, forKey: "amount")
            object.saveInBackground()
            
            let query = PFQuery(className: "Apartments")
            query.limit = 1
            query.whereKey("name", equalTo: apt!)
            var obj = query.findObjects()!.first as! PFObject
            var relation = obj.relationForKey("inventory")
            relation.addObject(object)
            obj.saveInBackground()
            
            
        case "Bills":
            var object = PFObject(className: "Bills")
            object.setObject(labelOne.text!, forKey: "billNamed")
            object.setObject(labelTwo.text!, forKey: "dueDate")
            object.setObject(labelThree.text!, forKey: "billAmount")
            object.setObject(labelFour.text!, forKey: "roomatePaying")
            object.saveInBackground()
            
            let query = PFQuery(className: "Apartments")
            query.limit = 1
            query.whereKey("name", equalTo: apt!)
            var obj = query.findObjects()!.first as! PFObject
            var relation = obj.relationForKey("bills")
            relation.addObject(object)
            obj.saveInBackground()
            
        case "Food":
            var object = PFObject(className: "Food")
            object.setObject(labelOne.text!, forKey: "foodItem")
            object.setObject(labelTwo.text!, forKey: "expiry")
            object.setObject(labelThree.text!, forKey: "amount")
            object.saveInBackground()
            
            let query = PFQuery(className: "Apartments")
            query.limit = 1
            query.whereKey("name", equalTo: apt!)
            var obj = query.findObjects()!.first as! PFObject
            var relation = obj.relationForKey("food")
            relation.addObject(object)
            obj.saveInBackground()
            
        case "Tasks":
            var object = PFObject(className: "Tasks")
            object.setObject(fieldOne.text!, forKey: "taskName")
            object.setObject(fieldTwo.text!, forKey: "username")
            object.setObject(fieldThree.text!, forKey: "deadline")
            object.saveInBackground()
            
            
            let query = PFQuery(className: "Apartments")
            query.limit = 1
            query.whereKey("name", equalTo: apt!)
            var obj = query.findObjects()!.first as! PFObject
            var relation = obj.relationForKey("tasks")
            relation.addObject(object)
            obj.saveInBackground()
            

        default:
            return
        }
    }

    
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
