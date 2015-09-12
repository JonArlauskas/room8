//
//  LoginViewController.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-12.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func loginSignUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            displayAlert("Error", message: "Please fill in both fields")
        } else {
            let userQuery = PFUser.query()
            userQuery?.limit = 1
            userQuery?.whereKey("username", equalTo: username.text!)
            userQuery?.findObjectsInBackgroundWithBlock{ (results:[AnyObject]?, error: NSError?) -> Void in
                if results!.count == 0 {
                    if error == nil {
                        
                        let user = PFUser()
                        
                        // Initialize variables for new user
                        user.username = self.username.text!
                        user.password = self.password.text!
                        
                        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                            if error == nil {
                                println("SIGNED UP")
                                self.performSegueWithIdentifier("loggedIn", sender: self)
                            } else {
                                println(error)
                            }
                        }
                    } else {
                        println(error)
                    }
                } else {
                    PFUser.logInWithUsernameInBackground(self.username.text, password: self.password.text) { (user, error) -> Void in
                        if error == nil {
                            println("LOGGED IN")
                            self.performSegueWithIdentifier("loggedIn", sender: self)
                        } else {
                            println(error)
                        }
                    }
                }
            }
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        PFUser.logOut()
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Two functions to allow off keyboard touch to close keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
