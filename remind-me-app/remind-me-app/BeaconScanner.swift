//
//  BeaconScanner.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 02.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//


import Foundation
import CoreLocation

@objc protocol BeaconScannerDelegate {
    func updateBeaconLocalization(distance:CLLocationAccuracy)
}

@objc protocol BeaconDelegate {
    func handleNotification(note: NoteDTO, beacon: BeaconDTO, noteModel: NoteModel, userProfile: UserProfileDTO)
}

class BeaconScanner: NSObject {
    let locationManager: CLLocationManager
    var regionsInRange = Set<CLBeaconRegion>()
    var beacons: [BeaconDTO]
    var loginModel: LoginRegisterModel?
    var beaconModel: BeaconsModel?
    var noteModel: NoteModel?
    var beaconDelegate: BeaconScannerDelegate?
    var beaconD: BeaconDelegate?
    var appDelegate: AppDelegate?
    
    init(beacons: [BeaconDTO]) {
        self.locationManager = CLLocationManager()
        self.beacons = beacons
        super.init()
        locationManager.delegate = self
        startMonitoringForRegions()
        beaconD = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
    }
    
    
    private func startMonitoringForRegions() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            for beacon in self.beacons {
                let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: beacon.uuid!)!, identifier: beacon.name!)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                locationManager.startMonitoringForRegion(region)
                locationManager.requestStateForRegion(region)
                locationManager.startRangingBeaconsInRegion(region)
            }
        }
    }
}

extension BeaconScanner: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            switch state {
            case .Inside:
                print("Inside")
                break;
            case .Outside:
                print("Outside")
                break;
            default:
                break;
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startUpdatingLocation()

    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if(UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
            var bgTask = UIBackgroundTaskInvalid
            bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(bgTask)
           })
            let beacon: BeaconDTO = self.findMissingBeacon(region as! CLBeaconRegion)
            self.scheduleNotificationsWithNotes(beacon)
           // self.locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
           
            
            if (bgTask != UIBackgroundTaskInvalid){
                UIApplication.sharedApplication().endBackgroundTask(bgTask);
            }
        }
        
       
    }
    
    func scheduleNotificationsWithNotes(beacon: BeaconDTO) {
        print("In method getting notes by id")
        noteModel?.getNotesByBeaconId((loginModel?.profileDTO.token)!, beaconId: beacon.id!, completion: {
                    (error: NSError?, notes: [NoteDTO]?) -> Void in
                    if(error == nil) {
                        for note: NoteDTO in notes! {
                            self.scheduleLocalNotification(note, beacon: beacon)
                           // self.locationManager.stopUpdatingLocation()
                        }
                    }
                    else {
        
                    }
                })

  
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity == CLProximity.Near || $0.proximity == CLProximity.Immediate}
        
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            let distance = closestBeacon.accuracy
            beaconDelegate?.updateBeaconLocalization(distance)
        }
        
    }
    func findMissingBeacon(region: CLBeaconRegion) -> BeaconDTO {
        for beacondto: BeaconDTO in beaconModel!.userBeacons! {
            if(beacondto.uuid == region.proximityUUID.UUIDString) {
                return beacondto
            }
        }
        return BeaconDTO()
    }
    
    func scheduleLocalNotification(note: NoteDTO, beacon: BeaconDTO) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Remind: \(note.content!)"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "NotificationCategory"
        beaconD?.handleNotification(note, beacon: beacon, noteModel: self.noteModel!, userProfile:(self.loginModel?.profileDTO)!)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}
