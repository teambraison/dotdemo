//
//  MenuItem.swift
//  Dot
//
//  Created by Titus Cheng on 11/3/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class MenuItem:DotItem
{
    @IBOutlet weak var itemLabel: UILabel!
    
    override func allLabels() -> [UILabel] {
        var labels: [UILabel] = []
        labels.append(itemLabel)
        return labels
    }
    
    
}
