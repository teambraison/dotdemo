//
//  DotAPI.swift
//  Dot
//
//  Created by Titus Cheng on 11/12/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation

protocol DotHTTPRequestDelegate
{
    func DotHTTPRequestDidReceiveData(data:NSDictionary)
}


public class DotHTTPRequest
{
//    let developmentURL = "http://localhost:3000"
//    let stagingURL = "http://teambraison-dot.jit.su"
    var myURL: String!
    var delegate: DotHTTPRequestDelegate!
    
    init()
    {
        //Set server
        myURL = Data.URL()
    }

    
    func startRequest(relativeURL: String, parameters: Dictionary<String, AnyObject>) {
        var request = HTTPTask()
        request.POST(myURL + relativeURL, parameters: parameters, success: {(response: HTTPResponse) in
            var keyData:NSData = response.responseObject! as NSData
            var stringData = NSString(data: keyData, encoding: NSUTF8StringEncoding)
            var jsonObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(keyData, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
            self.didFinishRequest(jsonObject)

            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error) response: \(response?.text())")
        })
    }
    
    func startRequest(relativeURL: String) {
        let url = NSURL(string:myURL + relativeURL)
        var request = HTTPTask()
        request.POST(myURL + relativeURL, parameters:nil,  success: {(response: HTTPResponse) in
            var keyData:NSData = response.responseObject! as NSData
            var stringData = NSString(data: keyData, encoding: NSUTF8StringEncoding)
            var jsonObject: NSDictionary = NSJSONSerialization.JSONObjectWithData(keyData, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
            self.didFinishRequest(jsonObject)
            
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error) response: \(response?.text())")
        })
    }
    
    func didFinishRequest(response: NSDictionary)
    {
        delegate.DotHTTPRequestDidReceiveData(response)
    }
    
}

public class DotRequestLogin:DotHTTPRequest
{
    let api = "/api/login"
    
    func startRequest(parameters: NSDictionary) {
        var userName: AnyObject = parameters["username"]! as AnyObject
        var passWord: AnyObject = parameters["pass"]! as AnyObject
        var loginParameters: Dictionary<String, AnyObject> = ["user": userName, "pass":passWord] as Dictionary<String, AnyObject>
        self.startRequest(api, parameters: loginParameters)
    }
}

class DotSendMessage:DotHTTPRequest
{
    let api = "/api/message/send"
    
    func startRequest(parameters: NSDictionary) {
        var sessionid: AnyObject = parameters["session_id"]! as AnyObject
        var senderid: AnyObject = parameters["sender_id"]! as AnyObject
        var receiverid: AnyObject = parameters["receiver_id"]! as AnyObject
        var message: AnyObject = parameters["message"]! as AnyObject
        var messageParameters: Dictionary<String, AnyObject> = ["session_id":sessionid, "sender_id":senderid, "receiver_id":receiverid, "message":message] as Dictionary<String, AnyObject>
        self.startRequest(api, parameters: messageParameters)
    }
}

class DotGetMessages:DotHTTPRequest
{
    let api = "/api/message/get"
    
    func startRequest(parameters: NSDictionary) {
        var sessionid: AnyObject = parameters["session_id"]! as AnyObject
        var userid: AnyObject = parameters["user_id"]! as AnyObject
        var contactid: AnyObject = parameters["contact_id"]! as AnyObject
        var messageParameters: Dictionary<String, AnyObject> = ["session_id": sessionid, "user_id":userid, "contact_id":contactid] as Dictionary <String, AnyObject>
        self.startRequest(api, parameters: messageParameters)
    }
}

class DotRequestAllUsers:DotHTTPRequest
{
    let api = "/api/allusers"
    
    func startRequest() {
        let myAccount = Account.sharedInstance
        var messageParameters: Dictionary<String, AnyObject> = ["session_id":myAccount.session_id] as Dictionary<String, AnyObject>
        self.startRequest(api, parameters: messageParameters)
    }
}


