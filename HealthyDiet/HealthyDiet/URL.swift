//
//  URL.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/15.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation

enum URL {
    case SearchDiet, GetDietInfo, GetSupermarketInfo, SearchRecipes, GetRecipesByIngredients
    func url() -> String {
        switch self {
        case .SearchDiet:
            return "http://api.nal.usda.gov/ndb/search"
        case .GetDietInfo:
            return "http://api.nal.usda.gov/ndb/nutrients?nutrients=205&nutrients=204&nutrients=208&format=xml&api_key="+API_KEY.NNDB.key()+"&ndbno="
        case .GetSupermarketInfo:
            return "http://www.supermarketapi.com/api.asmx/SearchByProductName"
        case .SearchRecipes:
            return "https://api.edamam.com/search"
        case .GetRecipesByIngredients:
            return "http://api.recipeon.us/2.0/recipe/suggest/"+API_KEY.Recipeon.key()+"/0/30/"
        }
    }
}

enum API_KEY {
    case Edamam_Id, Edamam_Key, Supermarket, NNDB, Recipeon
    func key() -> String {
        switch self {
        case .NNDB:
            return "5OMJXRPPVdX7LrXDQucMslEiYy9hVy4X0fsKE7v8"
        case .Edamam_Id:
            return "ecde4f7c"
        case .Edamam_Key:
            return "8ade7afbc8892d421a2f8e460768ed91"
        case .Supermarket:
            return "18940c8756"
        case .Recipeon:
            return "57138e53a00a6d3b0400002f"
        }
    }
}
