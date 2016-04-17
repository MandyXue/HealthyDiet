//
//  DietDetailTableViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/13.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire
import PKHUD
import CoreData
import SwiftyJSON
import SDWebImage

class DietDetailTableViewController: UITableViewController {
    
    var diet: DietModel?
    
    let header = ["Food Information", "Nutrients", "Recipes"]
    let attributeKey = ["name","weight","measure"]
    
    var infoServiceCallComplete = false
    var recipeServiceCallComplete = false
    
    let dataModel = DataController()
    var imageURLs = [String]()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (diet?.nutrients?.count == 0 && diet?.recipes?.count == 0) {
//        if (diet?.nutrients?.count == 0) {
            HUD.show(.Progress)
            fetchDietInfo()
            searchRecipes()
            do {
                try self.dataModel.manageContext.save()
            } catch {
                print("Failure to save context: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 2) {
            if diet?.recipes?.count > 0 {
                return (diet?.recipes?.count)!
            }
            return 0
        } else if(section == 0) {
            return attributeKey.count
        } else if(section == 1) {
            if diet?.nutrients != nil {
                return (diet?.nutrients?.count)!
            }
            return 0
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
            if (diet?.recipes?.count > 0) {
                if let recipeArray = diet?.recipes?.allObjects as? [RecipeModel] {
                    let recipe = recipeArray[indexPath.row]
                    cell.recipeName.text = recipe.name
                    cell.caloriesDetail.text = recipe.calories
                    cell.dailyValue.text = recipe.totalWeights
                    cell.imageView?.image = UIImage(named: "recipe")
                    if let image = recipe.image {
                        // TODO: get image from url
                        let downloader = SDWebImageDownloader.sharedDownloader()
                        downloader.downloadImageWithURL(NSURL(string: image), options: .ProgressiveDownload, progress: { (receivedSize, expectedSize) -> Void in
//                            print("progress tracking \(receivedSize) \(expectedSize)")
                        }, completed: { (image, data, error, finished) -> Void in
                            if finished {
                                cell.imageView?.image = image
                            }
                        })
                    }
                }
            }
            return cell
        } else if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            cell.attributeName.text = attributeKey[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.attributeDetail.text = diet?.name
            case 1:
                cell.attributeDetail.text = diet?.weight?.stringValue
            case 2:
                cell.attributeDetail.text = diet?.measure
            default:
                cell.attributeDetail.text = "Something bad happened :("
            }
            return cell
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            if (diet?.nutrients?.count > 0) {
                if let nutrientArray = diet?.nutrients?.allObjects as? [NutrientModel] {
                    let nutrient = nutrientArray[indexPath.row]
                    cell.attributeName.text = nutrient.name
                    cell.attributeDetail.text = nutrient.value
                }
            }
            return cell
        }
        
        let cell = UITableViewCell()
        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    // MARK: - tableview delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 2) {
            return 112.0
        } else {
            return 45.0
        }
    }
    
    // MARK: - helper
    
    func numberToString(number: Float?) -> String? {
        // 处理number
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if let string = numberFormatter.stringFromNumber(number!) {
            return string
        }
        return nil
    }
    
    func stringToNumber(string: String?) -> Float? {
        // 处理number
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        if string != nil {
            return numberFormatter.numberFromString(string!)?.floatValue
        }
        return nil
    }
    
    // get diet info
    
    func fetchDietInfo() {
        if diet != nil {
            if diet?.nutrients?.count == 0 {
                if let nbno = diet?.id {
                    //                HUD.show(.Progress)
                    Alamofire.request(.GET, URL.GetDietInfo.url()+nbno)
                        .responseString { response in
                            switch response.result {
                            case .Success:
                                if let responseString = response.result.value {
                                    let xml = SWXMLHash.parse(responseString)
                                    
                                    // get weight
                                    if let weight = xml["report"]["foods"]["food"].element?.attributes["weight"] {
                                        self.diet?.weight = self.stringToNumber(weight)
                                    }
                                    
                                    // get measure
                                    if let measure = xml["report"]["foods"]["food"].element?.attributes["measure"] {
                                        self.diet?.measure = measure
                                    }
                                    
                                    // get nutrients
                                    for element in xml["report"]["foods"]["food"]["nutrients"]["nutrient"] {
                                        if let name = element.element?.attributes["nutrient"] {
                                            if let unit = element.element?.attributes["unit"] {
                                                if let value = element.element?.attributes["value"] {
                                                    let entity = NSEntityDescription.entityForName("NutrientModel", inManagedObjectContext: self.dataModel.manageContext)
                                                    let newNutrient = NutrientModel(entity: entity!, insertIntoManagedObjectContext: self.dataModel.manageContext)
                                                    newNutrient.value = value+" "+unit
                                                    newNutrient.name = name
                                                    self.diet?.addNutrientObject(newNutrient)
                                                }
                                            }
                                        }
                                    }
                                    // refresh data in core data
                                    self.infoServiceCallComplete = true
                                    self.handleServiceCallCompletion()
                                } else {
                                    self.serviceCallFail()
                                }
                                break
                            case .Failure(let error):
                                print(error)
                                self.serviceCallFail()
                            }
                    }
                }
            }
        }
    }
    
    // get recipes
    
    func searchRecipes() {
        if diet != nil {
            if diet?.recipes?.count == 0 {
                if let searchText = diet?.searchText {
                    HUD.show(.Progress)
                    let parameters = [
                        "q":searchText,
                        "app_id":API_KEY.Edamam_Id.key(),
                        "app_key":API_KEY.Edamam_Key.key(),
                        "to":"3"
                    ]
                    
                    Alamofire.request(.GET, URL.SearchRecipes.url(), parameters: parameters)
                        .responseJSON { response in
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    let recipes = json["hits"]
                                    
                                    for (_,recipe):(String, JSON) in recipes {
                                        if let name = recipe["recipe"]["label"].string {
                                            if let calories = recipe["recipe"]["calories"].float {
                                                if let weight = recipe["recipe"]["totalWeight"].float {
                                                    if let image = recipe["recipe"]["image"].string {
                                                        let entity = NSEntityDescription.entityForName("RecipeModel", inManagedObjectContext: self.dataModel.manageContext)
                                                        let newRecipe = RecipeModel(entity: entity!, insertIntoManagedObjectContext: self.dataModel.manageContext)
                                                        newRecipe.name = name
                                                        newRecipe.calories = self.numberToString(calories)
                                                        newRecipe.totalWeights = self.numberToString(weight)
                                                        newRecipe.image = image
                                                        self.diet?.addRecipeObject(newRecipe)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.recipeServiceCallComplete = true
                                    self.handleServiceCallCompletion()
                                    self.tableView.reloadData()
                                    HUD.flash(.Success)
                                } else {
                                    self.serviceCallFail()
                                }
                                break
                            case .Failure(let error):
                                print(error)
                                self.serviceCallFail()
                            }
                    }
                }
            }
        }
    }
    
    func handleServiceCallCompletion() {
        if self.infoServiceCallComplete && self.recipeServiceCallComplete {
            // Handle the fact that you're finished
            self.tableView.reloadData()
            HUD.flash(.Success)
        }
    }
    
    func serviceCallFail() {
        HUD.show(.Error)
        HUD.hide(afterDelay: 2.0)
    }

}
