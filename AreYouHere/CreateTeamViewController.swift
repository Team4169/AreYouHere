//
//  CreateTeamViewController.swift
//  AreYouHere
//
//  Created by block7 on 5/9/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit

class CreateTeamViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var teamNumField: UITextField!
    @IBOutlet weak var teamNameField: UITextField!
    
    var pickerSelection: String?
    var overlay: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.whiteColor()
        overlay!.alpha = 0.8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCreate(sender: AnyObject) {
        view.addSubview(overlay!)
        if (self.pickerSelection != nil) && (self.teamNameField.text! != "") && (self.teamNumField.text! != "") {
            let ref = userRef?.childByAppendingPath("writeableTeams/\(pickerSelection)")
            ref!.observeSingleEventOfType(.Value, withBlock: { snapshot in
                var returningTeams = [Int : String]()
                if snapshot.exists() {
                    returningTeams = snapshot.value as! Dictionary
                    //START HERE. GET EXISTING TEAMS. THEN ADD NEW TEAM TO DICT. THEN PUSH. THAN DO SOMETHING WITH NS NOTIFY
                }
            })
        }
        
//        NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).CreateTeamVC.hitCreate._______________", object: nil)
    }

    @IBAction func segmentedIndexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.pickerSelection = "FRC";
        case 1:
            self.pickerSelection = "FTC";
        case 2:
            self.pickerSelection = "FLL";
        case 3:
            self.pickerSelection = "FLLJ";
        default:
            break;
        }
    }
}
