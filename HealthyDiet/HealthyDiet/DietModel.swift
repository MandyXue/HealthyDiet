//
//  DietModel.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import CoreData


class DietModel: NSManagedObject {
    
    func addNutrientObject(nutrient: NutrientModel) {
        self.mutableSetValueForKey("nutrients").addObject(nutrient)
    }
    
    func addNutrients(nutrients: NSSet) {
        self.willChangeValueForKey("nutrients", withSetMutation: .UnionSetMutation, usingObjects: nutrients as Set<NSObject>)
        self.primitiveValueForKey("nutrients")
        self.didChangeValueForKey("nutrients", withSetMutation: .UnionSetMutation, usingObjects: nutrients as Set<NSObject>)
    }

}
