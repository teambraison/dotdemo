//
//  BLEScanner.swift
//  BLETest
//
//  Created by Titus Cheng on 12/5/14.
//  Copyright (c) 2014 Braison. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc protocol BLEScannerDelegate
{
    func bleScannerUpdate(updates: String)
    optional func bleScannerDiscovered(peripherals: CBPeripheral)
    optional func bleScannerDidUpdateAdvertisementStatus(isOn: Bool)
    func bleScannerConnectedTo(deviceName: String)
    func bleScannerUpdateConnectionStatus(deviceName: String, status: Bool)
}

protocol BLEScannerDeviceDiscoveryDelegate
{
    func bleScannerDiscovered(peripherals: CBPeripheral)
}

protocol BLEScannerServiceDiscoveryDelegate
{
    func bleScannerDiscoveredService(service: CBService)
}

protocol BLEScannerCharacteristicDiscoveryDelegate
{
    func bleScannerDiscoveredCharacteristic(theCharacteristic: CBCharacteristic)
}

private let _BLEScannerSharedInstance = BLEScanner()

class BLEScanner:NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate

{
    var bleManager: CBCentralManager!
    var allDevices: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral!
    var peripheralUUID:NSUUID!
    var deviceDelegate: BLEScannerDeviceDiscoveryDelegate!
    var delegate: BLEScannerDelegate!
    var peripheralManager:CBPeripheralManager!
    var targetCharacteristic: CBCharacteristic!
    var service: BLEScannerServiceDiscoveryDelegate!
    var characteristic: BLEScannerCharacteristicDiscoveryDelegate!
    var selectedService: CBService!
    var selectedCharacteristic: CBCharacteristic!
    var selectedCharacteristicUUID: CBUUID!
    
    class func sharedInstance() -> BLEScanner {
        return _BLEScannerSharedInstance
    }
    
    override init() {
        super.init()
        bleManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }
    func startScan() {
        bleManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stopScan() {
        bleManager.stopScan()
    }
    
    func sendData(data: String) {
        if(selectedPeripheral != nil && selectedCharacteristic != nil) {
            println("Trying to send data")
            selectedPeripheral.writeValue(data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), forCharacteristic: selectedCharacteristic, type: CBCharacteristicWriteType.WithResponse)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if(error != nil) {
            println("Did not write value because of error: \(error.debugDescription)")
        } else {
            println("Write data successfull")
        }
//        if(delegate != nil) {
//            if(error != nil) {
//                delegate.bleScannerUpdate("error in writing data to device: \(error)")
//            } else {
//                delegate.bleScannerUpdate("Did write value to device")
//            }
//        }
    }
    
    func discoverServices() {
        selectedPeripheral.discoverServices(nil)
    }
    
    func chooseThisCharacteristic(characteristic: CBCharacteristic) {
        selectedCharacteristic = characteristic
        selectedCharacteristicUUID = selectedCharacteristic.UUID
        println("Chose characteristic with identifier \(selectedCharacteristic.UUID)")
    }
    
    
    func chooseThisService(theService: CBService) {
        selectedService = theService
        println("Chose service with identifier \(selectedService.UUID)")
    }
    
    func connectToPeripheral(device: CBPeripheral) {
//        if(delegate != nil) {
//            delegate.bleScannerUpdate("Connecting to \(device.name)")
//            delegate.bleScannerConnectedTo(device.name)
//        }
        bleManager.connectPeripheral(device, options: nil)
        peripheralUUID = device.identifier
        selectedPeripheral = device
        selectedPeripheral.delegate = self
    }
    
    func disconnectWithPeripheral(peripheral: CBPeripheral) {
    
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!){
        
    }
    
    func getCharacteristics() {
        selectedPeripheral.discoverCharacteristics(nil, forService:selectedService)
    }
    
//    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveWriteRequests requests: [AnyObject]!) {
//        for(var i = 0; i  < requests.count; i++) {
//            let request: CBATTRequest = requests[0] as CBATTRequest
//            let requested_data:NSData = request.value as NSData
//            let dataString = NSString(data: requested_data, encoding: NSUTF8StringEncoding)
//            if(delegate != nil) {
//                delegate.bleScannerUpdate("Receiving a data \(dataString!)")
//            }
////            peripheralManager.respondToRequest(request, withResult: CBATTError.Success)
//        }
//    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        deviceDelegate.bleScannerDiscovered(peripheral)
        println("Did discovered peripheral \(peripheral.name)")
//        if(delegate != nil) {
//            delegate.bleScannerUpdate("Did found peripheral \(peripheral.name)")
//        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Did connect with peripheral \(peripheral.name)")
        if(selectedCharacteristic != nil && selectedService != nil) {
            println("Rediscovering characteristics")
            peripheral.discoverCharacteristics([selectedCharacteristicUUID], forService:selectedService)
        }
//        if(delegate != nil) {
//            delegate.bleScannerUpdateConnectionStatus(peripheral.name, status: true)
//            delegate.bleScannerUpdate("\(peripheral.name) is connected")
//        }
    }
    
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        if(error != nil) {
            println("CBManager disconnected error: \(error)")
            var knownPeripherals = bleManager.retrievePeripheralsWithIdentifiers([peripheralUUID])
            println("Reconnect options \(knownPeripherals.count)")
            bleManager.connectPeripheral(knownPeripherals[0] as CBPeripheral, options: nil)
            selectedPeripheral = knownPeripherals[0] as CBPeripheral
            selectedPeripheral.delegate = self

        } else {
            //automatically reconnects
            var knownPeripherals = bleManager.retrievePeripheralsWithIdentifiers([peripheralUUID])
            println("Reconnect options \(knownPeripherals.count)")
            bleManager.connectPeripheral(knownPeripherals[0] as CBPeripheral, options: nil)
            if(delegate != nil) {
                delegate.bleScannerUpdateConnectionStatus("Device name", status: false)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if(error != nil) {
            if(delegate != nil) {
                delegate.bleScannerUpdate("Error discovering services from \(peripheral.name)")
            }
        } else {
            //List out the services available from the connected peripheral
            if(peripheral.services != nil) {
                for(var i = 0 ; i < peripheral.services.count; i++) {
                    var myService = peripheral.services[i] as CBService
                                println("Discovered  service uuid\(myService.UUID)")
                    service.bleScannerDiscoveredService(myService)
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if(error == nil) {
            for(var i = 0; i < service.characteristics.count; i++) {
                //We are capturing one characteristic for this demo
                var myCharacteristic = service.characteristics[i] as CBCharacteristic
                selectedCharacteristic = myCharacteristic
                selectedCharacteristicUUID = selectedCharacteristic.UUID
                println("Recaptured characteristic uuid \(selectedCharacteristic.UUID)")
                println("Discovered characteristic uuid \(myCharacteristic.UUID)")
                characteristic.bleScannerDiscoveredCharacteristic(myCharacteristic)
            }
        } else {
            println("error in discovering characteristics: \(error.localizedDescription)")
        }
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        if(delegate != nil) {
            delegate.bleScannerUpdateConnectionStatus(peripheral.name, status: false)
            delegate.bleScannerUpdate("Failed to connect with \(peripheral.name)")
        }
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if(delegate != nil) {
            switch (central.state) {
            case CBCentralManagerState.PoweredOff:
                delegate.bleScannerUpdate("CoreBluetooth BLE hardware is powered off");
                break;
            case CBCentralManagerState.PoweredOn:
                delegate.bleScannerUpdate("CoreBluetooth BLE hardware is powered on and ready");
                break;
            case CBCentralManagerState.Resetting:
                delegate.bleScannerUpdate("CoreBluetooth BLE hardware is resetting");
                break;
            case CBCentralManagerState.Unauthorized:
                delegate.bleScannerUpdate("CoreBluetooth BLE state is unauthorized");
                break;
            case CBCentralManagerState.Unknown:
                delegate.bleScannerUpdate("CoreBluetooth BLE state is unknown");
                break;
            case CBCentralManagerState.Unsupported:
                delegate.bleScannerUpdate("CoreBluetooth BLE hardware is unsupported on this platform");
                break;
            default:
                break;
            }
        }
    }
    
}
