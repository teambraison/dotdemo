//
//  Contact.swift
//  Dot
//
//  Created by Titus Cheng on 11/14/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation

class Contact
{
    var username: String!
    var userid: String!
    init(name: String, id: String) {
        username = name
        userid = id
    }
    
    func name() -> String {
        return username
    }
    
    func id() -> String {
        return userid
    }
}
