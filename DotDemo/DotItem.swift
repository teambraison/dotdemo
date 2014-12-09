//
//  DotItem.swift
//  Dot
//
//  Created by Titus Cheng on 11/10/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

protocol DotItemDelegate {
    func dotItemDidChooseThisMenu(dotItem: DotItem, title:String)
    func dotItemDidBeganTouch(dotItem: DotItem, title:String)
    func dotItemDidEndTouch(dotItem: DotItem, title:String)
}

class DotItem:UITableViewCell
{
    var delegate:DotItemDelegate?
    var viewController: UIViewController!
    var destinationController: UIViewController!
    
    var isHighlighted: Bool = false

    
    
    func allLabels() -> [UILabel] {
        return []
    }
    
    func hightLight() {
        if(!isHighlighted) {
            isHighlighted = true
            var dotLabels = allLabels()
            for(var i = 0; i < dotLabels.count; i++) {
                let fontSize = dotLabels[i].font.pointSize
                dotLabels[i].font = UIFont(name: Data.defaultFontFamily(), size: Data.enlargeSizeFactor(fontSize))
            }
        }
    }
    
    
    func unhighlight() {
        if(isHighlighted) {
            isHighlighted = false
            var dotLabels = allLabels()
            for(var i = 0; i < dotLabels.count; i++) {
                let fontSize = dotLabels[i].font.pointSize
                dotLabels[i].font = UIFont(name: Data.defaultFontFamily(), size:Data.returnFontSizeToDefault(fontSize))
            }
        }

    }
}
