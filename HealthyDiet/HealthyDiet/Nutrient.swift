//
//  Nutrient.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/14.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation

class Nutrient {
    var name: String?
    var unit: String?
    var value: Float = 0.0
    
    init(name: String, unit: String, value: String) {
        self.name = name
        self.unit = unit
        // 处理value
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if let number = numberFormatter.numberFromString(value) {
            self.value = number.floatValue
        }
    }
}