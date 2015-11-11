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
    var usersNotes: [NoteDTO]?
    
    init(serverClient: ServerClient) {
        self.serverClient = serverClient
    }
    
    func saveNote(note: NoteDTO,token: String, userId: Int, completion: (NSError?) -> Void) {
        serverClient.saveNote(note, token: token, userId: userId) {
            (error: NSError?, data: NSDictionary?) -> Void in
            if error == nil {
                completion(error)
                self.getUsersNotes(token, userId: userId, completion: { (error: NSError?) -> Void in
                    completion(error)
                })
            } else {
                completion(error)
            }
        }
    }
    
    func getUsersNotes(token: String, userId: Int, completion: (NSError?) -> Void) {
        serverClient.getUserNotes(token, userId: userId) {
            (error: NSError?, data: [NSDictionary]?) -> Void in
            if error == nil {
                self.usersNotes = [NoteDTO]()
                
                for dict: NSDictionary in data! {
                    self.usersNotes?.append(self.processData(dict))
                }
                
                completion(error)
               
            } else {
                completion(error)
            }
        }
    }
    
    private func processData(json: NSDictionary) -> NoteDTO {
        var id: Int?
        var content: String?
        var startDate: String?
        var endDate: String?
        var recurrence: Character?
        var beaconId: Int?
        
        if let noteId = json["id"] as? Int {id = noteId} else {id = 0}
        if let cont = json["content"] as? String {content = cont} else {content = ""}
        if let start = json["date_start"] as? String {startDate = start} else {startDate = ""}
        if let end = json["date_end"] as? String {endDate = end} else {endDate = ""}
        if let recur = json["recurrence"] as? Character {recurrence = recur} else {recurrence = "N"}
        if let beacon = json["beacon_id"] as? Int {beaconId = beacon} else {beaconId = 0}
        
        return NoteDTO(id: id!, content: content!, startDate: startDate!, endDate: endDate!, recurrence: recurrence!, userId: json["user_id"] as! Int, beaconsId: beaconId!)
    }
    
    
    func deleteNote(token: String, userId: Int, noteId: Int,  completion: (NSError?) -> Void) {
        serverClient.deleteNote(token, noteId: noteId) {
            (error: NSError?) -> Void in
            if error == nil {
                self.getUsersNotes(token, userId: userId, completion: { (error: NSError?) -> Void in
                      completion(error)
                })

                
            } else {
                completion(error)
            }
        }
    }
    
    func editNote(token: String, userId: Int, note: NoteDTO,  completion: (NSError?) -> Void) {
        let dict: NSDictionary = createDictionaryFromNote(note)
        
        serverClient.editNote(token, noteId: note.id!, params: dict) {
            (error: NSError?) -> Void in
            if error == nil {
                completion(error)
                self.getUsersNotes(token, userId: userId, completion: { (error: NSError?) -> Void in
                    completion(error)
                })
                
            } else {
                completion(error)
            }
            
        }
    }

    func createDictionaryFromNote(note: NoteDTO) -> NSDictionary {
        return ["remind": [
            "id": note.id!,
            "content": note.content!,
            "date_start": note.startDate!,
            "date_end": note.endDate!,
            "recurrence": String(note.recurrence!),
            "beacon_id": note.beaconsId!
            ]
        ]
    }
    
    func getNotesByBeaconId(token: String, beaconId: Int, completion: (NSError?, [NoteDTO]?) -> Void) {
        serverClient.getNoteById(token, beaconId: beaconId) {
            (error: NSError?, dict:[NSDictionary]?) -> Void in
            if(error == nil) {
                
                var notesById: [NoteDTO]? = [NoteDTO]()
                
                for d: NSDictionary in dict! {
                    notesById?.append(self.processData(d))
                }
                completion(nil,notesById)
            }
            else {
                completion(error, nil)
            }
           
        }
    }
}
