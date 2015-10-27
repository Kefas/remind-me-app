//
//  ServerClient+Login.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

extension ServerClient {
    
    internal func register(mail: String, password: String, completion: (NSError?) -> Void) {
        executePOST("/users",
            params: ["mail": mail, "password": password], success: {
                (response) in
                completion(nil)
            }, failure: {
                (error) in
                    completion(error)
            }
        )
    }
    
    internal func login(email  email: String, password: String, completion: (NSError?) -> Void) {
        executePOST("/users/login",
            params: ["email": email, "password": password],
            success: {
                (response) in
                completion(nil)
            },
            failure: {
                (error) in
                completion(error)
        })
    }
    
    internal func logout(completion: (NSError?) -> Void) {
        executePOST("/users/logout",
            params: nil,
            success: {
                (response) in
                completion(nil)
            },
            failure: {
                (error) in
                completion(error)
        })
    }

}
