//
//  CustomCollectionCell.swift
//  Shopify-Mobile-Challenge
//
//  Created by Sophie Qin on 2019-01-12.
//  Copyright © 2019 Sophie Qin. All rights reserved.
//

import UIKit

class CustomCollectionCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageCollection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
