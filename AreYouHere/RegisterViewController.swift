//
//  RegisterViewController.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let login = Login()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotCreateError", name: "\(uniqueNotificationKey).Login.createUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotCreateSuccess", name: "\(uniqueNotificationKey).Login.createUser.success", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLoginError", name: "\(uniqueNotificationKey).Login.loginUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLoginSuccess", name: "\(uniqueNotificationKey).Login.loginUser.success", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //add those 2 (maybe 4?) methods in super
    
    @IBAction func hitGo(sender: AnyObject) {
        login.createUser(emailField.text!, password: passwordField.text!, name: nameField.text!)
        login.loginUser(emailField.text!, password: passwordField.text!)
        if rootRef.authData != nil {
            performSegueWithIdentifier("registerToDashboard", sender: nil)
        } else {
            let alert = UIAlertController(title: "Register Error", message: "Your account creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        //add observs here
    }
    
}
