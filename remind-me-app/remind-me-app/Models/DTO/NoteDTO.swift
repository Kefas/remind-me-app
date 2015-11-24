//
//  NoteDTO.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 29.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class NoteDTO: NSObject {
    
    
    let id: Int?
    let content: String?
    let startDate: String?
    let endDate: String?
    let recurrence: Character?
    let userId: Int?
    let beaconsId: Int?
    
    init(id: Int, content: String, startDate: String, endDate: String, recurrence: Character?, userId: Int, beaconsId: Int) {
        self.id = id
        self.content = content
        self.startDate = startDate
        self.endDate = endDate
        self.recurrence = recurrence
        self.userId = userId
        self.beaconsId = beaconsId
    }
    
    
}
