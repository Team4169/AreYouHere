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
        rootRef.createUser(email, password: password, withValueCompletionBlock: { error, result in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.createUser.error", object: nil)
            } else {
                let eid = email.base64Encoded()
                print("Successfully created user account with eid: \(eid)")
                
                let newUserRef = rootRef.childByAppendingPath("users/\(eid)")
                let newUserData = ["name":name, "email":email]
                newUserRef.setValue(newUserData)
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.createUser.success", object: nil)
            }
        })
    }
    
    func loginUser(email: String, password: String) {
        rootRef.authUser(email, password: password, withCompletionBlock: { error, authData in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.loginUser.error", object: nil)
            } else {
                let eid = email.base64Encoded()
                userRef = rootRef.childByAppendingPath("users/\(eid)")
                print("Successfully logged in user with eid: \(eid)")
                NSNotificationCenter.defaultCenter().postNotificationName("\(uniqueNotificationKey).Login.loginUser.success", object: nil)
            }
        })
    }
}