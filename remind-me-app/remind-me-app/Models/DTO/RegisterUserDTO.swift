//
//  RegisterUserDTO.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class RegisterUserDTO {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String
    let password: String
    
    init(id:Int, firstName: String, lastName: String, email: String, password: String ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }

}
