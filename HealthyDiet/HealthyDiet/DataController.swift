//
//  DataController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/16.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataController: NSObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var manageContext:NSManagedObjectContext
    
    override init() {
        manageContext = appDelegate.managedObjectContext
    }

    func storeDiets(diet: Diet) throws {
        let newDiet = NSEntityDescription.insertNewObjectForEntityForName("DietModel", inManagedObjectContext: manageContext)
        newDiet.setValue(diet.name, forKey: "name")
        newDiet.setValue(diet.id, forKey: "id")
        newDiet.setValue(diet.searchText, forKey: "searchText")
        newDiet.setValue(diet.weight, forKey: "weight")
        newDiet.setValue(diet.measure, forKey: "measure")
        newDiet.setValue(diet.category, forKey: "category")
//        do {
//            try manageContext.save()
//        } catch {
//            print("Failure to save context: \(error)")
//        }
    }
    
    func getDietsFromCoreData(page: Int, size: Int, resultHandler: ([DietModel]?) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: "DietModel")
        
        fetchRequest.fetchLimit = size
        fetchRequest.fetchOffset = page
        
        do {
            let fetchResult = try manageContext.executeFetchRequest(fetchRequest)
            let list = fetchResult.map { $0 as! DietModel }
            resultHandler(list)
            print(list)
        } catch {
            resultHandler(nil)
            print("Failure to save context: \(error)")
        }
        
    }
    
    func updateDiet(diet: DietModel) throws {
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("DietModel", inManagedObjectContext: manageContext)
        // Initialize Batch Update Request
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)
        // Configure Batch Update Request
        batchUpdateRequest.resultType = .UpdatedObjectIDsResultType
        // Configure Batch Update Request
        batchUpdateRequest.propertiesToUpdate = ["nutrients": NSNumber(bool: true)]
        batchUpdateRequest.propertiesToUpdate = ["recipes": NSNumber(bool: true)]
        batchUpdateRequest.propertiesToUpdate = ["weight": NSNumber(bool: true)]
        batchUpdateRequest.propertiesToUpdate = ["measure": NSNumber(bool: true)]
        
//        do {
//            try manageContext.save()
//        } catch {
//            print("Failure to save context: \(error)")
//        }
    }
}