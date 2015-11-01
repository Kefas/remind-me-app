//
//  AddNoteViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 28.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

protocol AddNoteViewControllerDelegate : class {
    func addNoteViewController(controller: AddNoteViewController, didEditNote note: NoteDTO)
    func addNoteViewController(controller: AddNoteViewController, didAddNewNote note: NoteDTO)
}


class AddNoteViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var viewControllerAssembly: ViewControllerAssembly?
    var loginModel: LoginRegisterModel?
    var noteModel: NoteModel?
    var delegate: AddNoteViewControllerDelegate?
    var editingNote: NoteDTO?
    
    var startDate: String?
    var endDate: String?
    
    @IBOutlet weak var noteText: THNotesTextView!
    @IBOutlet weak var startEndDatePicker: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.BasicTurquoiseColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if editingNote != nil {
            updateEditingView(editingNote!)
            navigationItem.title = "Edit note"
        }
        else {
            navigationItem.title = "Add new note"
        }
    }


    @IBAction func saveNoteButtonPressed(sender: AnyObject) {
        print(loginModel?.profileDTO.email)
        
        saveDates()
        
        if(editingNote != nil) {
            let note: NoteDTO = NoteDTO(id: editingNote!.id!, content: noteText.text, startDate: startDate!, endDate: endDate!, recurrence: "M", userId: (loginModel?.profileDTO.id)!, beaconsId: 0)
            
            delegate?.addNoteViewController(self, didEditNote: note)
        }
        else {
            let note: NoteDTO = NoteDTO(id: 0, content: noteText.text, startDate: startDate!, endDate: endDate!, recurrence: "M", userId: (loginModel?.profileDTO.id)!, beaconsId: 0)
           delegate?.addNoteViewController(self, didAddNewNote: note)
        }
        
    }
    
    func saveDates() {
        switch(startEndDatePicker.selectedSegmentIndex) {
        case 0:
            startDate = stringDateFromPicker(datePicker)
            break
        case 1:
            endDate = stringDateFromPicker(datePicker)
            break
        default:
            print("error")
            break
        }
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateEditingView(note: NoteDTO) {
        noteText.text = note.content
    }
    
    @IBAction func switchToStartEndDate(sender: AnyObject) {
        
        switch(startEndDatePicker.selectedSegmentIndex) {
        case 0:
          endDate = stringDateFromPicker(datePicker)
          break
        case 1:
             startDate = stringDateFromPicker(datePicker)
             break
        default:
            print("error")
            break
        }
        
    }
    
    func stringDateFromPicker(picker: UIDatePicker) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return formatter.stringFromDate(picker.date)
    }
}
