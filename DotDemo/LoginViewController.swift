//
//  LoginViewController.swift
//  Dot
//
//  Created by Titus Cheng on 11/12/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController, DotHTTPRequestDelegate
{
//    @IBOutlet weak var loginTableView: DotTableView!
    @IBOutlet weak var passwordSelectionLabel: UILabel!
    @IBOutlet weak var usernameSelectionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var usernameDisplayLabel: UILabel!
    @IBOutlet weak var passwordDisplayLabel: UILabel!
    
    
    var status:String!
    
    var selectedOption:String = ""
    
    @IBOutlet weak var selectionLabel: UILabel!
    
    var account = Account.sharedInstance
    var keyholder:KeyboardPlaceHolder!
    var dotLogin: DotRequestLogin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameDisplayLabel.text = ""
        passwordDisplayLabel.text = ""
        statusLabel.text = ""
        
        let usernameTap = UITapGestureRecognizer(target: self, action: "showUsernameKeyboard")
        usernameTap.numberOfTapsRequired = 1
        usernameTap.numberOfTouchesRequired = 1
        
        let passwordTap = UITapGestureRecognizer(target: self, action: "showPasswordKeyboard")
        
        usernameSelectionLabel.addGestureRecognizer(usernameTap)
        passwordSelectionLabel.addGestureRecognizer(passwordTap)

        keyholder = KeyboardPlaceHolder.sharedInstance
        keyholder.store = NSMutableDictionary()
        
        var authenticationTap = UITapGestureRecognizer(target: self, action: "authenticateUser")
        authenticationTap.numberOfTouchesRequired = 1
        authenticationTap.numberOfTapsRequired = 1
        selectionLabel.addGestureRecognizer(authenticationTap)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "returnToPreviousScreen")
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        dotLogin = DotRequestLogin()
        dotLogin.delegate = self

    }
    
    func showUsernameKeyboard() {
        let keyboardVC: KeyboardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("keyboard") as KeyboardViewController
        keyboardVC.setKey("username")
        selectedOption = "username"
        self.presentViewController(keyboardVC, animated: true, completion: nil)
        
    }
    
    func showPasswordKeyboard() {
        let keyboardVC: KeyboardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("keyboard") as KeyboardViewController
        keyboardVC.setKey("password")
        selectedOption = "password"
        self.presentViewController(keyboardVC, animated: true, completion: nil)
        
    }
    
    func returnToPreviousScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticateUser() {
        if(account.username != nil && account.password != nil) {
            var userData = NSMutableDictionary()
            userData.setValue(account.username, forKey: "username")
            userData.setValue(account.password, forKey: "pass")
            println("Authenticating user \(account.username) with password \(account.password)")
            dotLogin.startRequest(userData)
        } else {
            statusLabel.text = "Cannot authenticate user"
        }
    }
    
    func autoAuthenticateUser() {
//        myAccount.username = "titus2go"
//        myAccount.password = "test1ng"
//        if(myAccount.username != nil && myAccount.password != nil) {
//            var userData = NSMutableDictionary()
//            userData.setValue(myAccount.username, forKey: "username")
//            userData.setValue(myAccount.password, forKey: "pass")
//            println("Authenticating user \(myAccount.username) with password \(myAccount.password)")
//            dotLogin.startRequest(userData)
//        } else {
//            println("Cannot authenticate user")
//        }
    }
    
    
    func DotHTTPRequestDidReceiveData(data: NSDictionary) {
        println(data)
        if((data["error"] as Int) == 0) {
            statusLabel.text = "User now logged in authenticated"
            account.session_id = data["user_sessionid"] as String
            account.user_id = data["user_id"] as String
            account.isAuthenticated = true
            self.returnToPreviousScreen()
        }
//        dispatch_async(dispatch_get_main_queue(), {
////            self.loginTableView.reloadData()
//            self.returnToPreviousScreen()
//        })
//        println(data)
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if(keyholder.store!.objectForKey(selectedOption) != nil) {
            var input:String = keyholder.store.objectForKey(selectedOption) as String
            if(selectedOption == "password") {
                var pass = ""
                for(var i = 0; i < countElements(input); i++) {
                    pass += "*"
                }
                passwordDisplayLabel.text = pass
                account.password = input
            }
            if(selectedOption == "username") {
                usernameDisplayLabel.text = input
                account.username = input
            }
        } else {
            //   cell.nameLabel.text = ""
        }

        
    }
    
}
