//
//  Variables.swift
//  AreYouHere
//
//  Created by block7 on 4/28/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let rootRef = FIRDatabase.database().reference()
var userRef: FIRDatabaseReference?

let uniqueNotificationKey = "com.github.thatnerdjack.AreYouHere"

extension String {
    
    func base64Encoded() -> String {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func base64Decoded() -> String {
        let decodedData = Data(base64Encoded: self, options:NSData.Base64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
        return String(decodedString!)
    }
}
