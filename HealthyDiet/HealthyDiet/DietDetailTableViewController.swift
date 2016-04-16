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
    
    var diet: Diet?
    
    let header = ["Food Information", "Nutrients", "Recipes"]
    let attributeKey = ["name","weight","measure"]
    
    var infoServiceCallComplete = false
    var recipeServiceCallComplete = false
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        HUD.show(.Progress)
        fetchDietInfo()
        searchRecipes()
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
            return (diet?.recipes.count)!
        } else if(section == 0) {
            return attributeKey.count
        } else if(section == 1) {
            return (diet?.nutrients.count)!
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
            if (diet?.recipes.count > 0) {
                cell.recipeImage.image = diet?.recipes[indexPath.row].image
                cell.recipeName.text = diet?.recipes[indexPath.row].name
                cell.caloriesDetail.text = diet?.recipes[indexPath.row].caloriesInString()
                cell.dailyValue.text = diet?.recipes[indexPath.row].totalWeightsInString()
            }
            return cell
        } else if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            cell.attributeName.text = attributeKey[indexPath.row]
            cell.attributeDetail.text = diet?.information[attributeKey[indexPath.row]]
            return cell
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            if (diet?.nutrients.count > 0) {
                cell.attributeName.text = diet?.nutrients[indexPath.row].name
                cell.attributeDetail.text = diet?.nutrients[indexPath.row].toString()
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
    
    // get diet info
    
    func fetchDietInfo() {
        if diet != nil && diet?.nutrients.count == 0 {
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
                                    self.diet?.setWeight(weight)
                                }
                                
                                // get measure
                                if let measure = xml["report"]["foods"]["food"].element?.attributes["measure"] {
                                    self.diet?.setMeasure(measure)
                                }
                                
                                // get nutrients
                                for element in xml["report"]["foods"]["food"]["nutrients"]["nutrient"] {
                                    if let name = element.element?.attributes["nutrient"] {
                                        if let unit = element.element?.attributes["unit"] {
                                            if let value = element.element?.attributes["value"] {
                                                self.diet?.addNutrients(Nutrient(name: name, unit: unit, value: value))
                                            }
                                        }
                                    }
                                }
                                self.tableView.reloadData()
                                print("fetch diet completed")
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
    
    // get recipes
    
    func searchRecipes() {
        if diet != nil && diet?.recipes.count == 0 {
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
                                for (_,recipe):(String, JSON) in recipes {
                                    if let name = recipe["recipe"]["label"].string {
                                        if let calories = recipe["recipe"]["calories"].float {
                                            if let weight = recipe["recipe"]["totalWeight"].float {
                                                let newRecipe = Recipe(name: name, calories: calories, totalWeights: weight)
                                                if let imageURL = recipe["recipe"]["image"].string {
                                                    newRecipe.setImage(imageURL)
                                                }
                                                self.diet?.addRecipes(newRecipe)
                                            }
                                        }
                                    }
                                    
                                }
                                self.tableView.reloadData()
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
    
    func handleServiceCallCompletion() {
        if self.infoServiceCallComplete && self.recipeServiceCallComplete {
            // Handle the fact that you're finished
            HUD.flash(.Success)
        }
    }
    
    func serviceCallFail() {
        HUD.show(.Error)
        HUD.hide(afterDelay: 2.0)
    }

}
