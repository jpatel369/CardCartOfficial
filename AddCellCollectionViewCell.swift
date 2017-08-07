//
//  AddCellCollectionViewCell.swift
//  CardCart
//
//  Created by Jay Patel on 7/16/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit

class AddCellCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var receiptImageView: UIImageView!
    
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
