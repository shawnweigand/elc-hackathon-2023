//
//  Products.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import Foundation
import SwiftyJSON

class ProductsService {
    
    let jsonFileName: String = "products"
    
    
    
    func list() -> [Product] {
        
        var products: [Product] = []

        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSON(data: data)

                for item in json.arrayValue {
                    let product = Product(id: item["id"].intValue,
                                          name: item["name"].stringValue,
                                          slug: item["slug"].stringValue,
                                          description: item["description"].stringValue,
                                          skinTypes: item["skin_types"].arrayValue.map { $0.stringValue },
                                          skinConcern: item["skin_concern"].arrayValue.map { $0.stringValue },
                                          category: item["category"].stringValue,
                                          price: item["price"].doubleValue,
                                          howToUse: item["how_to_use"].stringValue,
                                          ingredients: item["ingredients"].dictionaryValue.mapValues { $0.stringValue },
                                          colors: item["colors"].arrayValue.map { $0.stringValue },
                                          images: item["images"].arrayValue.map { $0.stringValue })
                    products.append(product)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        return products
    }
}
