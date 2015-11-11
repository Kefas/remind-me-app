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


class AddNoteViewController: UIViewController, UIPopoverPresentationControllerDelegate, BeaconListViewControllerDelegate {

    var viewControllerAssembly: ViewControllerAssembly?
    var loginModel: LoginRegisterModel?
    var noteModel: NoteModel?
    var delegate: AddNoteViewControllerDelegate?
    var editingNote: NoteDTO?
    
    var startDate: String?
    var endDate: String?
    
    var beaconDTO: BeaconDTO?
    
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
        if let beacon: BeaconDTO = self.beaconDTO {
            saveDates()
            
            if(editingNote != nil) {
                let note: NoteDTO = NoteDTO(id: editingNote!.id!, content: noteText.text, startDate: startDate!, endDate: endDate!, recurrence: "M", userId: (loginModel?.profileDTO.id)!, beaconsId: beacon.id!)
                
                delegate?.addNoteViewController(self, didEditNote: note)
            }
            else {
                let note: NoteDTO = NoteDTO(id: 0, content: noteText.text, startDate: startDate!, endDate: endDate!, recurrence: "M", userId: (loginModel?.profileDTO.id)!, beaconsId: beacon.id!)
                delegate?.addNoteViewController(self, didAddNewNote: note)
            }
        }
        else {
            let alert = UIAlertView(title: "Please select beacon", message: "Connect note with beacon!", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.stringFromDate(picker.date)
    }

    @IBAction func beaconListButtonPressed(sender: AnyObject) {
        let beaconList: BeaconListViewController = viewControllerAssembly?.beaconListviewController() as! BeaconListViewController
        beaconList.delegate = self
            self.navigationController?.pushViewController(beaconList, animated: true)
    }
    
    func beaconListViewController(controller: BeaconListViewController, didChooseBeacon beacon: BeaconDTO) {
        self.beaconDTO = beacon
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
