//
//  LoginRegisterModel.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class LoginRegisterModel: NSObject {

  let serverClient: ServerClient

    init(serverClient: ServerClient) {
        self.serverClient = serverClient
    }
    
    func registerUser(registerData: RegisterUserDTO, completion: (NSError?) -> Void) {
        serverClient.register(registerData.email, password: registerData.password) {
            (error: NSError?) -> Void in
            self.loginUser(email: registerData.email, password: registerData.password, completion: completion)
        }
    }
    
    func loginUser(email email: String, password: String, completion: (NSError?) -> Void) {
        serverClient.login(email: email, password: password) {
            (error: NSError?) -> Void in
            if error == nil {
                UICKeyChainStore.setString(password, forKey: "password")
                completion(error)

            } else {
                completion(error)
            }
        }
    }
}
