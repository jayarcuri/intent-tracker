//
//  BTWatchService.swift
//  IntentTracker
//
//  Created by Adam Mullarkey on 1/20/16.
//  Copyright © 2016 Intent Watch. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import CoreData

// Maybe put this elsewhere?
let JoggingMinutesTodayUUID = CBUUID(string: "placeholder")
let MeditationMinutesTodayUUID = CBUUID(string: "placeholder")


class BTWatchService: NSObject, CBPeripheralDelegate {
    var watch: CBPeripheral?
    var watchBLEUUID: CBUUID?
    
    init(initWithWatch watch: CBPeripheral) {
        super.init()
        
        self.watch = watch
        self.watch?.delegate = self
    }
    
    deinit {
        // TODO: save Watch-specific UUID info for next session.
    }
    
    // Mark: - CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        // TODO:
        
        if (peripheral != self.watch) {
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
            if service.UUID == watchBLEUUID! {
               // discover, write characteristics if necessary.
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (peripheral != self.watch) {
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
    
    // Called when app requests a watch sync
    func getWatchData() -> Bool {
        let watchDate = self.watch?.valueForKey("date") as? NSDate
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Day")
        // UH OH
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        // Gotta write a thing that grabs the current day if it exists and writes all the data it needs to to that entry.
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            var watches = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
        return false
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName("PlaceholderConnectionAlert", object: self, userInfo: connectionDetails)
    }

    

}