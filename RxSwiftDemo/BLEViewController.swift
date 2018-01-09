//
//  BLEViewController.swift
//  RxSwiftDemo
//
//  Created by Gaurav Oka on 11/22/17.
//  Copyright © 2017 Gaurav Oka. All rights reserved.
//

import UIKit
import CoreBluetooth


class BLEViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate  {
    
    //MARK:- Declare Manager and Peripheral
     
    var manager: CBCentralManager!
    var miband: CBPeripheral!
    let serialQueue = DispatchQueue(label: "com.versame.bluetooth.\(type(of: self))")
    let CB_NAME = ("Starling")
    
    var lblblestatus = UILabel()
    var lbldeviceInfo = UILabel()
    var strname:String = ""
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    //MARK:- Scan for devices
        var consoleMsg = ""
        switch (central.state)
        {
        case.poweredOff:
            consoleMsg = "BLE is Powered Off"
           lblblestatus.text = "BLE is Powered Off"
        case.poweredOn:
            consoleMsg = "BLE is Powered On"
           // manager.scanForPeripherals(withServices: [SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
           manager.scanForPeripherals(withServices: nil, options: nil)
            consoleMsg = "Power On - Scanning for peripherals"
            lblblestatus.text = "Power On - Scanning for peripherals"
        case.resetting:
            consoleMsg = "BLE is resetting"
            lblblestatus.text = "BLE is resetting"
        case.unknown:
            consoleMsg = "BLE is in an unknown state"
           lblblestatus.text = "BLE is in an unknown state"
        case.unsupported:
            consoleMsg = "This device is not supported by BLE"
           lblblestatus.text = "This device is not supported by BLE"
        case.unauthorized:
            consoleMsg = "BLE is not authorised"
           lblblestatus.text = "BLE is not authorised"
        }
        print("\(consoleMsg)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor .lightGray
        
        //MARK :- Instantiate Manager
        manager = CBCentralManager(delegate: self, queue: nil)
        
        //MARK :- lblblestatus
        lblblestatus.textColor = UIColor .black
        lblblestatus.font = UIFont .systemFont(ofSize: 15.0)
        lblblestatus.lineBreakMode = .byWordWrapping
        lblblestatus.numberOfLines = 0
        view.addSubview(lblblestatus)
        lblblestatus.snp.makeConstraints{(make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(60)
        }
        
        //MARK:- lbldeviceInfo
        lbldeviceInfo.textColor = UIColor .black
        lbldeviceInfo.font = UIFont .systemFont(ofSize: 15.0)
        lbldeviceInfo.lineBreakMode = .byWordWrapping
        lbldeviceInfo.numberOfLines = 0
        lbldeviceInfo.text = "Device information"
        view.addSubview(lbldeviceInfo)
        lbldeviceInfo.snp.makeConstraints{(make) in
            make.top.equalTo(lblblestatus.snp.bottom).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(self.view).multipliedBy(0.75)
            make.height.equalTo(60)
            
        }
    }
    
    //MARK:- Get Device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
       if peripheral.name == CB_NAME
       {
               if let peripheral_name = peripheral.name
               {
                    print("Peripheral Bluetooth name is: ",peripheral_name)
                    lblblestatus.text = ("Peripheral Bluetooth name is: \(String(describing: peripheral.name))")
               }
        self.miband = peripheral
        manager.connect(miband, options: nil)
        manager.stopScan()
       }else{
        if let p_name = peripheral.name{
        print("discovered device:",p_name)
        }
        print("Scanning Device")
        }
    }
    
    //MARK:- Connect to device
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        if let pphl_name = peripheral.name{
            print("did connect peripheral : ",pphl_name)
            lblblestatus.text = "did connect peripheral"
        }
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    //MARK:- Get Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        print("did discover services part")
        lblblestatus.text = "did discover services part"
        if let servicePeripherals = peripheral.services as [CBService]!
        {
              let service = servicePeripherals[1]
              peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        print("did discover charcteristics")
        lblblestatus.text = "did discover charcteristics"
        if let characterArray = service.characteristics as [CBCharacteristic]!
        {
            for cc in characterArray
            {
                    print ("discovered some characteristic")
                    peripheral.readValue(for: cc)
                    peripheral.setNotifyValue(true, for: cc)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil
        {
            print("Error changing notification state: ",error?.localizedDescription as Any)
        }
        if characteristic.isNotifying
        {
            print("Notification Began on :",characteristic)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if error != nil
        {
            print("Error reading characteristic:", error?.localizedDescription as Any)
        }
        
        if characteristic.value != nil
        {
            if let batteryVal = characteristic.value{
            if let batteryPer = batteryVal.first{
                print("Battery Percentage: ",batteryPer)
                    lblblestatus.text = String(format: "Battery percentage is: %d", batteryPer)
                }
            }
        }

        
//        if let data = characteristic.value {
//            if let prop = String(data: data, encoding: .utf8) {
//               strname += String(prop)
//                strname += ", "
//                print(strname)
//                }
//            lbldeviceInfo.text = strname
//        }
        
    }
}
