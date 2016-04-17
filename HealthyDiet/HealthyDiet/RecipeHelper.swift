//
//  RecipeHelper.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecipeHelper {
    
//    var dataModel = DataController()
    
    static func getRecipesByIngredients(ingredients:[String], resultHandler: ([NSDictionary]) -> Void) {
        if ingredients.count > 0 {
            // deal with url myself.....
            var ingredientRequest = ingredients[0]
            for (var i=1; i<ingredients.count; i++) {
                ingredientRequest.appendContentsOf("&"+ingredients[i])
            }
            var url = URL.GetRecipesByIngredients.url()
            url.appendContentsOf(ingredientRequest)
            // use json to get
            Alamofire.request(.GET, url).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let recipeJSON = json["response"]["docs"].array!
                        let recipes = recipeJSON.map ({ (recipe) -> NSDictionary in
                            let name = recipe["title"].string
                            let ingredients = recipe["ingredient"].array!.map {$0.string!}
                            
//                            self.dataModel.storeRecipes(name, ingredients: ingredients)
                            return ["name": name!, "ingredients": ingredients]
                        })
                        resultHandler(recipes)
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
}