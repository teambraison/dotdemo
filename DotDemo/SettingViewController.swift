//
//  SettingViewController.swift
//  DotDemo
//
//  Created by Titus Cheng on 12/10/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController:UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var settingTableView: UITableView!
    
    let headerTitle = ["Watch"]
    let settingOptions = [["Bluetooth"]]

    var ble:BLEScanner!
    
    override func viewDidLoad() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        var returnSwipe = UISwipeGestureRecognizer(target: self, action: "returnToPreviousScreen")
        returnSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(returnSwipe)
        
        var testSwipe = UISwipeGestureRecognizer(target: self, action: "testSendData")
        testSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(testSwipe)
        ble = BLEScanner.sharedInstance()
    }
    
    func testSendData() {
        ble.sendData("Test data to see if this will work")
    }
    
    func returnToPreviousScreen() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = settingOptions[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(settingOptions[indexPath.section][indexPath.row] == "Bluetooth") {
            let ble: BluetoothDeviceViewController = self.storyboard?.instantiateViewControllerWithIdentifier("bluetoothdevice") as BluetoothDeviceViewController
            self.navigationController?.pushViewController(ble, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headerTitle.count
    }
    
}
