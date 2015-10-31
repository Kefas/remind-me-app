//
//  UserNotesViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 29.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class UserNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var viewControllerAssembly: ViewControllerAssembly?
    var loginModel: LoginRegisterModel?
    var noteModel: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.BasicTurquoiseColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.registerNib(UINib(nibName: "UserNotesTableViewCell", bundle: nil), forCellReuseIdentifier: GlobalConstants.Identifiers.UsersNotesId)
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
    
}
