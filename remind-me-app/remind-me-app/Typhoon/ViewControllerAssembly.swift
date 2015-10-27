//
//  ViewControllerAssembly.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class ViewControllerAssembly: TyphoonAssembly {

    var applicationAssembly: ApplicationAssembly!
    
     dynamic func registerViewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "RegisterViewController")
        
        return controller
    }
    
     dynamic func loginViewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "LoginViewController")
        
        return controller
    }
    
     dynamic func introViewController() -> AnyObject {
        return TyphoonDefinition.withClass(IntroViewController.self) {
            (definition) in
                    definition.injectProperty("viewControllerAssembly", with: self)
        
        }
    }

}
