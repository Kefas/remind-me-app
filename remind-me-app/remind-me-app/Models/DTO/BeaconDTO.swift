//
//  BeaconDTO.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 11.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class BeaconDTO: NSObject {

    var id: Int?
    var name: String?
    var uuid: String?
    
    override init() {
        self.id = 0
        self.name = ""
        self.uuid = ""
    }
    
    init(id: Int, name: String, uuid: String) {
        self.id = id
        self.name = name
        self.uuid = uuid
       
    }
    
}
