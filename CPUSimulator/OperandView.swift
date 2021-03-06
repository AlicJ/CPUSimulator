//
//  OperandView.swift
//  CPUSimulator
//
//  Created by Alic on 2016-12-22.
//  Copyright © 2016 4ZC3. All rights reserved.
//

import UIKit

class OperandView: UIViewWrapper {    
    
    fileprivate let opValue = UILabel()
    
    override internal var value: String {
        get {
            if opValue.text == nil {
                return ""
            }
            return opValue.text!
        }
        set {
            opValue.text = newValue
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        opValue.frame = Sizes.operand.frame
        opValue.font = opValue.font.withSize(Sizes.operand.font)
        opValue.textAlignment = NSTextAlignment.center
        opValue.layer.borderWidth = 1
        self.addSubview(opValue)
    }
    
    convenience init(frame: CGRect, type: ViewType) {
        self.init(frame: frame)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
