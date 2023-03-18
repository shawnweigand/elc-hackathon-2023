//
//  InventoryService.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import Foundation


class InventoryService {
    
    func list() -> [Product] {
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.object(forKey: "inventory") as? Data {
            do {
                let savedProducts = try JSONDecoder().decode([Product].self, from: savedData)
                return savedProducts
            } catch {
                // handle the error here
            }
        }
        // add a return statement outside the if statement to return a default value if the if statement fails
        return []
    }
    
    func add(product: Product) {
        var products = list() // get the current list of products
        
        // check if the product already exists based on its slug
        if products.contains(where: { $0.slug == product.slug }) {
            print("Product already exists.")
        } else {
            // add the new product to the list
            products.append(product)
            // save the updated list to UserDefaults
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(products) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(encoded, forKey: "inventory")
            }
        }
    }
    
    
    
    
}
