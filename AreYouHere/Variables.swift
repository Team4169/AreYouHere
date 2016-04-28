//
//  Variables.swift
//  AreYouHere
//
//  Created by block7 on 4/28/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import Foundation
import Firebase

struct Variables {
    static let rootRef = Firebase(url: "http://areyouhere.firebaseio.com")
    static var userRef: Firebase?
}