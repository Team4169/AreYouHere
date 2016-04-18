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
    
    var name: String!
    
    let rootRef = Firebase(url: "http://areyouhere.firebaseio.com")
    let usersRef = Firebase(url: "http://areyouhere.firebaseio.com/users")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitLogin(sender: AnyObject) {
        Login.loginUser(emailField.text!, password: passwordField.text!)
        if self.rootRef.authData != nil {
            performSegueWithIdentifier("loginToDashboard", sender: nil)
        } else {
            let alert = UIAlertController(title: "Login Error", message: "Your login failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
