//
//  ManageTeamsViewController.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase

class ManageTeamsViewController: UIViewController {
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRef = Variables.userRef!
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if let writeableTeams = snapshot.value.objectForKey("writeableTeams") {
                self.pickerData = writeableTeams as! [String]
                //NOTE: You changed the file structure so now teams are lists under UID/PROGRAM/teamNumber
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCreate(sender: AnyObject) {
        
    }
    
    @IBAction func hitEdit(sender: AnyObject) {
        
    }
}
