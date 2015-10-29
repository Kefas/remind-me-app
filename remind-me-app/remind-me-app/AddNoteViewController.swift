//
//  AddNoteViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 28.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var viewControllerAssembly: ViewControllerAssembly?
    var loginModel: LoginRegisterModel?
    var noteModel: NoteModel?
    
    @IBOutlet weak var noteText: THNotesTextView!
    @IBOutlet weak var startEndDatePicker: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.BasicTurquoiseColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }


    @IBAction func saveNoteButtonPressed(sender: AnyObject) {
        print(loginModel?.profileDTO.email)
        let note: NoteDTO = NoteDTO(id: 0, content: noteText.text, startDate: "", endDate: "", recurrence: "M", userId: (loginModel?.profileDTO.id)!, beaconsId: 0)
        
        noteModel?.saveNote(note, token: (loginModel?.profileDTO.token)!,userId: (loginModel?.profileDTO.id)! , completion: { (error: NSError?) -> Void in
            if(error != nil) {
                
            }
            else {
                print("Note saved")
            }
        })
    }
    
}
