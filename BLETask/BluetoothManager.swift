//
//  BluetoothManager.swift
//  BLETask
//
//  Created by Mohamed Abdul-Hameed on 3/17/18.
//  Copyright © 2018 Mohamed Abdul-Hameed. All rights reserved.
//

import Foundation
import CoreBluetooth

/// A class to manage communicating with a BLE devices that advertize the following 3 services:
/// 0xFFF1: Read data
/// 0xFFF3: Write data
/// 0xFFF4: Write. Start and close communication.
class BluetoothManager: NSObject {
    
    static let shared = BluetoothManager()
    
    private var centralManager: CBCentralManager?
    private var targetBLEDevice: String?
    
    override private init() {
        super.init()
    }
    
    /// A method to start searching for peripherals.
    ///
    /// - Parameter name: The name of the peripheral to search for. Default value is nil, which means that we are interested in all available peripherals.
    func start(with name: String? = nil) {
        targetBLEDevice = name
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name)
        guard let targetBLEDevice = targetBLEDevice else { return }
        
        if peripheral.name == targetBLEDevice {
            
        }
    }
}
