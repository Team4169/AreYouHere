//
//  LoginViewController.swift
//  AreYouHere
//
//  Created by block7 on 4/12/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let login = Login()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitLogin(sender: AnyObject) {
        self.login.loginUser(emailField.text!, password: passwordField.text!)
        if login.rootRef.authData != nil {
            performSegueWithIdentifier("loginToDashboard", sender: nil)
        } else {
            let alert = UIAlertController(title: "Login Error", message: "Your login failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
