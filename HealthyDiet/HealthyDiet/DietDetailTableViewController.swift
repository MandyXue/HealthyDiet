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

class DietDetailTableViewController: UITableViewController {
    
    var diet: Diet?
    
    let header = ["Food Information", "Nutrients", "Recipes"]
    let attributeKey = ["name","weight","measure"]
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDietInfo()
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
            cell.recipeImage.image = UIImage(named: "defaultImage")
            cell.recipeName.text = "recipe name testing bla bla bla"
            cell.caloriesDetail.text = "1480"
            cell.dailyValue.text = "74%"
            return cell
        } else if(indexPath.section == 0) {
            print("section:\(indexPath.section), row:\(indexPath.row)")
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            cell.attributeName.text = attributeKey[indexPath.row]
            cell.attributeDetail.text = diet?.information[attributeKey[indexPath.row]]
            return cell
        } else if(indexPath.section == 1) {
            print("section:\(indexPath.section), row:\(indexPath.row)")
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            if (diet?.nutrients.count > 0) {
                cell.attributeName.text = diet?.nutrients[indexPath.row].name
                if let unit = diet?.nutrients[indexPath.row].unit {
                    if let valueStr = numberToString(diet?.nutrients[indexPath.row].value) {
                        cell.attributeDetail.text = valueStr + unit
                    }
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
    
    func fetchDietInfo() {
        if diet != nil && diet?.nutrients.count == 0 {
            if let nbno = diet?.id {
                HUD.show(.Progress)
                Alamofire.request(.GET, URL.GetDietInfo.url()+nbno)
                    .responseString { response in
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
                            HUD.flash(.Success)
                        } else {
                            HUD.show(.Error)
                            HUD.hide(afterDelay: 2.0)
                        }
                }
            }
        }
    }
    
    // TODO: get recipes

}
