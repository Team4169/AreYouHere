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
import FirebaseDatabase
import Foundation

class ManageTeamsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var editTeamsButton: UIButton!
    
    var teamNums: [String] = [String]()
    var pickerSelection: Int = -1
    var pickerData: [String] = [String]()
    var program: String!
    
    var overlay: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.white
        overlay.alpha = 0.8
        
        NotificationCenter.default.addObserver(self, selector: #selector(ManageTeamsViewController.loadPicker), name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageTeamsToEditTeams" {
            let DVC = segue.destination as! EditTeamTableViewController
            DVC.teamNum = self.pickerSelection
            DVC.program = self.program
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerData[row] == "Select a team" || pickerData[row] == "No availible teams") && pickerData.count > 0 {
            self.pickerSelection = -1
            editTeamsButton.isEnabled = false
        } else {
            self.pickerSelection = Int(teamNums[row - 1])!
            editTeamsButton.isEnabled = true
        }
    }
    
    func getWriteableTeams() {
        var displayArray: [String] = [String]()
        userRef!.child("writeableTeams").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            if snapshot.hasChild(self.program) {
                let writeableTeams = (snapshot.value! as! NSDictionary)
                let teamsData: [String : String] = writeableTeams as! [String : String]
                var teamNums: [String] = [String]()
                for (teamNum, _) in teamsData {
                    teamNums.append(teamNum)
                }
                teamNums.sort()
                self.teamNums = teamNums
                print(self.teamNums)
                for teams in teamNums {
                    displayArray.append("\(teamsData[teams]!) – \(teams)")
                }
                displayArray.insert("Select a team", at: 0)
                print(displayArray)
            } else if displayArray.isEmpty {
                displayArray.append("No availible teams")
            } else {
                displayArray.append("No availible teams")
            }
            self.pickerData = displayArray
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams"), object: nil)
        })
    }
    
    func loadPicker() {
        self.picker.reloadAllComponents()
    }

    @IBAction func segmentedIndexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                self.program = "FRC";
            case 1:
                self.program = "FTC";
            case 2:
                self.program = "FLL";
            case 3:
                self.program = "FLLJ";
            default:
                break;
        }
        getWriteableTeams()
    }
    
}
