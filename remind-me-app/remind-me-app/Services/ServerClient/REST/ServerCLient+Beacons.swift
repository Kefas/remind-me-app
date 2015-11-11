//
//  ServerCLient+Beacons.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 11.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

extension ServerClient {
    
    internal func saveBeacon(name: String, uuid: String, token: String, completion: (NSError?, NSDictionary?) -> Void) {
        let dict = ["beacon": ["name": name, "uuid": uuid]]
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executePOST("/beacons",
            params: dict,
            success: {
                (response) in
                completion(nil, response as? NSDictionary)
            },
            failure: {
                (error) in
                completion(error, nil)
        })
    }
    
    internal func getUserBeacons(token: String, completion: (NSError?, [NSDictionary]?) -> Void) {
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executeGET("/beacons",
            params: nil,
            success: {
                (response) in
                completion(nil, response as? [NSDictionary])
            },
            failure: {
                (error) in
                completion(error, nil)
        })
    }
}
