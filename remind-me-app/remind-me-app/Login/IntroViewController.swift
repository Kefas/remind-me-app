//
//  IntroViewController.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 26.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var verticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonViewConstraint: NSLayoutConstraint!
   
     var viewControllerAssembly: ViewControllerAssembly?
    
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
        presentViewController(registerController, animated: true, completion: nil)
    }
    
 
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let loginViewController: LoginViewController = viewControllerAssembly!.loginViewController() as! LoginViewController
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
}
