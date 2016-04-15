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
    var information = [String:String]()
    
    init(name: String, id: String, category: String, measure: String, weight: String) {
        information["name"] = name
        information["weight"] = weight
        information["measure"] = measure
        self.name = name
        self.id = id
        self.category = category
        self.measure = measure
        // 处理number
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if let number = numberFormatter.numberFromString(weight) {
            self.weight = number.floatValue
        }
    }
    
}