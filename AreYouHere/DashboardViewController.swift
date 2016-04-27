//
//  DashboardViewController.swift
//  AreYouHere
//
//  Created by block7 on 4/12/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class DashboardViewController: UIViewController {
    @IBOutlet weak var helloNameLabel: UILabel!
    
    let rootRef = Firebase(url: "http://areyouhere.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        let userRef = self.rootRef.childByAppendingPath("users/\(rootRef.authData.uid)")
        print(userRef)
        userRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            print(snapshot.value)
//            print("got snap")
//            let name = snapshot.value.objectForKey("name")
//            print(name)
//            self.helloNameLabel.text = "Hello, \(name)!"
        })
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
