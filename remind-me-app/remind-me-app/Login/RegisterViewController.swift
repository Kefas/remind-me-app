//
//  RegisterViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 26.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

protocol RegisterViewControllerDelegate: class {
    func registerUser(registerData: RegisterUserDTO)
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    weak var delegate: RegisterViewControllerDelegate?
    var serverClient: ServerClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        delegate?.registerUser(constructDataFromForm())
    }
    
    private func constructDataFromForm() -> RegisterUserDTO {
        let email = emailTextField.text
        let password = passwordTextField.text
        return RegisterUserDTO(id: 0, email: email!, password: password!, token: "")
    }
   
}
