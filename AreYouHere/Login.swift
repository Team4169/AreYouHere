//
//  Login.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct Login {
    
    static func createUser(_ email: String, password: String, name: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.createUser.error"), object: nil)
            } else {
                let eid = email.base64Encoded()
                print("Successfully created user account with eid: \(eid)")
                
                let newUserRef = rootRef.child("users/\(eid)")
                let newUserData = ["name":name, "email":email]
                newUserRef.setValue(newUserData)
                
                AppState.sharedInstance.name = name
                AppState.sharedInstance.eid = eid
                AppState.sharedInstance.signedIn = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.createUser.success"), object: nil)
            }
        })
    }
    
    static func loginUser(_ email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.error"), object: nil)
            } else {
                let eid = email.base64Encoded()
                
                userRef = rootRef.child("users/\(eid)")
                
                AppState.sharedInstance.name = user?.displayName
                print("\n\n\n\nNAME SET!!!!!\n\n\n\n")
                AppState.sharedInstance.eid = user?.email?.base64Encoded()
                AppState.sharedInstance.photoURL = user?.photoURL
                AppState.sharedInstance.signedIn = true
                    
                print("Successfully logged in user with eid: \(eid)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(uniqueNotificationKey).Login.loginUser.success"), object: nil)
                
                let defaults = UserDefaults.standard
                defaults.set(email, forKey: "Email")
                defaults.set(password, forKey: "Password")
            }
        })
    }
}
