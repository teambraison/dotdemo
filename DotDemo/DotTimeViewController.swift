//
//  DotTimeViewController.swift
//  Dot
//
//  Created by Titus Cheng on 11/28/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class DotTimeViewController: UIViewController, UIGestureRecognizerDelegate
{

    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    override func viewDidLoad() {
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "returnToPreviousScreen")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRight)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCurrentTime", userInfo: nil, repeats: true)
        
    }
    
    func updateCurrentTime()
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        var hourHandString = formatTime(hour)
        var minuteHandString = formatTime(minutes)
        if(hour > 12) {
            var theHour = hour - 12
            currentTimeLabel.text = "\(theHour):\(minuteHandString) p.m."
        } else {
            currentTimeLabel.text = "\(hourHandString):\(minuteHandString) a.m."
        }
    }
    
    func formatTime(myTime: Int) -> String {
        var timeString = "\(myTime)"
        if(myTime >= 0 && myTime <= 9) {
            timeString = "0\(myTime)"
        }
        return timeString
    }
    
    func returnToPreviousScreen() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
