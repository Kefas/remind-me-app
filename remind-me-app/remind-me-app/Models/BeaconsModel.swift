//
//  BeaconsModel.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 11.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class BeaconsModel: NSObject {

    let serverClient: ServerClient
    var userBeacons: [BeaconDTO]?
    
    init(serverClient: ServerClient) {
        self.serverClient = serverClient
    }
    
  
    func saveBeacon(name: String, uuid: String, token: String, completion: (NSError?) -> Void) {
        serverClient.saveBeacon(name, uuid: uuid, token: token) { (error: NSError?, data: NSDictionary?) -> Void in
            if error == nil {
                self.getUsersBeacons(token, completion: { (error: NSError?) -> Void in
                    completion(error)
                })
            } else {
                completion(error)
            }

        }
    }
    
    
    func getUsersBeacons(token: String, completion: (NSError?) -> Void) {
        serverClient.getUserBeacons(token) {
            (error: NSError?, data: [NSDictionary]?) -> Void in
            if error == nil {
                self.userBeacons = [BeaconDTO]()
                
                for dict: NSDictionary in data! {
                    self.userBeacons?.append(self.processData(dict))
                }
                
                completion(error)
                
            } else {
                completion(error)
            }
        }
    }
    
    private func processData(json: NSDictionary) -> BeaconDTO {
        var id: Int?
        var name: String?
        var uuid: String?
    
        
        if let beaconId = json["id"] as? Int {id = beaconId} else {id = 0}
        if let n = json["name"] as? String {name = n} else {name = ""}
        if let uid = json["uuid"] as? String {uuid = uid} else {uuid = ""}
        
        return BeaconDTO(id: id!, name: name!, uuid: uuid!)
    }
}
