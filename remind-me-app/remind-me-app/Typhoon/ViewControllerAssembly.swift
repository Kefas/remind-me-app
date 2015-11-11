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
    
    dynamic func addNoteViewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "AddNoteViewController")
         controller.injectProperty("viewControllerAssembly", with: self)
        controller.injectProperty("loginModel", with: self.modelAssembly.loginRegisterModel())
        controller.injectProperty("noteModel", with: self.modelAssembly.noteModel())
        return controller
    }

    dynamic func userNotesViewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "UserNotesViewController")
        controller.injectProperty("viewControllerAssembly", with: self)
        controller.injectProperty("noteModel", with: self.modelAssembly.noteModel())
        controller.injectProperty("loginModel", with: self.modelAssembly.loginRegisterModel())
        return controller
    }
    
    dynamic func beaconListviewController() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "BeaconListViewController")
        controller.injectProperty("viewControllerAssembly", with: self)
        controller.injectProperty("beaconModel", with: self.modelAssembly.beaconModel())
        controller.injectProperty("loginModel", with: self.modelAssembly.loginRegisterModel())
        controller.injectProperty("noteModel", with: self.modelAssembly.noteModel())
        return controller
    }
    
    dynamic func addBeaconAlertView() -> AnyObject {
        let controller = TyphoonDefinition.withStoryboard(applicationAssembly.mainStoryboard(), storyboardID: "AddBeaconAlertView")
//        controller.injectProperty("viewControllerAssembly", with: self)
//        controller.injectProperty("loginModel", with: self.modelAssembly.loginRegisterModel())
//        controller.injectProperty("noteModel", with: self.modelAssembly.noteModel())
        return controller
    }

    
}
