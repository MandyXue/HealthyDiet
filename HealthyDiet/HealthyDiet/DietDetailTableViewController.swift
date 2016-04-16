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
import SwiftyJSON

class DietDetailTableViewController: UITableViewController {
    
    var diet: DietModel?
    
    let header = ["Food Information", "Nutrients", "Recipes"]
    let attributeKey = ["name","weight","measure"]
    
    var infoServiceCallComplete = false
    var recipeServiceCallComplete = false
    
    let dataModel = DataController()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (diet?.nutrients == nil && diet?.recipes == nil) {
            HUD.show(.Progress)
            fetchDietInfo()
            searchRecipes()
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
            if diet?.recipes != nil {
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
            if (diet?.recipes != nil) {
                if let recipe = diet?.recipes?.objectAtIndex(indexPath.row) as? Recipe {
                    cell.recipeName.text = recipe.name
                    cell.caloriesDetail.text = recipe.caloriesInString()
                    cell.dailyValue.text = recipe.totalWeightsInString()
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
            if (diet?.nutrients != nil) {
                if let nutrient = diet?.nutrients?.objectAtIndex(indexPath.row) as? Nutrient {
                    cell.attributeName.text = nutrient.name
                    cell.attributeDetail.text = nutrient.toString()
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
            if diet?.nutrients == nil {
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
                                    self.diet?.nutrients = NSMutableArray()
                                    for element in xml["report"]["foods"]["food"]["nutrients"]["nutrient"] {
                                        if let name = element.element?.attributes["nutrient"] {
                                            if let unit = element.element?.attributes["unit"] {
                                                if let value = element.element?.attributes["value"] {
                                                    self.diet?.nutrients?.addObject(Nutrient(name: name, unit: unit, value: value))
                                                }
                                            }
                                        }
                                    }
                                    self.diet?.setValue(self.diet?.nutrients, forKey: "nutrients")
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
            if diet?.recipes == nil {
                if let searchText = diet?.searchText {
                    HUD.show(.Progress)
                    let parameters = [
                        "q":searchText,
                        "app_id":API_KEY.Edamam_Id.key(),
                        "app_key":API_KEY.Edamam_Key.key(),
                        "to":"5"
                    ]
                    
                    Alamofire.request(.GET, URL.SearchRecipes.url(), parameters: parameters)
                        .responseJSON { response in
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    let recipes = json["hits"]
                                    self.diet?.recipes = NSMutableArray()
                                    for (_,recipe):(String, JSON) in recipes {
                                        if let name = recipe["recipe"]["label"].string {
                                            if let calories = recipe["recipe"]["calories"].float {
                                                if let weight = recipe["recipe"]["totalWeight"].float {
                                                    let newRecipe = Recipe(name: name, calories: calories, totalWeights: weight)
                                                    if let imageURL = recipe["recipe"]["image"].string {
                                                        newRecipe.setImage(imageURL)
                                                    }
                                                    self.diet?.recipes?.addObject(Recipe(name: name, calories: calories, totalWeights: weight))
                                                }
                                            }
                                        }
                                        
                                    }
                                    self.diet?.setValue(self.diet?.nutrients, forKey: "nutrients")
                                    self.recipeServiceCallComplete = true
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
    
    func handleServiceCallCompletion() {
        if self.infoServiceCallComplete && self.recipeServiceCallComplete {
            // Handle the fact that you're finished
            
            self.tableView.reloadData()
            do {
                try self.dataModel.updateDiet(self.diet!)
                print("success save")
            } catch {
                print("\(error)")
            }
            HUD.flash(.Success)
        }
    }
    
    func serviceCallFail() {
        HUD.show(.Error)
        HUD.hide(afterDelay: 2.0)
    }

}
