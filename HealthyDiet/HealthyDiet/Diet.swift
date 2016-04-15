//
//  Diet.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/14.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation

class Diet {
    
    var name: String?
    var id: String?
    var category: String?
    var measure: String?
    var weight: Float = 0.0
    var nutrients: [Nutrient] = []
    var recipes: [Recipe] = []
    var searchText: String?
    
    // help to load data in detail view controller
    var information = [String:String]()
    
    init(name: String, id: String, category: String, searchText: String) {
        information["name"] = name
        self.name = name
        self.id = id
        self.category = category
        self.searchText = searchText
    }
    
    func setWeight(weight: String) {
        information["weight"] = weight
        // 处理number
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if let number = numberFormatter.numberFromString(weight) {
            self.weight = number.floatValue
        }
    }
    
    func setMeasure(measure: String) {
        information["measure"] = measure
        self.measure = measure
    }
    
    func addNutrients(nutrient: Nutrient?) {
        if nutrient != nil {
            self.nutrients.append(nutrient!)
        }
    }
    
    func addRecipes(recipe: Recipe?) {
        if recipe != nil {
            self.recipes.append(recipe!)
        }
    }
    
}