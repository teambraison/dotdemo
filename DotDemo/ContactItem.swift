//
//  ContactItem.swift
//  Dot
//
//  Created by Titus Cheng on 11/7/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class ContactItem:DotItem
{
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactMessage: UILabel!
    
    override func allLabels() -> [UILabel] {
        var lables: [UILabel] = []
        lables.append(contactName)
        lables.append(contactMessage)
        return lables
    }
}
