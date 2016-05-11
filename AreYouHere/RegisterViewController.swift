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
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let login = Login()
    var overlay: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.whiteColor()
        overlay!.alpha = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.gotCreateError), name: "\(uniqueNotificationKey).Login.createUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.gotCreateSuccess), name: "\(uniqueNotificationKey).Login.createUser.success", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.gotLoginError), name: "\(uniqueNotificationKey).Login.loginUser.error", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.gotLoginSuccess), name: "\(uniqueNotificationKey).Login.loginUser.success", object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        passwordField.text = ""
        confirmPasswordField.text = ""
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    @IBAction func hitGo(sender: AnyObject) {
        view.addSubview(overlay!)
        if passwordField.text! == confirmPasswordField.text! {
            login.createUser(emailField.text!, password: passwordField.text!, name: nameField.text!)
        } else {
            overlay?.removeFromSuperview()
            let alert = UIAlertController(title: "Register Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            passwordField.text = ""
            confirmPasswordField.text = ""
        }
    }
    
}
