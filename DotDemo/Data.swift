//
//  Data.swift
//  Dot
//
//  Created by Titus Cheng on 11/4/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class Data
{
    let enlargedSizeMultiple = 1.2
    let defaultTextSize = 35
    
    class func defaultFontFamily() -> String {
        return "Helvetica Neue"
    }
    
    class func defaultFontSize() -> CGFloat {
        return 40
    }
    
    class func enlargedFactor() -> CGFloat {
        return 1.2
    }
    
    class func enlargeSizeFactor(originalSize: CGFloat) -> CGFloat {
        return originalSize * enlargedFactor()
    }
    
    class func returnFontSizeToDefault(enlargedSize: CGFloat) -> CGFloat {
        return enlargedSize / enlargedFactor()
    }
    
    class func menuNames() -> [String] {
        return ["Bus", "Messaging", "Time", "Watch"]
    }
    
    class func menuDestinationIDS() -> [String] {
        return ["businfo", "contacts", "timeinfo", "watchlist"]
    }
    
    class func menuItemNibName() -> String {
        return "MenuItem"
    }
    
    class func menuItemNibID() -> String {
        return "menuitem"
    }
    
    class func menuItemHeight() -> CGFloat {
        return 90.0
    }
    
    class func keyboardViewControllerID() -> String {
        return "keyboard"
    }
    
    class func contactNames() -> [String] {
        return ["Eric Kim", "Mason Joo", "Jason Lee", "Kikwang Sung"]
    }
    
    class func contactMessages() -> [String] {
        return ["야 오디야", "아이퐁 식스", "뭐해", "그럼"]
    }
    
    class func contactItemNibName() -> String {
        return "ContactItem"
    }
    
    class func contactItemNibID() -> String {
        return "contactitem"
    }
    
    class func contactItemHeight() -> CGFloat {
        return 92.0
    }
    
    class func loginNames() -> [String] {
        return ["Username", "Password", "Logged in as "]
    }
    
    class func loginItemNibName() -> String {
        return "LoginItem"
    }
    
    class func loginItemNibID() ->String {
        return "loginitem"
    }
    
    class func loginControllerID() -> String {
        return "login"
    }
    
    class func loginItemHeight() -> CGFloat {
        return 100.0
    }
    
    class func messageViewControllerID() -> String {
        return "messageview"
    }
    
    class func dotDialogBoxNibName() -> String {
        return "DotDialogBox"
    }
    
    class func dotDialogBoxNibID() -> String {
        return "dialogbox"
    }
    
    class func messageKey() -> String {
        return "privatemessage"
    }
    
    class func stagingURL() -> String {
        return "http://teambraison-dot.jit.su"
    }
    
    class func developmentURL() ->String {
        return "http://localhost:3000"
    }
    
    class func URL() -> String {
        //return developmentURL()
        return stagingURL()
    }
    
    
    
    class func time() -> String
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        var hourString: String
        var minuteString: String
        var setting: String
        
        if(components.hour > 12) {
            hourString = String(components.hour - 12)
            setting = " p.m"
        } else {
            hourString = String(components.hour)
            setting = " a.m"
        }
        if (components.minute >= 0 && components.minute <= 9) {
            minuteString = "0" + String(components.minute)
        } else {
            minuteString = String(components.minute)
        }
        return "  " + hourString + ":" + minuteString + setting
        
    }
}
