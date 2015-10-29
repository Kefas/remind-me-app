//
//  NoteModel.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 29.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class NoteModel: NSObject {

    let serverClient: ServerClient
    
    init(serverClient: ServerClient) {
        self.serverClient = serverClient
    }
    
    func saveNote(note: NoteDTO,token: String, userId: Int, completion: (NSError?) -> Void) {
        serverClient.saveNote(note, token: token, userId: userId) {
            (error: NSError?, data: NSDictionary?) -> Void in
            if error == nil {
                completion(error)
                print(data)
                //fetch notes 
            } else {
                completion(error)
            }
        }
    }
}
