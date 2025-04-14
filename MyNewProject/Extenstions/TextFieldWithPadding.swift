//
//  TextFieldWithPadding.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 18.03.2025.
//

import UIKit

class TextFieldWithPadding: UITextField{
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
}
