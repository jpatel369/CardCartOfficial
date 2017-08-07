//
//  AddPhotoButton.swift
//  CardCart
//
//  Created by Jay Patel on 7/18/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import Foundation
import UIKit

class AddPhotoButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 20 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
        
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
        
    }
    
    
}
