//
//  BluetoothDeviceViewController.swift
//  DotDemo
//
//  Created by Titus Cheng on 12/10/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import UIKit

import CoreBluetooth

class BluetoothDeviceViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, BLEScannerDeviceDiscoveryDelegate
{
    
    @IBOutlet weak var bluetoothDeviceTableView: UITableView!
    
    var bleManager: BLEScanner!
    var peripheralList:[CBPeripheral]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralList = []
        
        bluetoothDeviceTableView.delegate = self
        bluetoothDeviceTableView.dataSource = self
        
        bleManager = BLEScanner.sharedInstance()
        bleManager.deviceDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if(bleManager.selectedCharacteristic != nil) {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            if(bleManager == nil) {
                bleManager = BLEScanner.sharedInstance()
            }
            bleManager.deviceDelegate = self
            bleManager.startScan()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text = peripheralList[indexPath.row].name
        cell.detailTextLabel?.text = peripheralList[indexPath.row].description
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        bleManager.connectToPeripheral(peripheralList[indexPath.row])
        let bleServiceVC:PeripheralServicesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("bluetoothservice") as PeripheralServicesViewController
        self.navigationController?.pushViewController(bleServiceVC, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralList.count
    }
    
    func bleScannerDiscovered(peripherals: CBPeripheral) {
        peripheralList.append(peripherals)
        println("Discover new peripheral: \(peripherals.name)")
        bluetoothDeviceTableView.reloadData()
    }
    
    
    
}