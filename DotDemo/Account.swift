//
//  Account.swift
//  Dot
//
//  Created by Titus Cheng on 11/12/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation

class Account:NSObject
{
    class var sharedInstance: Account {
        struct Static {
            static var instance: Account?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Account()
        }
        
        return Static.instance!
    }
    
    var session_id: String!
    var username: String!
    var password: String!
    var user_id: String!
    var isAuthenticated = false
    
}