//
//  DotViewController.swift
//  DotDemo
//
//  Created by Titus Cheng on 12/10/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class DotViewController:UIViewController
{
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func showAlertWithMessage(message: String) {
        UIView.animateWithDuration(1.0, animations: {
            self.alertView.hidden = false
            self.messageLabel.text = message
        })
    }
    
    func dismissAlertView() {
        UIView.animateWithDuration(1.0, animations: {
            self.alertView.hidden = true
        })
    }
    
}
