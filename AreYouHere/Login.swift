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
    let rootRef = Firebase(url: "http://areyouhere.firebaseio.com")
    
    func createUser(email: String, password: String, name: String) {
        rootRef.createUser(email, password: password, withValueCompletionBlock: { error, result in
            if error != nil {
                print(error)
            } else {
                let uid = result["uid"] as? String
                print("Successfully created user account with uid: \(uid)")
                
                let newUserRef = self.rootRef.childByAppendingPath("users/\(uid)")
                let newUserData = ["name":name, "email":email]
                newUserRef.setValue(newUserData)
            }
        })
    }
    
    func loginUser(email: String, password: String) {
        rootRef.authUser(email, password: password, withCompletionBlock: { error, authData in
            if error != nil {
                print(error)
            } else {
                let uid = authData.uid
                print("Successfully logged in user with uid: \(uid)")
            }
        })
    }
}