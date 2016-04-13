//
//  DietTableViewCell.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/11.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit

class DietTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCategory: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
