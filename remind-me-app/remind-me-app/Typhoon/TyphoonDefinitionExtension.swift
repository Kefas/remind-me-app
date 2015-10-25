//
//  TyphoonDefinitionExtension.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

extension TyphoonDefinition {
    
    class func withStoryboard(storyboard: AnyObject, storyboardID: String) -> TyphoonDefinition {
        return TyphoonDefinition.withFactory(storyboard, selector: "instantiateViewControllerWithIdentifier:", parameters: {
            (factoryMethod) in
            factoryMethod.injectParameterWith(storyboardID)
        }) as! TyphoonDefinition
    }
}

