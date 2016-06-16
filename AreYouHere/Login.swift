//
//  Login.swift
//  AreYouHere
//
//  Created by Jack Doherty on 4/18/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import Foundation
import Firebase

class Login : NSObject {
    
    func createUser(email: String, password: String, name: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.createUser.error", object: nil)
            } else {
                let eid = email.base64Encoded()
                print("Successfully created user account with eid: \(eid)")
                
                let newUserRef = rootRef.child("users/\(eid)")
                let newUserData = ["name":name, "email":email]
                newUserRef.setValue(newUserData)
                
                AppState.sharedInstance.name = name
                AppState.sharedInstance.eid = eid
                AppState.sharedInstance.signedIn = true
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.createUser.success", object: nil)
            }
        })
    }
    
    func loginUser(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.loginUser.error", object: nil)
            } else {
                let eid = email.base64Encoded()
                
                userRef = rootRef.child("users/\(eid)")
                
                AppState.sharedInstance.name = user?.displayName
                AppState.sharedInstance.eid = user?.email?.base64Encoded()
                AppState.sharedInstance.photoURL = user?.photoURL
                AppState.sharedInstance.signedIn = true
                    
                print("Successfully logged in user with eid: \(eid)")
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.loginUser.success", object: nil)
            }
        })
    }
}