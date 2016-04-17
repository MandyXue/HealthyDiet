//
//  RecipeIngredientTableViewCell.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/18.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit

class RecipeIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
