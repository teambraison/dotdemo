//
//  MessageViewController.swift
//  Dot
//
//  Created by Titus Cheng on 11/13/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit


class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DotHTTPRequestDelegate
{
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var sendMessageLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendLabel: UILabel!
    
    
    var contact: Contact
    let dotMessage = DotSendMessage()
    let dotReceiveMessage = DotGetMessages()
    var messages:[Message]
    var keyHolder:KeyboardPlaceHolder!
    let account = Account.sharedInstance
    
    var socketIsConnected: Bool
    
    
    override init() {
        messages = []
        contact = Contact(name:"", id:"")
        socketIsConnected = false
        super.init()
    }
    
    required init(coder aDecoder:NSCoder) {
        messages = []
        contact = Contact(name:"", id:"")
        socketIsConnected = false
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        contactNameLabel.text = contact.username
        messageTableView.delegate = self
        messageTableView.dataSource = self
        dotMessage.delegate = self
        dotReceiveMessage.delegate = self
        getMessages()
        
        
        self.messageTableView.registerNib(UINib(nibName: Data.dotDialogBoxNibName(), bundle: nil), forCellReuseIdentifier: Data.dotDialogBoxNibID())
        
        var oneTap = UITapGestureRecognizer(target: self, action: "callKeyboard")
        oneTap.numberOfTouchesRequired = 1
        sendMessageLabel.addGestureRecognizer(oneTap)
        
        var sendTap = UITapGestureRecognizer(target: self, action: "sendMessage")
        sendTap.numberOfTouchesRequired = 1
        sendLabel.addGestureRecognizer(sendTap)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "returnToPreviousScreen")
        swipeRight.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeRight)
        
        keyHolder = KeyboardPlaceHolder.sharedInstance
        
        let url = Data.URL() + "/socket.io/"
        
        println("Url: \(url)")
    }
    

    
    func returnToPreviousScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getMessages() {
        var userData = NSMutableDictionary()
        userData.setValue(account.session_id, forKey: "session_id")
        userData.setValue(account.user_id, forKey: "user_id")
        userData.setValue(contact.userid, forKey: "contact_id")
        dotReceiveMessage.startRequest(userData)
    }
    
    func callKeyboard() {
        var keyboardController: KeyboardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("keyboard") as KeyboardViewController
        keyboardController.setKey(Data.messageKey())
        self.presentViewController(keyboardController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {

        if(keyHolder.store != nil) {
            if(keyHolder.store.objectForKey(Data.messageKey()) != nil) {
                var message: String = keyHolder.store.objectForKey(Data.messageKey()) as String
                self.sendMessageLabel.text = message
            }
        }
    }
    
    func setContact(theContact: Contact) {
        contact = theContact
    }
    
    func sendMessage() {
        if(sendMessageLabel.text != "") {
            let myAccount = Account.sharedInstance
            var theMessage = sendMessageLabel.text!
            var myPrivateMessage: Dictionary<String, String> = ["session_id":myAccount.session_id, "sender_id":myAccount.user_id, "receiver_id":contact.userid, "message":theMessage] as Dictionary<String, String>
            dotMessage.startRequest(myPrivateMessage)
        } else {
            if(socketIsConnected) {
                println("Connected to server")
            } else {
                println("NOt connected to server")
            }
        }
//        if(sendMessageLabel.text != nil) {
//            let myMessage = Message()
//            myMessage.senderName = "김주윤"
//            myMessage.messageContent = sendMessageLabel.text
//            messages.append(myMessage)
//        }
        dispatch_async(dispatch_get_main_queue(), {
            self.messageTableView.reloadData()
            if(self.messages.count > 0) {
                var path = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                self.messageTableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        })
    }
    
    func testMessaging() {
        messages.removeAll(keepCapacity: false)
        let messageOne = Message()
        messageOne.senderName = contact.username
        messageOne.messageContent = "안녕!"
        
        let messageTwo = Message()
        messageTwo.senderName = contact.username
        messageTwo.messageContent = "어디에요?"
        
        messages.append(messageOne)
        messages.append(messageTwo)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.messageTableView.reloadData()
            if(self.messages.count > 0) {
                var path = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                self.messageTableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        })

    }
    
    func DotHTTPRequestDidReceiveData(data: NSDictionary){
        println(data)
        if(data.objectForKey("messages") != nil) {
            messages.removeAll(keepCapacity: false)
            let messagesList: [NSDictionary] = data.objectForKey("messages")! as [NSDictionary]
            for(var i = 0; i < messagesList.count; i++) {
                let theMessage: NSDictionary = messagesList[i] as NSDictionary
                let message = Message()
                message.messageContent = theMessage.objectForKey("content") as String
                if((theMessage.objectForKey("sender") as String) == account.user_id) {
                    message.senderName = account.username
                } else {
                    message.senderName = contact.username
                }
                messages.append(message)
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.messageTableView.reloadData()
                if(self.messages.count > 0) {
                    var path = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                    self.messageTableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }
            })
        }
        if(data.objectForKey("content") != nil) {
            getMessages()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: DotDialogBox = tableView.dequeueReusableCellWithIdentifier(Data.dotDialogBoxNibID()) as DotDialogBox
        let myMessage = messages[indexPath.row]
        if(myMessage.senderName == account.username) {
            cell.setUserSentContent()
            cell.userLabel.text = account.username
        } else {
            cell.setContactSentContent()
            cell.userLabel.text = myMessage.senderName
        }
        cell.messageTextView.text = myMessage.messageContent
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.messageTextView.layer.cornerRadius = 7.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0
    }
}
