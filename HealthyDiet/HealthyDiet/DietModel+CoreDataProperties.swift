//
//  DietModel+CoreDataProperties.swift
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

extension DietModel {

    @NSManaged var category: String?
    @NSManaged var measure: String?
    @NSManaged var name: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var searchText: String?
    @NSManaged var id: String?
    @NSManaged var recipes: NSSet?
    @NSManaged var nutrients: NSSet?
    @NSManaged var image: String?

}
