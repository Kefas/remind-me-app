//
//  ServiceClient+Notes.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 29.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

extension ServerClient {
    
    internal func saveNote(note: NoteDTO, token: String, userId: Int, completion: (NSError?, NSDictionary?) -> Void) {
        let dict = ["remind": ["content": note.content!, "date_start": note.startDate!, "date_end": note.endDate!, "user_id": userId, "beacon_id": note.beaconsId!]]
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executePOST("/reminds",
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
    
    internal func getUserNotes(token: String, userId: Int, completion: (NSError?, [NSDictionary]?) -> Void) {
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executeGET("/reminds/users/\(userId)",
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
    
    internal func deleteNote(token: String, noteId: Int, completion: (NSError?) -> Void) {
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executeDELETE("/reminds/\(noteId)",
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

    internal func editNote(token: String, noteId: Int, params: NSDictionary, completion: (NSError?) -> Void) {
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executePUT("/reminds/\(noteId)",
            params: params,
            success: {
                (response) in
                completion(nil)
            },
            failure: {
                (error) in
                completion(error)
        })
    }
    
    internal func getNoteById(token: String, beaconId: Int, completion: (NSError?, [NSDictionary]?) -> Void) {
       // var backgroundConf = NSURLSessionConfiguration()
      //  backgroundConf.backgroundSessionConfigurationWithIdentifier("background")
        
        httpClient.requestSerializer.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        executeGET("/reminds/beacons/active/\(beaconId)", params: nil,
            success:  {
                (response) in
                print(response)
                completion(nil, response as? [NSDictionary])
            },
            failure: {
                (error) in
                completion(error,nil)
        })
    }
    
}
