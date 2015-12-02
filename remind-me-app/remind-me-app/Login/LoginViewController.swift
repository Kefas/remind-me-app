//
//  LoginViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginUserWithEmail(email: String, andPassword password: String, indicator: UIActivityIndicatorView)
    func loginViewController(controller: LoginViewController, forgotPasswordForEmail email: String?)
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
     weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginIndicator.hidden = true
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logInButtonPressed(sender: UIButton) {
        loginIndicator.hidden = false
        loginIndicator.startAnimating()
        let email = emailTextField.text
        let password = passwordTextField.text
        delegate?.loginUserWithEmail(email!, andPassword: password!, indicator: loginIndicator)
    }
    
    @IBAction func forgotPasswordPressed(sender: UIButton) {
        let email = emailTextField.text
        delegate?.loginViewController(self, forgotPasswordForEmail: email)
    }

}

