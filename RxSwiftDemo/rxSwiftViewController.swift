//
//  rxSwiftViewController.swift
//  RxSwiftDemo
//
//  Created by Gaurav Oka on 11/30/17.
//  Copyright © 2017 Gaurav Oka. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift
import RxBluetoothKit

enum DeviceInfoService: String, ServiceIdentifier {
    case deviceInformation = "180A"
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }
}

enum DeviceInfoCharacteristic: String, CharacteristicIdentifier {
    case manufacturerName = "2A29"
    case modelNumber = "2A24"
    case hardwareRevision = "2A27"
    case firmwareRevision = "2A26"
    case softwareRevision = "2A28"
    
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }
    //Service to which characteristic belongs
    var service: ServiceIdentifier {
        switch self {
        case .manufacturerName,
             .modelNumber,
             .hardwareRevision,
             .firmwareRevision,
             .softwareRevision:
            return DeviceInfoService.deviceInformation
    }
}
}

enum BatteryService: String, ServiceIdentifier {
    case batteryService = "180F"
    var uuid: CBUUID {
        return CBUUID(string:self.rawValue)
    }
}

enum BatteryCharacteristic: String, CharacteristicIdentifier {
    case batteryLevel = "2A19"
    
    var uuid: CBUUID {
        return CBUUID(string:self.rawValue)
    }
    
    var service: ServiceIdentifier {
        return BatteryService.batteryService
    }
}


class rxSwiftViewController: UIViewController{
    
//    /// Represents serial number of starling
//    private(set) public var serialNumber: String!
//    /// Represents RxPeripheral of discoverd starling
//    private(set) public var rxPeripheral: Peripheral!
//    /// Represents RSSI of starling
//    public var rssi: Int!
//    private(set) public var batteryLevel: Int!
//    private var connectionStateDisposable:Disposable?
//    private var batteryCharacteristicDisposable:Disposable?
//    private var batteryNotifyDiposable:Disposable?
//    private var batteryMonitorDisposable:Disposable?
    
    private let disposeBag = DisposeBag()
    let manager = BluetoothManager(queue:.main,options: [CBCentralManagerOptionRestoreIdentifierKey:"SMARTPLUS" as AnyObject])
    let CB_NAME = ("Starling")
    var strname:String = " "
    var strper:String = " "
    
    var lblblestatus = UILabel()
    var lbldeviceInfo = UILabel()
    var txtdeviceinfo = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor .white
        
        
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
        
        //MARK :- txtdeviceinfo
        txtdeviceinfo.textColor = UIColor .black
        txtdeviceinfo.font = UIFont .systemFont(ofSize: 15.0)
        txtdeviceinfo.layer.borderWidth = 1
        view.addSubview(txtdeviceinfo)
        txtdeviceinfo.snp.makeConstraints{(make)in
            make.top.equalTo(view).offset(100)
            make.left.equalTo(view).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(100)
        }
        
        //MARK:- lbldeviceInfo
//        lbldeviceInfo.textColor = UIColor .black
//        lbldeviceInfo.font = UIFont .systemFont(ofSize: 15.0)
//        lbldeviceInfo.lineBreakMode = .byWordWrapping
//        lbldeviceInfo.numberOfLines = 10
//        lbldeviceInfo.text = "Device information"
//        view.addSubview(lbldeviceInfo)
//        lbldeviceInfo.snp.makeConstraints{(make) in
//            make.top.equalTo(lblblestatus.snp.bottom).offset(50)
//            make.centerX.equalTo(view)
//            make.width.equalTo(self.view).multipliedBy(0.75)
//            make.height.equalTo(60)
//        }
       
       //**RxBluetoothKit Observable**\\
        
//        manager.rx_state
//            .filter { $0 == .poweredOn }
//            .take(1)
//            .flatMap { _ in self.manager.scanForPeripherals(withServices: nil) }
//            .filter { $0.peripheral.name == self.CB_NAME}.take(1)
//            .flatMap { $0.peripheral.connect() }
//            //.map {_ in self.peripheral.name }
//            .subscribe(onNext: { peripheral in
//                if let peripheralName = peripheral.name {
//                print("Connected to : \(peripheralName)")
//                    self.lbldeviceInfo.text = peripheral.name
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: DeviceInfoCharacteristic.manufacturerName)}
//                        .subscribe(onNext:{
//                            let data = $0.value
//                            if let strdata = String(data: data!, encoding: .utf8){
//                                print("Manufacturer Name is :\(strdata)")
//                                self.strname += "Manufacturer Names is: "
//                                self.strname += strdata
//                            }
//                        }).disposed(by: self.disposeBag)
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: DeviceInfoCharacteristic.firmwareRevision)}
//                        .subscribe(onNext:{
//                            let data = $0.value
//                            if let strdata = String(data: data!, encoding: .utf8){
//                                print("Firmware Revision is :\(strdata)")
//                                   self.strname += " \n "
//                                   self.strname += "Firmware Revision is : "
//                                   self.strname += strdata
//
//                            }
//                        }).disposed(by: self.disposeBag)
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: DeviceInfoCharacteristic.hardwareRevision)}
//                        .subscribe(onNext:{
//                            let data = $0.value
//                            if let strdata = String(data: data!, encoding: .utf8){
//                                print("Hardware Revision is :\(strdata)")
//                                self.strname += " \n "
//                                self.strname += " Hardware Revision is : "
//                                self.strname += strdata
//                            }
//                        }).disposed(by: self.disposeBag)
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: DeviceInfoCharacteristic.modelNumber)}
//                        .subscribe(onNext:{
//                            let data = $0.value
//                            if let strdata = String(data: data!, encoding: .utf8){
//                                print("Model Number is :\(strdata)")
//
//                                self.strname += " \n "
//                                self.strname += "Model Number is : "
//                                self.strname += strdata
//                            }
//                        }).disposed(by: self.disposeBag)
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: DeviceInfoCharacteristic.softwareRevision)}
//                        .subscribe(onNext:{
//                            let data = $0.value
//                            if let strdata = String(data: data!, encoding: .utf8){
//                                print("Software Revision is :\(strdata)")
//
//                                self.strname += " \n "
//                                self.strname += "Software Revision is : "
//                                self.strname += strdata
//                            }
//                        }).disposed(by: self.disposeBag)
//
//                    peripheral.connect()
//                        .flatMap{$0.readValue(for: BatteryCharacteristic.batteryLevel)}
//                        .subscribe(onNext: {
//                            let data = $0.value
//                            if let strdata = (data?.first){
//                                print("percentage is :\(strdata) %")
//                                self.strper += "Battery Percentage is : "
//                                self.strper += String(strdata)
//
//                                self.lblblestatus.text = self.strper
//                                self.lbldeviceInfo.text = self.strname
//                                self.txtdeviceinfo.text = self.strname
//                             }
//                        }).disposed(by: self.disposeBag)
//
//                }
//
//            }).disposed(by: self.disposeBag)

        

        
        manager.rx_state
            .filter { $0 == .poweredOn }
            .take(1)
            .flatMap { _ in self.manager.scanForPeripherals(withServices: nil) }
            .filter { $0.peripheral.name == self.CB_NAME}.take(1)
            .flatMap { $0.peripheral.connect() }
            .subscribe(onNext: {peripheral in

                if let peripheralName = peripheral.name {
                    print("Connected to : \(peripheralName)")
                   // self.lbldeviceInfo.text = peripheral.name
                    peripheral.connect()
                        .flatMap({ (_)  in
                        peripheral.readValue(for: DeviceInfoCharacteristic.manufacturerName)
                        })
                        .map({ (characteristic) in
                            let data = characteristic.value
                            if let data = data {
                                if let manufacturerName = String(data: data, encoding: .utf8) {
                                    print("Manufacturer Name is : \(manufacturerName)")
                                    self.strname += "Manufacturer Names is: "
                                    self.strname += manufacturerName
                                }
                            }
                        })
                        .flatMap({(_) in
                            peripheral.readValue(for: DeviceInfoCharacteristic.firmwareRevision)
                        })
                        .map({(Characteristic) in
                            let data = Characteristic.value
                            if let data = data {
                                if let firmwareName = String(data: data, encoding: .utf8) {
                                    print("firmware  Name is : \(firmwareName)")
                                    self.strname += " \n "
                                    self.strname += "Firmware Names is: "
                                    self.strname += firmwareName
                                }
                            }
                        })
                        .flatMap({(_) in
                            peripheral.readValue(for: DeviceInfoCharacteristic.hardwareRevision)
                        })
                        .map({(Characteristic) in
                            let data = Characteristic.value
                            if let data = data {
                                if let hardwareName = String(data: data, encoding: .utf8) {
                                    print("firmware  Name is : \(hardwareName)")
                                    self.strname += " \n "
                                    self.strname += "Hardware Names is: "
                                    self.strname += hardwareName
                                }
                            }
                        })
                        .flatMap({(_) in
                            peripheral.readValue(for: DeviceInfoCharacteristic.modelNumber)
                        })
                        .map({(Characteristic) in
                            let data = Characteristic.value
                            if let data = data {
                                if let modelNo = String(data: data, encoding: .utf8) {
                                    print("Model Number is : \(modelNo)")
                                    self.strname += " \n "
                                    self.strname += "Model Number is: "
                                    self.strname += modelNo
                                }
                            }
                        })
                        .flatMap({(_) in
                            peripheral.readValue(for: DeviceInfoCharacteristic.softwareRevision)
                        })
                        .map({(Characteristic) in
                            let data = Characteristic.value
                            if let data = data {
                                if let softwareRevision = String(data: data, encoding: .utf8) {
                                    print("firmware  Name is : \(softwareRevision)")
                                    self.strname += " \n "
                                    self.strname += "Software Revision is: "
                                    self.strname += softwareRevision
                                }
                            }
                        })
                        .flatMap({(_) in
                            peripheral.readValue(for: BatteryCharacteristic.batteryLevel)
                        })
                        .map({(Characteristic) in
                            let data = Characteristic.value
                            if let strdata = (data?.first){
                                print("percentage is :\(strdata) %")
                                self.strname += " \n "
                                self.strper += "Battery Percentage is : "
                                self.strper += String(strdata)
                                
                                self.lblblestatus.text = self.strper
                                //self.lbldeviceInfo.text = self.strname
                                self.txtdeviceinfo.text = self.strname
                            }
                        })
                        .subscribe(onNext:{ (_) in
                        
                        }).disposed(by: self.disposeBag)
                }
            })
        
    }//viewDidLoad() #End
}
