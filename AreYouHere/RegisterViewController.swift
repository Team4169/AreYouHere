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
    var overlay: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.whiteColor()
        overlay!.alpha = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotCreateError", name: "\(uniqueNotificationKey).Login.createUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotCreateSuccess", name: "\(uniqueNotificationKey).Login.createUser.success", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLoginError", name: "\(uniqueNotificationKey).Login.loginUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLoginSuccess", name: "\(uniqueNotificationKey).Login.loginUser.success", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotCreateError() {
        overlay?.removeFromSuperview()
        let alert = UIAlertController(title: "Register Error", message: "Account creation failed.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func gotCreateSuccess() {
        login.loginUser(emailField.text!, password: passwordField.text!)
    }
    
    func gotLoginError() {
        performSegueWithIdentifier("registerToLogin", sender: nil)
    }
    
    func gotLoginSuccess() {
        performSegueWithIdentifier("registerToDashboard", sender: nil)
    }
    
    
    
    @IBAction func hitGo(sender: AnyObject) {
        view.addSubview(overlay!)
        login.createUser(emailField.text!, password: passwordField.text!, name: nameField.text!)
    }
    
}
