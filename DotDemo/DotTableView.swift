//
//  DotTableView.swift
//  Dot
//
//  Created by Titus Cheng on 11/10/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class DotTableView:UITableView, UIGestureRecognizerDelegate
{
    private var enlargedTextSize:CGFloat = 50
    private var originalTextSize:CGFloat = 40
    private var fontFamilyName = "Helvetica Neue"
    private var currentSelectedItem: DotItem!
    private var touchCount = 0
    
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        checkForTouchPoint(touches)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        touchCount++
        checkForTouchPoint(touches)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        println("Touch count is \(touchCount)")
//        if(currentSelectedItem != nil) {
//            if(touchCount == 2) {
//                touchCount = 0
//                deselectMenuItem(currentSelectedItem)
//                nextAction()
//            } else if(touchCount == 1) {
//                touchCount = 0
//                deselectMenuItem(currentSelectedItem)
//            }
//        }
        nextAction()
    }
    
    func setTextSize(enlargedSize: CGFloat, originalSize: CGFloat, fontFamily: String) {
        enlargedTextSize = enlargedSize
        originalTextSize = originalSize
        fontFamilyName = fontFamily
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func highlightSelectedMenuItem() {
       currentSelectedItem.hightLight()
    }
    
    private func deselectMenuItem(item: DotItem) {
       item.unhighlight()
    }
    
    
    //Checking if the touching point is on one of the cells.
    private func checkForTouchPoint(touch: NSSet){
        var cells = self.visibleCells()
        let point: CGPoint = touch.anyObject()!.locationInView(self) as CGPoint
        for(var i = 0; i < cells.count; i++)
        {
            var bounds = cells[i].bounds
            var item: DotItem = cells[i] as DotItem
            var r:CGRect = item.frame
            if(CGRectContainsPoint(r, point)) {
                currentSelectedItem = item
                highlightSelectedMenuItem()
            } else {
                deselectMenuItem(item)
            }
        }
    }
    
    private func nextAction() {
        if(currentSelectedItem.viewController != nil && currentSelectedItem.destinationController != nil) {
            currentSelectedItem!.viewController.navigationController?.pushViewController(currentSelectedItem!.destinationController, animated: true)
        } else {
            touchCount = 1
        }
    }
    
}

