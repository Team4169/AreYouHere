//
//  AppState.swift
//  AreYouHere
//
//  Created by block7 on 5/27/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit

class AppState: NSObject {
    static let sharedInstance = AppState()
    
    var signedIn = false
    var name: String!
    var eid: String!
    var photoURL: NSURL!
    
}