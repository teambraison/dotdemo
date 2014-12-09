//
//  KeyboardPlaceHolder.swift
//  Dot
//
//  Created by Titus Cheng on 11/12/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation

class KeyboardPlaceHolder:NSObject
{
    var store:NSMutableDictionary!
    class var sharedInstance: KeyboardPlaceHolder {
        struct Static {
            static var instance: KeyboardPlaceHolder?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = KeyboardPlaceHolder()
        }
        return Static.instance!
    }
    
}
