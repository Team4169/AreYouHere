//
//  Variables.swift
//  AreYouHere
//
//  Created by block7 on 4/28/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import Foundation
import Firebase

let rootRef = FIRDatabase.database().reference()
var userRef: FIRDatabaseReference?

let uniqueNotificationKey = "com.github.thatnerdjack.AreYouHere"

extension String {
    
    func base64Encoded() -> String {
        let plainData = dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func base64Decoded() -> String {
        let decodedData = NSData(base64EncodedString: self, options:NSDataBase64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
        return String(decodedString!)
    }
}