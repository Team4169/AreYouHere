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
    
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        let userRef = Variables.userRef!
        userRef.childByAppendingPath("writeableTeams").observeEventType(.Value, withBlock: { snapshot in
            if let writeableTeams = snapshot.value.objectForKey("frc") {
                let teamsData: NSArray = writeableTeams as! NSArray
                let swiftArray = teamsData.flatMap({ $0 as? String })
                self.pickerData = swiftArray
            }
        }) //move this method to dashboard under prepare for segue
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
    
    @IBAction func hitCreate(sender: AnyObject) {
        
    }
    
    @IBAction func hitEdit(sender: AnyObject) {
        
    }

    @IBAction func segmentedIndexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                print("0");
            case 1:
                print("1");
            case 2:
                print("2");
            case 3:
                print("3")
            default:
                break;
        }
    }
    
}
