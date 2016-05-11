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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        print(userRef)
        userRef!.observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("got snap")
            if let name = snapshot.value.objectForKey("name") {
                print(name)
                self.helloNameLabel.text = "Hello, \(name)!"
            } else {
                self.helloNameLabel.text = "ERROR"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
