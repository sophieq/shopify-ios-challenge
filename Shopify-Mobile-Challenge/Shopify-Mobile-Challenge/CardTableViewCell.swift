//
//  CardTableViewCell.swift
//  Shopify-Mobile-Challenge
//
//  Created by Sophie Qin on 2019-01-16.
//  Copyright © 2019 Sophie Qin. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
