//
//  ManageTeamsViewController.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ManageTeamsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var editTeamsButton: UIButton!
    
    var pickerSelection: String = ""
    
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ManageTeamsViewController.loadPicker), name: "\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.pickerSelection = ""
            editTeamsButton.enabled = false
        } else {
            self.pickerSelection = pickerData[row]
            editTeamsButton.enabled = true
        }
    }
    
    @IBAction func hitCreate(sender: AnyObject) {
        
    }
    
    @IBAction func hitEdit(sender: AnyObject) {
        
    }
    
    func getWriteableTeams(program: String) {
        var swiftArray: [String] = [String]()
        userRef!.childByAppendingPath("writeableTeams").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                if let writeableTeams = snapshot.value.objectForKey(program) {
                    let teamsData: NSArray = writeableTeams as! NSArray
                    print(teamsData)
                    for items in teamsData {
                        swiftArray.append(String(items))
                    }
                    print(swiftArray)
                    swiftArray.sortInPlace()
                    swiftArray.insert("Select a team", atIndex: 0)
                    print(swiftArray)
                }
            } else {
                swiftArray.append("No availible teams")
            }
            self.pickerData = swiftArray
            NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).ManageTeamsVC.getWriteableTeams", object: nil)
        })
    }
    
    func loadPicker() {
        self.picker.reloadAllComponents()
    }

    @IBAction func segmentedIndexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                getWriteableTeams("frc");
            case 1:
                getWriteableTeams("ftc");
            case 2:
                getWriteableTeams("fll");
            case 3:
                getWriteableTeams("fllj");
            default:
                break;
        }
    }
    
}
