//
//  ManageTeamsViewController.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

//FIX THIS
import UIKit
import Firebase
import Foundation

class ManageTeamsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var editTeamsButton: UIButton!
    
    var teamNums: [String] = [String]()
    var pickerSelection: Int = -1
    
    var pickerData: [String] = [String]()
    var overlay: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.whiteColor()
        overlay.alpha = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageTeamsViewController.loadPicker), name: "\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitEdit(sender: AnyObject) {
        view.addSubview(overlay)
        //load teamMembers data, then do NSNotify, then have another method that sends data to next VC and triggers segue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "manageTeamsToEditTeams" {
            let DVC = segue.destinationViewController as! EditTeamTableViewController
            DVC.teamNum = self.pickerSelection
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerData[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerData[row] == "Select a team" || pickerData[row] == "No availible teams") && pickerData.count > 0 {
            self.pickerSelection = -1
            editTeamsButton.enabled = false
        } else {
            self.pickerSelection = Int(teamNums[row - 1])!
            editTeamsButton.enabled = true
        }
    }
    
    func getWriteableTeams(program: String) {
        //THIS NEEDS TO BE FIXED
        var displayArray: [String] = [String]()
        userRef!.child("writeableTeams").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.hasChild(program) {
                if let writeableTeams = snapshot.value!.objectForKey(program) {
                    let teamsData: [String : String] = writeableTeams as! [String : String]
                    var teamNums: [String] = [String]()
                    for (teamNum, _) in teamsData {
                        teamNums.append(teamNum)
                    }
                    teamNums.sortInPlace()
                    self.teamNums = teamNums
                    print(self.teamNums)
                    for teams in teamNums {
                        displayArray.append("\(teamsData[teams]!) – \(teams)")
                    }
                    displayArray.insert("Select a team", atIndex: 0)
                    print(displayArray)
                }
            } else if displayArray.isEmpty {
                displayArray.append("No availible teams")
            } else {
                displayArray.append("No availible teams")
            }
            self.pickerData = displayArray
            NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams", object: nil)
        })
    }
    
    func loadPicker() {
        self.picker.reloadAllComponents()
    }

    @IBAction func segmentedIndexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                getWriteableTeams("FRC");
            case 1:
                getWriteableTeams("FTC");
            case 2:
                getWriteableTeams("FLL");
            case 3:
                getWriteableTeams("FLLJ");
            default:
                break;
        }
    }
    
}
