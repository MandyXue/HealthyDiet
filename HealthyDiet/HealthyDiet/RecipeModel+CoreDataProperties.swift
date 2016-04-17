//
//  RecipeModel+CoreDataProperties.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RecipeModel {

    @NSManaged var name: String?
    @NSManaged var calories: String?
    @NSManaged var image: String?
    @NSManaged var totalWeights: String?

}
