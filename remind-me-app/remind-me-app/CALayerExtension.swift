//
//  CALayerExtension.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 25.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import Foundation

extension CALayer {
    
    func setBorderUIColor(color: UIColor) {
        self.borderColor = color.CGColor
    }
    
    func borderUIColor() -> UIColor {
        return UIColor(CGColor: self.borderColor!)
    }
}