//
//  CreateTeamViewController.swift
//  AreYouHere
//
//  Created by block7 on 5/9/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

//Currently trying to: 1. Get name of current/main admin (first in list) and 2. Flesh out teams dir

import UIKit

class CreateTeamViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var teamNumField: UITextField!
    @IBOutlet weak var teamNameField: UITextField!
    
    var pickerSelection: String?
    var overlay: UIView?

    override func viewDidLoad() {
        print("CREATE_TEAM_VC_LOAD")
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.whiteColor()
        overlay!.alpha = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTeamViewController.goToEditVC), name: "\(uniqueNotificationKey).CreateTeamVC.createTeam", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTeamViewController.noGoForCreate), name: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.taken", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTeamViewController.goForCreate), name: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.free", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCreate(sender: AnyObject) {
        view.addSubview(overlay!)
        if (self.pickerSelection != nil) && (self.teamNameField.text! != "") && (self.teamNameField.text! != "") {
            checkForExistingTeam(self.teamNumField.text!)
        } else {
            overlay?.removeFromSuperview()
            let alert = UIAlertController(title: "Team Create Error", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func checkForExistingTeam(teamNum: String) {
        let teamsDirRef = rootRef.child(self.pickerSelection!)
        teamsDirRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value![teamNum] as? String {
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.taken", object: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.free", object: nil)
            }
        })
    }
    
    func noGoForCreate() {
        overlay?.removeFromSuperview()
        let alert = UIAlertController(title: "Team Create Error", message: "Team is already administred by __________", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goForCreate() {
        createTeam(self.pickerSelection!, teamName: self.teamNameField.text!, teamNum: self.teamNumField.text!)
    }
    
    func createTeam(program: String, teamName: String, teamNum: String) {
        let programWriteRef = userRef?.child("writeableTeams/\(pickerSelection!)")
        let teamsDirRef = rootRef.child("teams/\(pickerSelection!)")
        programWriteRef!.observeSingleEventOfType(.Value, withBlock: { snapshot in
            programWriteRef!.updateChildValues([teamNum : teamName])
            teamsDirRef.updateChildValues([teamNum : ["admin" : "email"]])
            //CODE ABOVE IS NOT TESTED AND NEEDS WORK
            //MAYBE: make teams dir a full on directory that lists the admins and other things
            NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).CreateTeamVC.createTeam", object: nil)
        })
    }
    
    func goToEditVC() {
        performSegueWithIdentifier("createTeamToEditTeam", sender: nil)
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
