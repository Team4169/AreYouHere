//
//  CreateTeamViewController.swift
//  AreYouHere
//
//  Created by block7 on 5/9/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

//Currently trying to: 1. Get name of current/main admin (first in list) and 2. Flesh out teams dir
//fetch name from app state and add to createTeam's teamData dictionary structure as well as existing team error

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateTeamViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var teamNumField: UITextField!
    @IBOutlet weak var teamNameField: UITextField!
    
    var pickerSelection: String?
    var overlay: UIView!

    override func viewDidLoad() {
        print("CREATE_TEAM_VC_LOAD")
        super.viewDidLoad()
        
        overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.white
        overlay.alpha = 0.8
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTeamViewController.noGoForCreate), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.taken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTeamViewController.goForCreate), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.free"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitCreate(_ sender: AnyObject) {
        view.addSubview(overlay)
        if (self.pickerSelection != nil) && (self.teamNameField.text! != "") && (self.teamNameField.text! != "") {
            checkForExistingTeam(self.teamNumField.text!)
        } else {
            overlay.removeFromSuperview()
            let alert = UIAlertController(title: "Team Create Error", message: "All fields are required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkForExistingTeam(_ teamNum: String) {
        let teamsDirRef = rootRef.child(self.pickerSelection!)
        teamsDirRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            if let _ = (snapshot.value! as! NSDictionary)[teamNum] as? String {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.taken"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).CreateTeamVC.checkForExistingTeam.free"), object: nil)
            }
        })
    }
    
    func noGoForCreate() {
        overlay.removeFromSuperview()
        let alert = UIAlertController(title: "Team Create Error", message: "Team is already administred.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goForCreate() {
        createTeam(self.pickerSelection!, teamName: self.teamNameField.text!, teamNum: self.teamNumField.text!)
    }
    
    func createTeam(_ program: String, teamName: String, teamNum: String) {
        let programWriteRef = userRef?.child("writeableTeams/\(pickerSelection!)")
        let teamsDirRef = rootRef.child("teams/\(pickerSelection!)/\(teamNum)")
        let teamData = [
            "nickname" : teamName,
            "admins" : [AppState.sharedInstance.eid! : AppState.sharedInstance.name!],
            "teamMembers" : [AppState.sharedInstance.eid! : AppState.sharedInstance.name!]
        ] as [String : Any]
        
        programWriteRef?.updateChildValues([teamNum : teamName])
        teamsDirRef.updateChildValues(teamData as [AnyHashable: Any])
        
        performSegue(withIdentifier: "createTeamToEditTeam", sender: nil)
    }

    @IBAction func segmentedIndexChanged(_ sender: AnyObject) {
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
