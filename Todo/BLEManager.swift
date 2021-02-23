//
//  BLEManager.swift
//  Todo
//
//  Created by Tran Tran on 2/22/21.
//

import Foundation
import CoreBluetooth
 
struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}
struct CBPs: Identifiable {
    let id: Int
    let CBP: CBPeripheral
}

var myPeripheal:CBPeripheral?
var myCharacteristic:CBCharacteristic?
var manager:CBCentralManager!

let serviceUUID = CBUUID(string: "ab0828b1-198e-4351-b779-901fa0e0371e")
let periphealUUID = CBUUID(string: "4928A4A7-11D7-D3C0-CC0F-EF1772B4AB76")

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    //var manager: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var CBperipherals = [CBPs]()

        override init() {
            super.init()
     
            manager = CBCentralManager(delegate: self, queue: nil)
            manager.delegate = self
        }
 
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
            let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
            let newCBP = CBPs(id: peripherals.count, CBP: peripheral)
            print(newPeripheral)
            peripherals.append(newPeripheral)
            CBperipherals.append(newCBP)
        }
        else {
            if peripheral.identifier.uuidString == periphealUUID.uuidString {
                myPeripheal = peripheral
                myPeripheal?.delegate = self
                // manager?.connect(myPeripheal!, options: nil)
                // manager?.stopScan()
                let newPeripheral = Peripheral(id: peripherals.count, name: "ESP32", rssi: RSSI.intValue)
                print(newPeripheral)
                peripherals.append(newPeripheral)
            }
        }
    }
    func connectTo(peripheralID: Int) -> String {
        manager?.connect(CBperipherals[peripheralID].CBP, options: nil)
        manager?.stopScan()
        myPeripheal = CBperipherals[peripheralID].CBP
        myPeripheal?.delegate = self
        if CBperipherals[peripheralID].CBP.identifier.uuidString == periphealUUID.uuidString {
            return "ESP32";
        } else {
            return peripherals[peripheralID].name;
        }
    }
    func sendText(text: String) {
        if (myPeripheal != nil && myCharacteristic != nil) {
            let data = text.data(using: .utf8)
            myPeripheal!.writeValue(data!,  for: myCharacteristic!, type: CBCharacteristicWriteType.withResponse)
            //myPeripheal!.readValue(for: myCharacteristic!)
        }
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
        switch central.state {
        case .poweredOff:
            print("Bluetooth is switched off")
        case .poweredOn:
            print("Bluetooth is switched on")
        case .unsupported:
            print("Bluetooth is not supported")
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
        print("Connected to " +  peripheral.name!)
        // textView.text = "Connected to " + peripheral.name!
        
        //connectButton.isSelected = false
        // disconnectButton.isEnabled = true
        // sendText1Button.isHidden = false
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from " +  peripheral.name!)
        
        myPeripheal = nil
        myCharacteristic = nil
        
        //connectButton.isEnabled = true
        // disconnectButton.isEnabled = false
        // sendText1Button.isHidden = true
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
    func startScanning() {
         print("startScanning")
         peripherals = [Peripheral]()
         manager.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        manager.stopScan()
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        myCharacteristic = characteristics[0]
        let data = myCharacteristic?.value
    }
}
