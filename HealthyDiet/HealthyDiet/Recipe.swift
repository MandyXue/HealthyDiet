//
//  Recipe.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/15.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    var name: String?
    var calories: Float = 0.0
    var image: UIImage?
    var ingredientNumber: Int = 0
    
    init(name: String, calories: Float, image: UIImage, ingredientNumber: Int) {
        self.name = name
        self.calories = calories
        self.image = image
        self.ingredientNumber = ingredientNumber
    }
}