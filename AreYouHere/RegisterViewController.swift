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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    }
    
}
