//
//  BeaconTableViewCell.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 05.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithBeacon(beacon: BeaconDTO) {
        self.nameLabel.text = beacon.name
        self.uuidLabel.text = beacon.uuid
    }
}
