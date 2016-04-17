//
//  Recipe.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import CoreData


class Recipe: NSManagedObject {
    func addIngredientObject(ingredient: Ingredient) {
        self.mutableSetValueForKey("ingredients").addObject(ingredient)
    }
    func addIngredients(ingredients: [Ingredient]) {
        for ingredient in ingredients {
            self.mutableSetValueForKey("ingredients").addObject(ingredient)
        }
    }
}
