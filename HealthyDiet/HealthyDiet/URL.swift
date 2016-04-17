//
//  URL.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/15.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation

enum URL {
    case SearchDiet, GetDietInfo, GetSupermarketInfo, SearchRecipes
    func url() -> String {
        switch self {
        case .SearchDiet:
            return "http://api.nal.usda.gov/ndb/search"
        case .GetDietInfo:
            return "http://api.nal.usda.gov/ndb/nutrients?nutrients=205&nutrients=204&nutrients=208&format=xml&api_key="+API_KEY.NNDB.key()+"&ndbno="
        case .GetSupermarketInfo:
            return "http://www.supermarketapi.com/api.asmx/SearchByProductName?APIKEY=18940c8756&ItemName="
        case .SearchRecipes:
            return "https://api.edamam.com/search"
        }
    }
}

enum API_KEY {
    case Edamam_Id, Edamam_Key, Supermarket, NNDB
    func key() -> String {
        switch self {
        case .NNDB:
            return "5OMJXRPPVdX7LrXDQucMslEiYy9hVy4X0fsKE7v8"
        case .Edamam_Id:
            return "56048e5f"
        case .Edamam_Key:
            return "3504404f01497513c55214a286ef2300"
        case .Supermarket:
            return "18940c8756"
        }
    }
}