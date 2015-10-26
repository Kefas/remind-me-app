//
//  BorderedButton.swift
//  remind-me-app
//
//  Created by Agnieszka Szczurek on 26.10.2015.
//  Copyright © 2015 AgnieszkaSzczurek. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 8.0;
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.whiteColor()
    }
   
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.layer.setBorderUIColor(GlobalConstants.Colors.BasicGrayColor)
            }
            else {
                self.layer.setBorderUIColor(GlobalConstants.Colors.BasicTurquoiseColor)
            }
            
        }
    }
    
}
