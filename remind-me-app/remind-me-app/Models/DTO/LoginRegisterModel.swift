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
    var profileDTO: UserProfileDTO!
    var noteModel: NoteModel?
    var beaconModel: BeaconsModel?
    
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
            (error: NSError?, data: NSDictionary?) -> Void in
            if error == nil {
                UICKeyChainStore.setString(password, forKey: "password")
                self.profileDTO = self.processData(data!)
                self.noteModel?.getUsersNotes(self.profileDTO.token, userId: self.profileDTO.id, completion: { (error: NSError?) -> Void in
                    self.beaconModel?.getUsersBeacons(self.profileDTO.token, completion: { (error: NSError?) -> Void in
                        completion(error)
                    })
                })
               
                
                //completion(error)

            } else {
                completion(error)
            }
        }
    }
    
    private func processData(json: NSDictionary) -> UserProfileDTO {
      
        return UserProfileDTO(id: json["id"] as! Int, email: json["mail"] as! String, password: json["password"] as! String, token: json["token"] as! String, firstName: "" , lastName: "" )
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

}
