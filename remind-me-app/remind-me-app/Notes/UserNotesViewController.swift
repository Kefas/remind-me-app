//
//  UserNotesViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 29.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class UserNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNoteViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var viewControllerAssembly: ViewControllerAssembly?
    var loginModel: LoginRegisterModel?
    var noteModel: NoteModel?
    var leftBarButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.BasicTurquoiseColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        setupTableView()
        setupEditButton()
    }
    
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.registerNib(UINib(nibName: "UserNotesTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalConstants.Identifiers.UsersNotesId)
        tableView.allowsSelectionDuringEditing = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let note = noteModel!.usersNotes![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(GlobalConstants.Identifiers.UsersNotesId, forIndexPath: indexPath) as! UserNotesTableViewCell
        cell.setupWithNote(note)
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteModel!.usersNotes!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let note : NoteDTO = noteModel!.usersNotes![indexPath.row]
        
        if(editing) {
            let controller: AddNoteViewController = self.viewControllerAssembly?.addNoteViewController() as! AddNoteViewController
            controller.delegate = self
            controller.editingNote = note
            let nv = UINavigationController(rootViewController: controller)
            self.showViewController(nv, sender: nil)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
        self.navigationItem.setLeftBarButtonItem(editing ? UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewItem") : self.leftBarButtonItem, animated: true)
    }
    
    func addNewItem() {
        let controller: AddNoteViewController = self.viewControllerAssembly?.addNoteViewController() as! AddNoteViewController
        controller.delegate = self
        let nv = UINavigationController(rootViewController: controller)
        self.showViewController(nv, sender: nil)
    }

    func addNoteViewController(controller: AddNoteViewController, didAddNewNote note: NoteDTO) {
        noteModel?.saveNote(note, token: (loginModel?.profileDTO.token)!,userId: (loginModel?.profileDTO.id)! , completion: { (error: NSError?) -> Void in
            if(error != nil) {
                
            }
            else {
                print("Note saved")
                self.endEditingAndReload(controller)
            }
        })
    }
    
    
    func addNoteViewController(controller: AddNoteViewController, didEditNote note: NoteDTO) {
        noteModel?.editNote(loginModel!.profileDTO!.token, userId: loginModel!.profileDTO!.id, note: note, completion: { (error: NSError?) -> Void in
            if(error != nil) {
                
            }
            else {
                print("Note changed")
                self.endEditingAndReload(controller)
            }
        })
    }
   
    func endEditingAndReload(controller: AddNoteViewController) {
        self.setEditing(false, animated: true)
        self.tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let note = (noteModel?.usersNotes![indexPath.row])! as NoteDTO
            noteModel?.deleteNote((loginModel?.profileDTO.token)!, userId: (loginModel?.profileDTO.id)!, noteId: note.id!, completion: { (error: NSError?) -> Void in
                if(error == nil) {
                    tableView.beginUpdates()
                     self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    //tableView.reloadData()
                    tableView.endUpdates()
                }
            })
        }
    }

}
