//
//  BTWatchDiscovery.swift
//  IntentTracker
//
//  Created by Adam Mullarkey on 1/31/16.
//  Copyright © 2016 Intent Watch. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import CoreData

/*

TODO:
- Behavior for instances where a user has multiple watches saved.
- Behavior to save new instances of watches to CD
*/

let btDiscoverySharedInstance = BTWatchDiscovery();

class BTWatchDiscovery: NSObject, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager?
    private var watchBLE: CBPeripheral?
    private var watches: [NSManagedObject]?
    
    override init() {
        super.init()
        
        let centralQueue = dispatch_queue_create("com.intentwatch", DISPATCH_QUEUE_SERIAL)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let watchesRequest = NSFetchRequest(entityName: "Watch")
        
        do {
            let results =
            try managedContext.executeFetchRequest(watchesRequest)
            watches = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func startScanning() {
        if let central = centralManager {
            // If saved watches exist, search for each by the saved UUID
            if let savedWatches = watches {
                for watch in savedWatches {
                    if let uuid = watch.valueForKey("uuid") as? String {
                        central.scanForPeripheralsWithServices([CBUUID(string: uuid)], options: nil)
                        // TODO: Behavior for if Primary Watch isn't found
                    }
                }
            }
        }
    }
    
    // TODO: Change to instance of BTWatchService
    var bleService: BTWatchService? {
        didSet {
            if let service = self.bleService {
                // TODO: Start up upload/download behavior on our BTWatchService
            }
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        // Be sure to retain the peripheral or it will fail during connection.
        
        // Validate peripheral information
        if ((peripheral.name == nil) || (peripheral.name == "")) {
            return
        }
        
        // If not already connected to a peripheral, then connect to this one
        if ((self.watchBLE == nil) || (self.watchBLE?.state == CBPeripheralState.Disconnected)) {
            // Retain the peripheral before trying to connect
            self.watchBLE = peripheral
            
            // Reset service
            self.bleService = nil
            
            // Connect to peripheral
            central.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        // Create new service class
        if (peripheral == self.watchBLE) {
            self.bleService = BTWatchService(initWithWatch: peripheral)
        }
        
        // Stop scanning for new devices
        central.stopScan()
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        // See if it was our peripheral that disconnected
        if (peripheral == self.watchBLE) {
            self.bleService = nil;
            self.watchBLE = nil;
        }
        
        // Start scanning for new devices
        self.startScanning()
    }
    
    // MARK: - Private
    
    func clearDevices() {
        self.bleService = nil
        self.watchBLE = nil
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case CBCentralManagerState.PoweredOff:
            self.clearDevices()
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            break
            
        case CBCentralManagerState.PoweredOn:
            self.startScanning()
            
        case CBCentralManagerState.Resetting:
            self.clearDevices()
            
        case CBCentralManagerState.Unsupported:
            break
        }
    }
    
}

