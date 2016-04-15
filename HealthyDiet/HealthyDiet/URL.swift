//
//  URL.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/15.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation

enum URL {
    case SearchDiet, GetDietInfo, SearchDietImage, SearchRecipes
    func url() -> String {
        switch self {
        case .SearchDiet:
            return "http://api.nal.usda.gov/ndb/search"
        case .GetDietInfo:
            return "http://api.nal.usda.gov/ndb/nutrients"
        case .SearchDietImage:
            return ""
        case .SearchRecipes:
            return ""
        }
    }
}

let API_KEY = "5OMJXRPPVdX7LrXDQucMslEiYy9hVy4X0fsKE7v8"