//
//  ReceiptsTableViewCell.swift
//  CardCart
//
//  Created by Jay Patel on 7/17/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit

class ReceiptsTableViewCell: UITableViewCell {

    @IBOutlet weak var rItemTitleLabel: UILabel!
    @IBOutlet weak var rItemStoreLabel: UILabel!
   
    @IBOutlet weak var rImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
