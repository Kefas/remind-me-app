//
//  ServiceAssembly.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 27.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class ServiceAssembly: TyphoonAssembly {
    
    dynamic func serverClient() -> AnyObject {
        return TyphoonDefinition.withClass(ServerClient.self) {
            (definition) in
            definition.scope = TyphoonScope.Singleton
        }
    }

}
