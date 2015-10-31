//
//  IntroViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 26.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, RegisterViewControllerDelegate, LoginViewControllerDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var verticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonViewConstraint: NSLayoutConstraint!
   
    var viewControllerAssembly: ViewControllerAssembly?
    var model: LoginRegisterModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.alpha = 0
        animateLogo()
    }
    
    func animateLogo() {
       
        UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.logoImageView.alpha = 1
            }) { (Bool) -> Void in
                self.moveImageToTop()
        }
    }
    
    func moveImageToTop() {
        self.view.layoutIfNeeded()
        self.verticalCenterConstraint.active = false
        self.imageHeightConstraint.constant = 150
        self.imageWidthConstraint.constant = 150
        
        UIView.animateWithDuration(1.5, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
                self.bottomButtonViewConstraint.active = false
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(1.0)
                self.view.layoutIfNeeded()
                UIView.commitAnimations()
        }
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        let registerController: RegisterViewController = viewControllerAssembly!.registerViewController() as! RegisterViewController
        registerController.delegate = self
        presentViewController(registerController, animated: true, completion: nil)
    }
    
 
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let loginViewController: LoginViewController = viewControllerAssembly!.loginViewController() as! LoginViewController
        loginViewController.delegate = self
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func registerUser(registerData: RegisterUserDTO) {
        
        model.registerUser(registerData, completion: {
            (error: NSError?) -> Void in
            if error != nil {
              
            } else {
                self.showRootController()
            }
        })
    }
    
    func loginUserWithEmail(email: String, andPassword password: String) {
    
        model.loginUser(email: email, password: password) {
            (error: NSError?) -> Void in
            if(error != nil) {
                
            }
            else {
                self.showRootController()
            }
        }
    }
    
    func loginViewController(controller: LoginViewController, forgotPasswordForEmail email: String?) {
       
    }

    func showRootController() {
       self.presentedViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        let controller: UserNotesViewController = self.viewControllerAssembly?.userNotesViewController() as! UserNotesViewController
        let nv = UINavigationController(rootViewController: controller)
        self.showViewController(nv, sender: nil)
        })
    }
    
}
