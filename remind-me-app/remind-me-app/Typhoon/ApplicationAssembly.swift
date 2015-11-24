//
//  ApplicationAssembly.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class ApplicationAssembly: TyphoonAssembly {

    var modelAssembly: ModelAssembly!
    var viewControllerAssembly: ViewControllerAssembly!
    
    dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self, configuration: { (definition) -> Void in
         //  definition.injectProperty("noteViewController", with: self.viewControllerAssembly.userNotesViewController())
        })
    }
    
    dynamic func mainStoryboard() -> AnyObject {
        return TyphoonDefinition.withClass(TyphoonStoryboard.self) {
            (definition) in
            definition.useInitializer("storyboardWithName:factory:bundle:") {
                (initializer) in
                initializer.injectParameterWith("Main")
                initializer.injectParameterWith(self)
                initializer.injectParameterWith(NSBundle.mainBundle())
            }
        }
    }

}
