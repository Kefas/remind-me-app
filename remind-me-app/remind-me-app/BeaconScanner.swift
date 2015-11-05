//
//  BeaconScanner.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 02.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//


import Foundation
import CoreLocation

class BeaconScanner: NSObject {
    let UUIDs: [String]
    let locationManager: CLLocationManager
    var regionsInRange = Set<CLBeaconRegion>()
    
    init(UUIDs: [String]) {
        self.locationManager = CLLocationManager()
        self.UUIDs = UUIDs
        super.init()
        locationManager.delegate = self
        startMonitoringForRegions()
    }
    
    private func startMonitoringForRegions() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            for uuid in UUIDs {
                let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid)!, identifier: "AGH.remind-me-app")
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
                regionsInRange.insert(beaconRegion)
                postBeaconsInRangeNotification()
            case .Outside:
                regionsInRange.remove(beaconRegion)
                postBeaconsInRangeNotification()
            default:
                break;
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        addRegionAndNotify(region: region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        removeRegionAndNotify(region: region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        postBeaconsDidRangeNotification(beacons: beacons)
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        removeRegionAndNotify(region: region)
    }
    
    private func addRegionAndNotify(region region:CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            regionsInRange.insert(beaconRegion)
            postBeaconsInRangeNotification()
        }
    }
    
    private func removeRegionAndNotify(region region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            regionsInRange.remove(beaconRegion)
            postBeaconsInRangeNotification()
        }
    }
    
    func postBeaconsDidRangeNotification(beacons beacons:[CLBeacon]) {
        let userInfo = ["beacons": beacons]
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.NotificationNames.DidRangeBeacons, object: self, userInfo: userInfo)
    }
    
    func postBeaconsInRangeNotification() {
        let userInfo = ["regions": regionsInRange]
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.NotificationNames.BeaconsInRange, object: self, userInfo: userInfo)
    }
}
