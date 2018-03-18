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
///
/// 0xFFF1: Read data
///
/// 0xFFF3: Write data
///
/// 0xFFF4: Write. Start and close communication.
class BluetoothManager: NSObject {
    
    static let shared = BluetoothManager()
    
    private var centralManager: CBCentralManager?
    private var targetedBLEDeviceName: String?
    
    // Targeted Services
    private let openLockServiceCBUUID = CBUUID(string: "0xFFF0")
    
    // Targeted Characteristics
    private let readDataCharacteristicCBUUID = CBUUID(string: "0xFFF1")
    private let writeDataCharacteristicCBUUID = CBUUID(string: "0xFFF3")
    private let startCloseCommunicationCharacteristicCBUUID = CBUUID(string: "0xFFF4")
    
    private let targetedServices: [CBUUID]
    private let targetedCharacteristics: [CBUUID]
    
    override private init() {
        
        targetedServices = [openLockServiceCBUUID]
        targetedCharacteristics = [readDataCharacteristicCBUUID,
                                   writeDataCharacteristicCBUUID,
                                   startCloseCommunicationCharacteristicCBUUID]
        
        super.init()
    }
    
    /// A method to start searching for peripherals.
    ///
    /// - Parameter name: The name of the peripheral to search for. Default value is nil, which means that we are interested in all available peripherals.
    func startScan(with name: String? = nil) {
        targetedBLEDeviceName = name
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// A method to be called when a device matches scanning criteria
    private func targetedBLEDeviceFound(peripheral: CBPeripheral) {
        // Stop scanning for other devices
        centralManager?.stopScan()
        
        // Set the delegate of the peripheral. We need this for discovering services
        peripheral.delegate = self
        
        // Connect to the peripheral
        centralManager?.connect(peripheral)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: targetedServices, options: nil)
        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name ?? "")
        
        // A device that matches our scan criteria was found.
        // targetedBLEDeviceName is nil ==> Any device that matches our scan criteria is acceptable.
        // targetedBLEDeviceName is not nil ==> We are interested in a device with certain name.
        if targetedBLEDeviceName == nil || (targetedBLEDeviceName != nil && peripheral.name == targetedBLEDeviceName) {
            targetedBLEDeviceFound(peripheral: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(targetedServices)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(targetedCharacteristics, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
//
            switch characteristic {
            case readDataCharacteristicCBUUID:
                peripheral.readValue(for: characteristic)
            default:
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        switch characteristic {
        case readDataCharacteristicCBUUID:
            print(characteristic.value ?? "no value")
        default:
            break
        }
    }
}