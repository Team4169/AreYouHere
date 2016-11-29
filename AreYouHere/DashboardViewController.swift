//
//  DashboardViewController.swift
//  AreYouHere
//
//  Created by block7 on 4/12/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var helloNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppState.sharedInstance.name == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.setup), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.success"), object: nil)
        }
        else {
            self.helloNameLabel.text = "Hello, \(AppState.sharedInstance.name!)!"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.helloNameLabel.text = "Hello, \(AppState.sharedInstance.name!)!"
    }
}
