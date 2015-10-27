//
//  ModelAssembly.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class ModelAssembly: TyphoonAssembly {

    var serviceAssembly: ServiceAssembly!
    
    dynamic func loginRegisterModel() -> AnyObject {
        let definition: TyphoonDefinition! = TyphoonDefinition.withClass(LoginRegisterModel.self) as! TyphoonDefinition
        definition.useInitializer("initWithServerClient:", parameters: {
            (initializer: TyphoonMethod!) -> Void in
            initializer.injectParameterWith(self.serviceAssembly.serverClient())
        })
        return definition
    }
    
}
