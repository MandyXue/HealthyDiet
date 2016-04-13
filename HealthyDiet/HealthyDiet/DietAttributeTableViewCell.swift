//
//  DietAttributeTableViewCell.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/13.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit

class DietAttributeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attributeName: UILabel!
    @IBOutlet weak var attributeDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
