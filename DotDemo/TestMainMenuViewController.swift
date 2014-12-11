//
//  TestMainMenuViewController.swift
//  DotDemo
//
//  Created by Titus Cheng on 12/9/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation

import UIKit

class TestMainMenuViewController:UIViewController
{
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var messagingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    var allViews:[UILabel]!
    var selectedView: UILabel!
    let DEFAULT_TEXT_SIZE:CGFloat = 45.0
    
    override func viewDidLoad() {
        allViews = []
        allViews.append(busLabel)
        allViews.append(messagingLabel)
        allViews.append(timeLabel)
        allViews.append(settingLabel)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var aTouch:UITouch =  touches.anyObject() as UITouch
        var point:CGPoint = aTouch.locationInView(self.view)
        for(var i = 0; i < allViews.count; i++) {
            let aView:UILabel = allViews[i]
            if(CGRectContainsPoint(aView.frame, point)) {
                selectedView = aView
                selectedView.font = UIFont(name: "Helvetica Neue", size: DEFAULT_TEXT_SIZE * 1.1)
            } else {
                aView.font = UIFont(name: "Helvetica Neue", size: DEFAULT_TEXT_SIZE)
            }
        }

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var aTouch:UITouch =  touches.anyObject() as UITouch
        var point:CGPoint = aTouch.locationInView(self.view)
        for(var i = 0; i < allViews.count; i++) {
            let aView:UILabel = allViews[i]
            if(CGRectContainsPoint(aView.frame, point)) {
                selectedView = aView
                selectedView.font = UIFont(name: "Helvetica Neue", size: DEFAULT_TEXT_SIZE * 1.2)
            } else {
                aView.font = UIFont(name: "Helvetica Neue", size: DEFAULT_TEXT_SIZE)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for(var i = 0; i < allViews.count; i++) {
            let aView:UILabel = allViews[i]
            aView.font = UIFont(name: "Helvetica Neue", size: DEFAULT_TEXT_SIZE)
        }
        transitToNextView(selectedView.text!)
    }
    
    func transitToNextView(nextView: String) {
        if(nextView == "버스") {
            
        } else if(nextView == "메시지") {
            let contactsVC:ContactsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contacts") as ContactsViewController
            self.navigationController?.pushViewController(contactsVC, animated: true)
            
        } else if(nextView == "설정") {
            let settingVC:SettingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("setting") as SettingViewController
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else if(nextView == "") {
            
        } else {
            
        }
        
    }
    
    
    
    
    
}
