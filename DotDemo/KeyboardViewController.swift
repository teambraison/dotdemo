//
//  ViewController.swift
//  Dot
//
//  Created by Titus Cheng on 10/23/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var characters = [["A", "B", "C", "D", "E", "F"], ["G", "H", "I", "J", "K", "L"], ["M", "N", "O", "P", "Q", "R"], ["S", "T", "U", "V", "W", "X"], ["Y", "Z", "1", "2", "3", "4"], ["5","6", "7", "8", "9", "0"]]

    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var groupOne: UIView!
    @IBOutlet weak var groupTwo: UIView!
    @IBOutlet weak var groupThree: UIView!
    @IBOutlet weak var groupFour: UIView!
    @IBOutlet weak var groupFive: UIView!
    @IBOutlet weak var groupSix: UIView!
    
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelSix: UILabel!
    
    var groups : [UIView] = []
    var labels : [UILabel] = []
    var groupIndex = -1
    var textIndex = -1
    var shouldReset = false
    var output = ""
    var selectedColor = UIColor.orangeColor()
    var originalColor:UIColor!
    var selectedView:UIView!
    var shouldBeLowerCase:Bool = false
    
    var key:String!
    
    @IBOutlet weak var resetPressed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInterface()
        
        var oneTap = UITapGestureRecognizer(target: self, action:"viewTapped")
        contractAllGroup()
        
        outputTextField.text = ""

        originalColor = UIColor(red:49/255.0, green: 109/255.0, blue: 217/255.0, alpha: 1.0)
        
        resetPressed.addTarget(self, action: "resetTapped", forControlEvents: .TouchUpInside)
        
        var dismissScreenSwipe = UISwipeGestureRecognizer(target: self, action: "saveAndReturn")
        dismissScreenSwipe.numberOfTouchesRequired = 2
        dismissScreenSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(dismissScreenSwipe)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "switchToLowerCase")
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "deleteOneCharacter")
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
//        var twoSwipeDown = UISwipeGestureRecognizer(target: self, action: "insertPeriodPunctuation")
//        twoSwipeDown.direction = UISwipeGestureRecognizerDirection.Down
//        twoSwipeDown.numberOfTouchesRequired = 2
//        self.view.addGestureRecognizer(twoSwipeDown)
        
     //   var swipeUp = UISwipeGestureRecognizer(target: self, action: "insertCommaPunctuation")
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "switchToUpperCase")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
 //       var swipeLeft = UISwipeGestureRecognizer(target: self, action: "deleteOneCharacter")
//        var swipeLeft = UISwipeGestureRecognizer(target:self, action:"saveAndReturn")
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        self.view.addGestureRecognizer(swipeLeft)
        
//        var swipeRight = UISwipeGestureRecognizer(target: self, action: "returnToPreviousScreen")
//        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(swipeRight)
        
//        var twoSwipeRight = UISwipeGestureRecognizer(target: self, action:"saveAndReturn")
//        twoSwipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        twoSwipeRight.numberOfTouchesRequired = 2
//        self.view.addGestureRecognizer(twoSwipeRight)
//        
//        var threeFingerDown = UISwipeGestureRecognizer(target: self, action:"switchToLowerCase")
//        threeFingerDown.numberOfTouchesRequired = 3
//        threeFingerDown.direction = UISwipeGestureRecognizerDirection.Down
//        self.view.addGestureRecognizer(threeFingerDown)
//        
//        var threeFingerUp = UISwipeGestureRecognizer(target: self, action: "switchToUpperCase")
//        threeFingerUp.numberOfTouchesRequired = 3
//        threeFingerUp.direction = UISwipeGestureRecognizerDirection.Up
//        self.view.addGestureRecognizer(threeFingerUp)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(motion == UIEventSubtype.MotionShake) {
            println("I'm shaking")
            saveAndReturn()
        }
    }
    
    func setUpInterface() {
        addTapGestureToUI(groupOne)
        addTapGestureToUI(groupTwo)
        addTapGestureToUI(groupThree)
        addTapGestureToUI(groupFour)
        addTapGestureToUI(groupFive)
        addTapGestureToUI(groupSix)
        groups.insert(groupOne, atIndex: 0)
        groups.insert(groupTwo, atIndex: 1)
        groups.insert(groupThree, atIndex: 2)
        groups.insert(groupFour, atIndex:3)
        groups.insert(groupFive, atIndex:4)
        groups.insert(groupSix, atIndex:5)
        
        labels.insert(labelOne, atIndex:0)
        labels.insert(labelTwo, atIndex:1)
        labels.insert(labelThree, atIndex:2)
        labels.insert(labelFour, atIndex:3)
        labels.insert(labelFive, atIndex:4)
        labels.insert(labelSix, atIndex:5)
    }
    
    func switchToLowerCase() {
        shouldBeLowerCase = true
        for(var i = 0; i < groups.count; i++)
        {
            var allViews = groups[i].subviews
            for(var k = 0; k < allViews.count; k++)
            {
                var label:UILabel = allViews[k] as UILabel
                label.text =  label.text?.lowercaseString
            }
        }
    }
    
    func switchToUpperCase() {
        for(var i = 0; i < groups.count; i++)
        {
            var allViews = groups[i].subviews
            for(var k = 0; k < allViews.count; k++)
            {
                var label:UILabel = allViews[k] as UILabel
                label.text =  label.text?.uppercaseString
            }
        }
        shouldBeLowerCase = false
    }
    
    func setKey(theKey: String) {
        key = theKey
    }
    
    func saveAndReturn() {
        let keyboardHolder = KeyboardPlaceHolder.sharedInstance
        if(keyboardHolder.store == nil){
            keyboardHolder.store = NSMutableDictionary()
            keyboardHolder.store.setValue(outputTextField.text, forKey: key)
        } else if(key == nil){
            returnToPreviousScreen()
        } else {
            keyboardHolder.store.setValue(outputTextField.text, forKey: key)
        }
        returnToPreviousScreen()
    }
    
    func insertSpacePunctuation() {
        output += " "
        outputTextField.text = output
    }
    
    func insertCommaPunctuation() {
        output += ","
        outputTextField.text = output
    }
    
    func deleteOneCharacter() {
        if(countElements(outputTextField.text) > 0) {
            outputTextField.text = outputTextField.text.substringToIndex(outputTextField.text.endIndex.predecessor())
        }
    }
    
    func insertPeriodPunctuation() {
        output += "."
        outputTextField.text = output
    }
    
    
    func returnToPreviousScreen()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
  
    }
    
    func changedSelectedGroup(theView: UIView) {
        theView.backgroundColor = selectedColor
    }
    
    func deselectingSelectedGroup(theView: UIView) {
        theView.backgroundColor = originalColor
    }
    
    
    func addTapGestureToUI(theView: UIView) {
        var oneTap = UITapGestureRecognizer(target: self, action:"viewTapped:")
        oneTap.delegate = self;
        theView.addGestureRecognizer(oneTap)
    }
    
    func resetTapped() {
        output = ""
        outputTextField.text = ""
    }
    
    
    func viewTapped(tapGesture:UITapGestureRecognizer) {
            selectedView = tapGesture.view!
            if(groupIndex == -1) {
                groupIndex = getIndex(selectedView)
                expandTheGroup(characters[groupIndex])
                
            } else if(textIndex == -1) {
                textIndex = getIndex(tapGesture.view!)
                var selectedCharacter = characters[groupIndex][textIndex]
                if(shouldBeLowerCase) {
                    selectedCharacter = selectedCharacter.lowercaseString
                }
  //              output += selectedCharacter
                outputTextField.text = outputTextField.text + selectedCharacter
                groupIndex = -1
                textIndex = -1
                contractAllGroup()
            }
    }
    
    func expandTheGroup(characters: [String]) {
        for(var i = 0; i < labels.count; i++) {
            var label: UILabel = labels[i] as UILabel
            label.hidden = false
            if(shouldBeLowerCase) {
                label.text = characters[i].lowercaseString
            } else {
                label.text = characters[i]
            }
        }
    }
    func contractAllGroup() {
        for(var i = 0; i < labels.count; i++) {
            var label: UILabel = labels[i] as UILabel
            label.hidden = true
        }
    }
    
    func getIndex(theView: UIView) -> Int {
        var index = 0
        for(var i = 0; i < groups.count; i++) {
            if(theView === groups[i]) {
                index = i
            }
        }
        return index
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

