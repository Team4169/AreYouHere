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
        overlay!.backgroundColor = UIColor.white
        overlay!.alpha = 0.8
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.gotCreateError), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.createUser.error"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.gotCreateSuccess), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.createUser.success"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.gotLoginError), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.error"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.gotLoginSuccess), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.success"), object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotCreateError() {
        overlay?.removeFromSuperview()
        let alert = UIAlertController(title: "Register Error", message: "Account creation failed.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        passwordField.text = ""
        confirmPasswordField.text = ""
    }
    
    func gotCreateSuccess() {
        login.loginUser(emailField.text!, password: passwordField.text!)
    }
    
    func gotLoginError() {
        performSegue(withIdentifier: "registerToLogin", sender: nil)
    }
    
    func gotLoginSuccess() {
        performSegue(withIdentifier: "registerToDashboard", sender: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    @IBAction func hitGo(_ sender: AnyObject) {
        view.addSubview(overlay!)
        if passwordField.text! == confirmPasswordField.text! {
            login.createUser(emailField.text!, password: passwordField.text!, name: nameField.text!)
        } else {
            overlay?.removeFromSuperview()
            let alert = UIAlertController(title: "Register Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            passwordField.text = ""
            confirmPasswordField.text = ""
        }
    }
    
}
