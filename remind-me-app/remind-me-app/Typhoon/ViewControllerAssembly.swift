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
    var serviceAssembly: ServiceAssembly!
    var modelAssembly: ModelAssembly!
    
     dynamic func registerViewController() -> AnyObject {
        let definition = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "RegisterViewController")
        return definition
    }
    
     dynamic func loginViewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "LoginViewController")
        
        return controller
    }
    
     dynamic func introViewController() -> AnyObject {
        return TyphoonDefinition.withClass(IntroViewController.self) {
            (definition) in
            definition.injectProperty("model", with: self.modelAssembly.loginRegisterModel())
            definition.injectProperty("viewControllerAssembly", with: self)
        
        }
    }
    
    dynamic func viewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "ViewController")
        return controller
    }

}
