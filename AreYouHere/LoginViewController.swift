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
    var overlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.white
        overlay.alpha = 0.8
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.gotLoginError), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.error"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.gotLoginSuccess), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.success"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitLogin(_ sender: AnyObject) {
        view.addSubview(overlay)
        self.login.loginUser(emailField.text!, password: passwordField.text!)
    }
    
    func gotLoginError() {
        overlay.removeFromSuperview()
        let alert = UIAlertController(title: "Login Error", message: "Your login failed.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotLoginSuccess() {
        performSegue(withIdentifier: "loginToDashboard", sender: nil)
    }

    @IBAction func cheatLogin(_ sender: AnyObject) {
        view.addSubview(overlay)
        self.login.loginUser("jackjyro@gmail.com", password: "test4169")
    }
    
    @IBAction func cheatSignup(_ sender: AnyObject) {
        self.login.createUser("jackjyro@gmail.com", password: "test4169", name: "Jack Doherty")
    }
}
