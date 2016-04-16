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
    var image: UIImage? = UIImage(named: "recipe")
    var ingredients: [String] = []
    var healthLabels: [String] = []
    var totalWeights: Float = 0.0
    var nutrients: [Nutrient] = []
    
    init(name: String, calories: Float, totalWeights: Float) {
        self.name = name
        self.calories = calories
        self.totalWeights = totalWeights
    }
    
    func setImage(imageURL: String) {
        let url = NSURL(string: imageURL)
        getDataFromUrl(url!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.image = UIImage(data: data)
            }
        }
    }
    
    func caloriesInString() -> String {
        return "\(calories) kcal"
    }
    
    func totalWeightsInString() -> String {
        return "\(totalWeights) g"
    }
}