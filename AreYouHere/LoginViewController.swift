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
        if rootRef.authData != nil {
            performSegueWithIdentifier("loginToDashboard", sender: nil)
        } else {
            let alert = UIAlertController(title: "Login Error", message: "Your login failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func cheatLogin(sender: AnyObject) {
        self.login.loginUser("jackjyro@gmail.com", password: "test4169")
        performSegueWithIdentifier("loginToDashboard", sender: nil)
    }
    
    @IBAction func cheatSignup(sender: AnyObject) {
        self.login.createUser("jackjyro@gmail.com", password: "test4169", name: "Jack Doherty")
        performSegueWithIdentifier("loginToDashboard", sender: nil)
    }
}
