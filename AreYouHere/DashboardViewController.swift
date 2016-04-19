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
    
    let rootRef = Firebase(url: "http://areyouhere.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
//        helloNameLabel.text = 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitSettings(sender: AnyObject) {
    }
    
    @IBAction func hitManageTeams(sender: AnyObject) {
    }

    @IBAction func hitAddTime(sender: AnyObject) {
    }
    
    @IBAction func hitStartMeeting(sender: AnyObject) {
    }
    
    @IBAction func hitViewRecords(sender: AnyObject) {
    }
    
    @IBAction func hitEditRecords(sender: AnyObject) {
    }
}
