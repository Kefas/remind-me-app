//
//  UserProfileDTO.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 28.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class UserProfileDTO {
    
    let id: Int
    let email: String
    let password: String
    let token: String
    let firstName: String
    let lastName: String

    init(id:Int, email: String, password: String, token: String, firstName: String, lastName: String) {
        self.id = id
        self.email = email
        self.password = password
        self.token = token
        self.firstName = firstName
        self.lastName = lastName
    }

}
