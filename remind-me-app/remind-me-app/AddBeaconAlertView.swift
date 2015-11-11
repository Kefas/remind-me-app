//
//  AddBeaconAlertView.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 11.11.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

protocol AddBeaconViewDelegate : class {
    func addBeacon(view: AddBeaconAlertView, name: String, uuid: String)
}

class AddBeaconAlertView: UIViewController {

    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var delegate: AddBeaconViewDelegate?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = GlobalConstants.Colors.BasicTurquoiseColor
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButtonPressed(sender: AnyObject) {
        delegate?.addBeacon(self, name: nameTextField.text!, uuid: uuidTextField.text!)
    }
}
