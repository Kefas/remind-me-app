//
//  UserNotesTableViewCell.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 31.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class UserNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteContent: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var postponeLabel: UILabel!
    @IBOutlet weak var beaconLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setupWithNote(note: NoteDTO) {
        noteContent.text = note.content!
        startDateLabel.text = "start date: \(note.startDate!)"
        endDateLabel.text = "enda date: \(note.endDate!)"
        postponeLabel.text = String(note.recurrence!)
        beaconLabel.text = "beacon id: \(String(note.beaconsId!))"
    }
}
