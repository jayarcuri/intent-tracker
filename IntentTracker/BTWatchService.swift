//
//  BTWatchService.swift
//  IntentTracker
//
//  Created by Adam Mullarkey on 1/20/16.
//  Copyright © 2016 Intent Watch. All rights reserved.
//

import Foundation
import CoreBluetooth

// Maybe put this elsewhere?
let JoggingMinutesTodayUUID = CBUUID(string: "placeholder")
let MeditationMinutesTodayUUID = CBUUID(string: "placeholder")


class BTWatchService: NSObject, CBPeripheralDelegate {
    var myWatch: CBPeripheral?
    var myWatchBLEUUID: CBUUID?
    
    init(initWithWatch watch: CBPeripheral) {
        super.init()
        
        self.myWatch = watch
        self.myWatch?.delegate = self
    }
    
    deinit {
        // TODO: save Watch-specific UUID info for next session.
    }
    
    // Mark: - CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        // TODO:
        
        if (peripheral != self.myWatch) {
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        
        for service in peripheral.services! {
            if service.UUID == myWatchBLEUUID! {
               // discover, write characteristics if necessary.
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (peripheral != self.myWatch) {
            return
        }
        
        if (error != nil) {
            return
        }
        
        
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // TODO: replace "service.characteristics" with our relevant characteristics to read/write
                continue
            }
        }
    }
    
    // Mark: - Private
    
        // TODO: read/write-to-watch funcs
    
    func 
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName("PlaceholderConnectionAlert", object: self, userInfo: connectionDetails)
    }

    

}