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
    let email: String
    let password: String
    let token: String?
    
    init(id:Int, email: String, password: String, token: String ) {
        self.id = id
        self.email = email
        self.password = password
        self.token = token
    }

}
