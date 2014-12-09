//
//  DotDialogBox.swift
//  Dot
//
//  Created by Titus Cheng on 11/14/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class DotDialogBox:UITableViewCell
{
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var userLabel: UILabel!
    
    
    func setUserSentContent() {
        messageTextView.textAlignment = NSTextAlignment.Right
        userLabel.textAlignment = NSTextAlignment.Right
    }
    
    func setContactSentContent() {
        messageTextView.textAlignment = NSTextAlignment.Left
        userLabel.textAlignment = NSTextAlignment.Left
    }
    
}
