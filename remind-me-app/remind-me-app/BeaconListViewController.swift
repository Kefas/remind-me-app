//
//  BeaconListViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 02.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

enum BeaconSearchState {
    case BluetoothOff
    case BluetoothNotSupported
    case BluetoothOn
//    case NoBeaconsFound
//    case BeaconsFound
}

class BeaconListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    
    let locationManager = CLLocationManager()
    var beaconRegion: CLBeaconRegion?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bluetoothLabel: UILabel!
    @IBOutlet weak var bluetoothImage: UIImageView!
    
    var distance: CLLocationAccuracy = 0.00
    
    var beaconSearchState: BeaconSearchState = .BluetoothOff {
        didSet {
            updateViewWithCurrentState()
        }
    }
    
    var bluetoothManager: CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E")!, identifier: "Kontakt")
        
        locationManager.requestAlwaysAuthorization()
        self.beaconRegion!.notifyOnExit = true
        self.beaconRegion!.notifyOnEntry = true
        
        self.beaconRegion!.notifyEntryStateOnDisplay = true
        locationManager.startMonitoringForRegion( self.beaconRegion!)
        
        setupTableView()
        
        updateViewWithCurrentState()
        let bluetoothOptions = [CBCentralManagerOptionShowPowerAlertKey: false]
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: bluetoothOptions)
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.registerNib(UINib(nibName: "BeaconTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalConstants.Identifiers.BeaconCellId)
    }
    
    private func updateViewWithCurrentState() {
        
        switch beaconSearchState {
            
        case .BluetoothNotSupported:
           bluetoothImage.image = UIImage(named: "bluetoothOff")
            bluetoothLabel.text = "Bluetooth is off!"
        break
        case .BluetoothOn:
            bluetoothImage.image = UIImage(named: "bluetoothOn")
            bluetoothLabel.text = "Bluetooth is on!"
            break
        default:
            bluetoothImage.image = UIImage(named: "bluetoothOff")
            bluetoothLabel.text = "Bluetooth is off!"
            break
        }
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        updateBluetoothSearchState(state: central.state)
    }

    private func updateBluetoothSearchState(state state:CBCentralManagerState) {
        switch (state) {
            
        case .PoweredOn:
            bluetoothImage.image = UIImage(named: "bluetoothOn")
            bluetoothLabel.text = "Bluetooth is on!"
            break
        case .Unauthorized, .Unsupported:
            beaconSearchState = .BluetoothNotSupported
            break
        default:
            beaconSearchState = .BluetoothOff
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.BeaconCellId) as! BeaconTableViewCell
        cell.nameLabel.text = "Name: Kontakt.io"
        cell.uuidLabel.text = "UUID: F7826DA6-4FA2-4E98-8024-BC5B71E0893E"
        cell.distanceLabel.text = String(format: "%.2f", arguments: [distance])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.locationManager.requestStateForRegion(self.beaconRegion!)
        
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == .Inside {
            manager.startRangingBeaconsInRegion(self.beaconRegion!)
        }
        else {
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity == CLProximity.Near || $0.proximity == CLProximity.Immediate}
        //      let farBeacon = beacons.filter{$0.proximity == CLProximity.Far}
        
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
                distance = closestBeacon.accuracy
                tableView.reloadData()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        //if(region.isKindOfClass(CLBeacon.self)) {
        self.locationManager.stopRangingBeaconsInRegion(self.beaconRegion!)
        self.locationManager.stopUpdatingLocation()
        self.scheduleLocalNotification()
        //self.sendL
        //}
    }
    
    func scheduleLocalNotification() {
        var localNotification = UILocalNotification()
        localNotification.alertBody = "Hey, you must go shopping, remember?"
        localNotification.alertAction = "View List"
        //   localNotification.fireDate = NSDate()
        // localNotification.category = "shoppingListReminderCategory"
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}
