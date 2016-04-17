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

    func storeDiets(name: String?, id: String?, searchText: String?, category: String?) throws {
        let newDiet = NSEntityDescription.insertNewObjectForEntityForName("DietModel", inManagedObjectContext: manageContext)
        newDiet.setValue(name, forKey: "name")
        newDiet.setValue(id, forKey: "id")
        newDiet.setValue(searchText, forKey: "searchText")
        newDiet.setValue(category, forKey: "category")
        do {
            try manageContext.save()
        } catch {
            print("Failure to save context: \(error)")
        }
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
    
}