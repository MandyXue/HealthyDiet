//
//  DietHelper.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/17.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class DietHelper {
    
    static func getImageForDiet(searchText: String, resultHandler: (String?) -> Void) {
        let parameters : [String:String] = [
            "APIKEY":"18940c8756",
            "ItemName":searchText
        ]
        Alamofire.request(.GET, URL.GetSupermarketInfo.url(), parameters: parameters)
            .responseString { response in
                if let responseString = response.result.value {
                    let xml = SWXMLHash.parse(responseString)
                    if let image = xml["ArrayOfProduct"]["Product"][0]["ItemImage"].element?.text {
                        resultHandler(image)
                    }
                } else {
                    resultHandler(nil)
                }
        }
    }
}