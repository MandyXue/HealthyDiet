//
//  RecipeTableViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit
import PKHUD

class RecipeTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var recipes: [NSDictionary]?
//    var recipeHelper = RecipeHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        RecipeHelper.getRecipesByIngredients(["cheese","tomato"]) { (recipeDic) -> Void in
//            self.recipes = recipeDic
//            self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source & delegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if recipes != nil {
            return (recipes?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeIngredientCell", forIndexPath: indexPath) as! RecipeIngredientTableViewCell
        if let temp = recipes {
            let recipe = temp[indexPath.row]
            cell.nameLabel?.text = recipe.objectForKey("name") as? String
            if let ingredients = recipe.objectForKey("ingredients") as? [String] {
                var text = ingredients[0]
                for (var i=1; i<ingredients.count; i++) {
                    text.appendContentsOf(", " + ingredients[i])
                }
                cell.ingredientLabel?.text? = text
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print(searchText)
            HUD.show(.Progress)
            self.recipes?.removeAll()
            RecipeHelper.getRecipesByIngredients(seperateIngredients(searchText)) { (recipeDic) -> Void in
                self.recipes = recipeDic
                self.tableView.reloadData()
                HUD.flash(.Success)
            }
        }
    }
    
    // MARK: - helper
    
    func seperateIngredients(searchText: String) -> [String] {
//        let regex = NSRegularExpression(pattern: "", options: .AnchorsMatchLines)
        
//        let ingredients = searchText.componentsSeparatedByString(",")
        let ingredients = searchText.regex("[a-zA-Z]+")
        return ingredients
    }

}

extension String {
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substringWithRange(r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
}
