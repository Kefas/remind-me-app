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

@objc protocol BeaconListViewControllerDelegate {
     func beaconListViewController(controller: BeaconListViewController, didChooseBeacon beacon: BeaconDTO)
}

class BeaconListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, AddBeaconViewDelegate {
    
    let locationManager = CLLocationManager()
    var beaconRegion: CLBeaconRegion?
    
    var loginModel: LoginRegisterModel?
    var beaconModel: BeaconsModel?
    var noteModel: NoteModel?
    
    var leftBarButtonItem: UIBarButtonItem?
    var viewControllerAssembly: ViewControllerAssembly?
    var delegate: BeaconListViewControllerDelegate?
    
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
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        setupUpdatingLocations()
        setupTableView()
        
        updateViewWithCurrentState()
        let bluetoothOptions = [CBCentralManagerOptionShowPowerAlertKey: false]
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: bluetoothOptions)
        
        setupEditButton()
    }
    
    func setupUpdatingLocations() {
        for beacon: BeaconDTO in (beaconModel?.userBeacons)! {
            let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: beacon.uuid!)!, identifier: beacon.name!)
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            region.notifyEntryStateOnDisplay = true
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.registerNib(UINib(nibName: "BeaconTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalConstants.Identifiers.BeaconCellId)
        tableView.allowsSelectionDuringEditing = true
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
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
        self.navigationItem.setLeftBarButtonItem(editing ? UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewItem") : self.leftBarButtonItem, animated: true)
    }
    
    func addNewItem() {
        let addBeaconView: AddBeaconAlertView = viewControllerAssembly?.addBeaconAlertView() as! AddBeaconAlertView
        addBeaconView.delegate = self
        let nv = UINavigationController(rootViewController: addBeaconView)
        self.showViewController(nv, sender: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let beacons = beaconModel?.userBeacons {
            return beacons.count
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let beacon: BeaconDTO = (beaconModel?.userBeacons![indexPath.row])!
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.BeaconCellId) as! BeaconTableViewCell
        cell.setupWithBeacon(beacon)
        cell.distanceLabel.text = String(format: "%.2f", arguments: [distance])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let beacon: BeaconDTO = (beaconModel?.userBeacons![indexPath.row])!
        delegate?.beaconListViewController(self, didChooseBeacon: beacon)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            let note = (beaconModel?.userBeacons![indexPath.row])! as BeaconDTO
//            beaconModel?.deleteNote((loginModel?.profileDTO.token)!, userId: (loginModel?.profileDTO.id)!, noteId: note.id!, completion: { (error: NSError?) -> Void in
//                if(error == nil) {
//                    tableView.beginUpdates()
//                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                    tableView.endUpdates()
//                }
//            })
//        }
    }
    
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.locationManager.requestStateForRegion(region as! CLBeaconRegion)
        
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == .Inside {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
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
    
        let beacon: BeaconDTO = findMissingBeacon(region as! CLBeaconRegion)
        scheduleNotificationsWithNotes(beacon)
        self.locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        self.locationManager.stopUpdatingLocation()
    }
    
    func scheduleNotificationsWithNotes(beacon: BeaconDTO) {
        print("In method getting notes by id")
        noteModel?.getNotesByBeaconId((loginModel?.profileDTO.token)!, beaconId: beacon.id!, completion: {
            (error: NSError?, notes: [NoteDTO]?) -> Void in
            if(error == nil) {
                for note: NoteDTO in notes! {
                    self.scheduleLocalNotification(note)
                   
                }
            }
            else {
                
            }
        })
    }
    
    
    func findMissingBeacon(region: CLBeaconRegion) -> BeaconDTO {
        for beacondto: BeaconDTO in beaconModel!.userBeacons! {
            if(beacondto.uuid == region.proximityUUID.UUIDString) {
                return beacondto
            }
        }
        return BeaconDTO()
    }
    
    func scheduleLocalNotification(note: NoteDTO) {
        var localNotification = UILocalNotification()
        localNotification.alertBody = "Remind: \(note.content!)"
       // localNotification.alertAction = "View List"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

    func addBeacon(view: AddBeaconAlertView, name: String, uuid: String) {
        let beaconName = name
        let beaconUUID = uuid
    
        beaconModel?.saveBeacon(beaconName, uuid: beaconUUID, token: (loginModel?.profileDTO.token)!, completion: { (error: NSError?) -> Void in
            if(error == nil) {
                self.tableView.reloadData()
                self.setupUpdatingLocations()
                view.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                
            }
        })
    }
    
}
