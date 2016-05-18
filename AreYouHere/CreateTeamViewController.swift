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
        print("CREATE_TEAM_VC_LOAD")
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay!.backgroundColor = UIColor.whiteColor()
        overlay!.alpha = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTeamViewController.goToEditVC), name: "\(uniqueNotificationKey).CreateTeamVC.createTeam", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCreate(sender: AnyObject) {
        view.addSubview(overlay!)
        var goForCreate = false
        if (self.pickerSelection != nil) && (self.teamNameField.text! != "") && (self.teamNameField.text! != "") && !checkForExistingTeam(Int(self.teamNumField.text!)!) {
            print("go for create")
            goForCreate = true
        } else {
            overlay?.removeFromSuperview()
            let alert = UIAlertController(title: "Team Create Error", message: "Team creation has failed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        if goForCreate {
            createTeam(self.pickerSelection!, teamName: self.teamNameField.text!, teamNum: Int(self.teamNumField.text!)!)
        }
    }
    
    func checkForExistingTeam(teamNum: Int) -> Bool {
        return false
    }
    
    func createTeam(program: String, teamName: String, teamNum: Int) {
        let programWriteRef = userRef?.childByAppendingPath("writeableTeams/\(pickerSelection)")!
        print("programWriteRef made")
        let teamsDirRef = rootRef.childByAppendingPath("teams")
        print("teamsDirRef made")
        programWriteRef!.observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("in snapshot")
            print(snapshot)
            if snapshot.exists() {
                print("if snapshot exists")
                programWriteRef?.updateChildValues([teamNum : teamName])
                print("write team to user existing snap")
            } else {
                programWriteRef?.setValue([teamNum : teamName])
                print("write team to user no snap")
            }
            teamsDirRef.updateChildValues([teamNum : teamName])
            print("add to teams dir")
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
