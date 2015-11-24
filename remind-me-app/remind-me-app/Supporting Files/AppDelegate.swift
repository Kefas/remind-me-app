//
//  AppDelegate.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BeaconDelegate {

    var window: UIWindow?
    var noteModel: NoteModel?
    var note: NoteDTO?
    var profileDTO :UserProfileDTO?
    var beacon: BeaconDTO?
    var noteViewController: UserNotesViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLocalNotification()
        return true
    }

    private func setupLocalNotification() {
        let postponeAction = UIMutableUserNotificationAction()
        postponeAction.identifier = "POSTPONE"
        postponeAction.title = "Odłóż na 30 min"
        postponeAction.activationMode = UIUserNotificationActivationMode.Background
        
        let dismissAction = UIMutableUserNotificationAction()
        dismissAction.identifier = "DELETE"
        dismissAction.title = "Usuń"
        dismissAction.activationMode = UIUserNotificationActivationMode.Background
        
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = "NotificationCategory"
        
        counterCategory.setActions([postponeAction, dismissAction], forContext: .Default)
        let settings = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: [counterCategory])
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

    }
    func applicationWillResignActive(application: UIApplication) {    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        print(notificationSettings.types.rawValue)
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification:")
        print(notification.alertBody)
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
       
        if identifier == "POSTPONE" {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy, HH:mm"
            var date: NSDate = formatter.dateFromString(self.note!.startDate!)!
            var endD = formatter.dateFromString(self.note!.endDate!)!
            date = date.dateByAddingTimeInterval(30.0 * 60.0)
            endD = endD.dateByAddingTimeInterval(30.0 * 60.0)
           let f = NSDateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDate = f.stringFromDate(date)
            let endDate = f.stringFromDate(endD)
            
            let modifiedNote = NoteDTO(id: note!.id!, content: note!.content!, startDate: startDate, endDate: endDate, recurrence: "M", userId: profileDTO!.id, beaconsId: beacon!.id!)
            noteModel?.editNote(profileDTO!.token, userId: profileDTO!.id, note: modifiedNote, completion: { (error) -> Void in
                if(error == nil) {
                     self.noteViewController!.tableView.reloadData()
                    print("Postponed")
                }
                else {
                    
                }
            })
        }
        else if identifier == "DELETE" {
            noteModel?.deleteNote(profileDTO!.token, userId: profileDTO!.id, noteId: note!.id!, completion: { (error: NSError?) -> Void in
                if(error == nil) {
                    self.noteViewController!.tableView.reloadData()
                    print("Deleted")
                }
                else {
                    
                }
           })
        }
        
        completionHandler()
    }

    func handleNotification(note: NoteDTO, beacon: BeaconDTO, noteModel: NoteModel, userProfile: UserProfileDTO) {
        self.note = note
        self.beacon = beacon
        self.noteModel = noteModel
        self.profileDTO = userProfile
    }


}

